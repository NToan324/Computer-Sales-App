import 'package:computer_sales_app/config/color.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/utils/responsive.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({
    super.key,
  });

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  TextEditingController searchController = TextEditingController();
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: Responsive.isDesktop(context)
          ? MainAxisAlignment.start
          : MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          child: SizedBox(
            width: Responsive.isDesktop(context)
                ? 400
                : MediaQuery.of(context).size.width * 0.75,
            child: TextField(
              controller: searchController,
              onSubmitted: (value) => {},
              decoration: InputDecoration(
                fillColor: Colors.orange,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                hintText: 'What are you looking for?',
                labelStyle: TextStyle(color: Colors.black54),
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
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColor.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.camera_alt_outlined,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
