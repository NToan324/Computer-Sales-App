import 'package:computer_sales_app/config/color.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/utils/responsive.dart';

class SearchWidget extends StatelessWidget {
  final VoidCallback onTap; // Callback when the search bar is tapped

  const SearchWidget({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: Responsive.isDesktop(context)
          ? MainAxisAlignment.start
          : MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: Responsive.isDesktop(context)
              ? 400
              : MediaQuery.of(context).size.width * 0.75,
          child: GestureDetector(
            onTap: onTap, // Trigger the callback when tapped
            child: AbsorbPointer(
              child: TextField(
                readOnly: true, // Prevent keyboard input
                decoration: InputDecoration(
                  fillColor: BackgroundColor.secondary,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  hintText: 'What are you looking for?',
                  labelStyle: const TextStyle(color: Colors.black54),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(
                      FeatherIcons.search,
                      size: 30,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.primary, width: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColor.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            onPressed: () {
              // Handle camera action if needed
            },
            icon: const Icon(
              Icons.camera_alt_outlined,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}