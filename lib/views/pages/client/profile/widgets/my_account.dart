import 'dart:convert';

import 'package:computer_sales_app/components/custom/my_text_field.dart';
import 'package:computer_sales_app/components/custom/snackbar.dart';
import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:computer_sales_app/utils/widget/CustomAppBarMobile.dart';
import 'package:computer_sales_app/views/pages/client/login/widgets/button.dart';
import 'package:computer_sales_app/views/pages/client/login/widgets/otp_input.dart';
import 'package:computer_sales_app/views/pages/client/profile/widgets/listTile_custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyAccountView extends StatefulWidget {
  const MyAccountView({super.key});

  @override
  State<MyAccountView> createState() => _MyAccountView();
}

class _MyAccountView extends State<MyAccountView> {
  List<Map<String, dynamic>> myAccountItems = [
    {'title': 'Personal Information', 'icon': CupertinoIcons.person},
    {'title': 'Change Password', 'icon': CupertinoIcons.lock},
    {'title': 'Address', 'icon': CupertinoIcons.location_north},
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) => listTileCustom(
        myAccountItems[index]['icon'],
        myAccountItems[index]['title'],
        onTap: () {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PersonelInformation(),
              ),
            );
          }
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangePassword(),
              ),
            );
          }
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddressPage(),
              ),
            );
          }
        },
      ),
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey.shade300,
        thickness: 1,
        height: 0,
      ),
      itemCount: myAccountItems.length,
    );
  }
}

//Personal Information
class PersonelInformation extends StatefulWidget {
  const PersonelInformation({super.key});

  @override
  State<PersonelInformation> createState() => _PersonelInformationState();
}

