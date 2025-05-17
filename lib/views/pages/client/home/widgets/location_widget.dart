import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/config/icon.dart';
import 'package:computer_sales_app/helpers/text_helper.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationWidget extends StatefulWidget {
  const LocationWidget({
    super.key,
  });

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  String _location = 'Finding location...';
  @override
  void initState() {
    super.initState();
    getLocation();
  }

  Future<void> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      // Check if location service is enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          setState(() {
            _location = "Location services are disabled";
          });
        }
        return;
      }

      // Check and request permission if necessary
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            setState(() {
              _location = "Location permissions are denied";
            });
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          setState(() {
            _location = "Location permissions are permanently denied";
          });
        }
        return;
      }

      // Fetch the current position
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      );

      // Get the placemark from the coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        if (mounted) {
          setState(() {
            _location =
                "${place.street}, ${place.subAdministrativeArea}, ${place.locality}";
          });
        }

        // Save location to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('location_current', _location);
      } else {
        if (mounted) {
          setState(() {
            _location = "Unable to fetch address";
          });
        }
      }
    } catch (e) {
      // Handle any errors that occur during the location fetch process
      if (mounted) {
        setState(() {
          _location = "Failed to get location: $e";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: [
          Row(
            spacing: 5,
            children: [
              Icon(
                Icons.location_on_rounded,
                color: AppColors.secondary,
                size: IconSize.large,
              ),
              Text(
                TextHelper.textLimit(_location, 25),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
