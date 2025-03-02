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
      spacing: 20,
      children: [
        SizedBox(
          child: SizedBox(
            width: Responsive.isDesktop(context)
                ? 400
                : MediaQuery.of(context).size.width * 0.7,
            child: TextField(
              controller: searchController,
              onSubmitted: (value) => {},
              decoration: InputDecoration(
                fillColor: Colors.white,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                hintText: 'Search',
                labelStyle: TextStyle(color: Colors.black54),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Icon(
                    FeatherIcons.search,
                    size: 30,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.primary, width: 1),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ),
        Container(
          width: 50,
          height: 50,
          decoration:
              BoxDecoration(color: AppColor.primary, shape: BoxShape.circle),
          child: IconButton(
            onPressed: () {},
            icon: Icon(
              CupertinoIcons.slider_horizontal_3,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