class _PersonelInformationState extends State<PersonelInformation> {
  final bool _loading = false;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final FocusNode _fullNameFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarMobile(
        title: 'Personal Information',
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 15,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary,
                        width: 3,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/avatar.jpeg'),
                    ),
                  ),
                  Positioned(
                    bottom: -10,
                    right: 0,
                    child: IconButton(
                      padding: const EdgeInsets.all(8),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          const Color.fromARGB(255, 73, 73, 73),
                        ),
                        shape: WidgetStateProperty.all(
                          const CircleBorder(),
                        ),
                      ),
                      onPressed: () {},
                      icon: Icon(
                        CupertinoIcons.camera,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Text(
                    'Full Name',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  MyTextField(
                    hintText: 'Seibon',
                    prefixIcon: CupertinoIcons.person,
                    controller: _fullNameController,
                    focusNode: _fullNameFocusNode,
                    obscureText: false,
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Text(
                    'Phone Number',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  MyTextField(
                    hintText: '0357378876',
                    prefixIcon: CupertinoIcons.phone,
                    controller: _phoneNumberController,
                    focusNode: _phoneNumberFocusNode,
                    obscureText: false,
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  MyTextField(
                    hintText: 'example@gmail.com',
                    prefixIcon: CupertinoIcons.envelope,
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    obscureText: false,
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Text(
                    'Address',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  MyTextField(
                    hintText: 'District 1, HCM City',
                    prefixIcon: CupertinoIcons.location,
                    controller: _addressController,
                    focusNode: _addressFocusNode,
                    obscureText: false,
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: MyButton(
                  text: 'Change Information',
                  isLoading: _loading,
                  onTap: (_) => {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Change Password
class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController otp1Controller = TextEditingController();
  final TextEditingController otp2Controller = TextEditingController();
  final TextEditingController otp3Controller = TextEditingController();
  final TextEditingController otp4Controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarMobile(
        title: 'Change Password',
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        child: Container(
          padding: !Responsive.isMobile(context)
              ? EdgeInsets.only(top: 16, left: 64, right: 64)
              : EdgeInsets.only(top: 16, left: 16, right: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 20,
              children: [
                SizedBox(
                  width: 250,
                  child: Column(
                    children: [
                      Text(
                        'Enter your verification code!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Please enter the code sent to your email address.',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 20,
                  children: [
                    Flexible(
                        child: OtpInput(
                            controller: otp1Controller, autoFocus: true)),
                    Flexible(child: OtpInput(controller: otp2Controller)),
                    Flexible(child: OtpInput(controller: otp3Controller)),
                    Flexible(child: OtpInput(controller: otp4Controller)),
                  ],
                ),
                MyButton(
                  text: 'Get code',
                  isLoading: false,
                  onTap: (_) => {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//Address
class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  List<dynamic> provinces = [];
  List<dynamic> districts = [];
  List<dynamic> wards = [];
  String? selectedProvinceCode;
  String? selectedDistrictCode;
  String? selectedWardCode;
  String currentAddress = '';
  String _addressOption = 'current';
  bool _addNewAddress = false;
  List<String> savedAddresses = [];

  @override
  void initState() {
    super.initState();
    loadSavedLocation();
    fetchProvinces();
    getSavedAddresses();
  }

  Future<void> loadSavedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentAddress = prefs.getString('location_current') ?? 'No address set';
    });
  }

  Future<void> getSavedAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> checkSavedAddresses =
        prefs.getStringList('manual_location') ?? [];
    if (!checkSavedAddresses.contains(currentAddress)) {
      checkSavedAddresses.add(currentAddress);
      await prefs.setStringList('manual_location', checkSavedAddresses);
    }
    setState(() {
      savedAddresses = checkSavedAddresses;
    });
  }

  Future<void> fetchProvinces() async {
    try {
      final res = await http
          .get(Uri.parse('https://provinces.open-api.vn/api/?depth=1'));
      if (res.statusCode == 200) {
        setState(() {
          provinces = jsonDecode(utf8.decode(res.bodyBytes));
        });
      } else {
        throw Exception('Failed to load provinces');
      }
    } catch (e) {
      debugPrint('Error loading provinces: $e');
    }
  }

  Future<void> fetchDistricts(String provinceCode) async {
    try {
      final res = await http.get(Uri.parse(
          'https://provinces.open-api.vn/api/p/$provinceCode?depth=2'));
      if (res.statusCode == 200) {
        final data = jsonDecode(utf8.decode(res.bodyBytes));
        setState(() {
          districts = data['districts'];
        });
      } else {
        throw Exception('Failed to load districts');
      }
    } catch (e) {
      debugPrint('Error loading districts: $e');
    }
  }

  Future<void> fetchWards(String districtCode) async {
    try {
      final res = await http.get(Uri.parse(
          'https://provinces.open-api.vn/api/d/$districtCode?depth=2'));
      if (res.statusCode == 200) {
        final data = jsonDecode(utf8.decode(res.bodyBytes));
        setState(() {
          wards = data['wards'];
        });
      } else {
        throw Exception('Failed to load wards');
      }
    } catch (e) {
      debugPrint('Error loading wards: $e');
    }
  }

  Future<void> saveLocationToPreferences(String newAddress) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedAddresses = prefs.getStringList('manual_location') ?? [];
    prefs.setStringList('manual_location', savedAddresses);
    if (!savedAddresses.contains(newAddress)) {
      savedAddresses.add(newAddress);
      await prefs.setStringList('manual_location', savedAddresses);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarMobile(title: 'Address'),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Display current location
                Card(
                  color: Colors.white,
                  elevation: 0,
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red.withAlpha(50),
                      ),
                      child: Icon(
                        Icons.location_on,
                        color: Colors.red,
                      ),
                    ),
                    title: Text('Current Location'),
                    subtitle: Text(currentAddress),
                  ),
                ),
                if (savedAddresses.isNotEmpty)
                  const SizedBox(
                    height: 16,
                  ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Select your address',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54),
                    textAlign: TextAlign.start,
                  ),
                ),
                ...savedAddresses.map((address) {
                  return Card(
                    color: Colors.white,
                    child: ListTile(
                      title: Text('Location'),
                      subtitle: Text(address),
                      trailing: Radio<String>(
                        value: address,
                        groupValue: currentAddress,
                        onChanged: (value) {
                          setState(() {
                            currentAddress = value!;
                            _addressOption = 'saved';
                          });
                        },
                        activeColor: AppColors.primary,
                      ),
                    ),
                  );
                }),
                // New address button
                ListTile(
                  title: Text(
                    'Add An Address',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  trailing: Icon(
                    _addNewAddress
                        ? CupertinoIcons.chevron_up
                        : CupertinoIcons.add,
                  ),
                  onTap: () {
                    setState(() {
                      _addNewAddress = !_addNewAddress;
                    });
                  },
                ),

                if (_addNewAddress)
                  Column(
                    children: [
                      DropdownButtonFormField<String>(
                        dropdownColor: Colors.white,
                        elevation: 0,
                        decoration: const InputDecoration(
                          labelText: 'Province',
                          labelStyle: TextStyle(
                            color: Colors.black54,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black26, width: 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black26, width: 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                        ),
                        value: selectedProvinceCode,
                        items: provinces.map<DropdownMenuItem<String>>((prov) {
                          return DropdownMenuItem<String>(
                            value: prov['code'].toString(),
                            child: Text(prov['name']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedProvinceCode = value;
                            selectedDistrictCode = null;
                            selectedWardCode = null;
                            districts = [];
                            wards = [];
                          });
                          if (value != null) fetchDistricts(value);
                        },
                      ),
                      const SizedBox(height: 16),
                      // Dropdown for District selection
                      DropdownButtonFormField<String>(
                        dropdownColor: Colors.white,
                        elevation: 0,
                        decoration: const InputDecoration(
                          labelText: 'District',
                          labelStyle: TextStyle(
                            color: Colors.black54,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black26, width: 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black26, width: 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                        ),
                        value: selectedDistrictCode,
                        items: districts.map<DropdownMenuItem<String>>((dist) {
                          return DropdownMenuItem<String>(
                            value: dist['code'].toString(),
                            child: Text(dist['name']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedDistrictCode = value;
                            selectedWardCode = null;
                            wards = [];
                          });
                          if (value != null) fetchWards(value);
                        },
                      ),

                      const SizedBox(height: 16),

                      // Dropdown for Ward selection
                      DropdownButtonFormField<String>(
                        dropdownColor: Colors.white,
                        elevation: 0,
                        decoration: const InputDecoration(
                          labelText: 'Ward',
                          labelStyle: TextStyle(
                            color: Colors.black54,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black26, width: 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black26, width: 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                        ),
                        value: selectedWardCode,
                        items: wards.map<DropdownMenuItem<String>>((ward) {
                          return DropdownMenuItem<String>(
                            value: ward['code'].toString(),
                            child: Text(ward['name']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedWardCode = value;
                          });
                        },
                      ),

                      const SizedBox(height: 16),
                      // Save address button
                      MyButton(
                        text: 'Add location',
                        onTap: (_) async {
                          String getNameByCode(
                              List<dynamic> list, String? code) {
                            return list.firstWhere(
                              (item) => item['code'].toString() == code,
                              orElse: () => {'name': 'Unknown'},
                            )['name'];
                          }

                          String newAddress =
                              '${getNameByCode(wards, selectedWardCode)}, ${getNameByCode(districts, selectedDistrictCode)}, ${getNameByCode(provinces, selectedProvinceCode)}';

                          saveLocationToPreferences(newAddress);
                          await getSavedAddresses();
                          setState(() {
                            _addNewAddress = false;
                            selectedProvinceCode = null;
                            selectedDistrictCode = null;
                            selectedWardCode = null;
                            districts = [];
                            wards = [];
                          });
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
