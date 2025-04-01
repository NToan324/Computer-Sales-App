import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 64, horizontal: 64),
      color: Colors.grey.withAlpha(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'heilsa',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            '©2019 SworKit® by Nexercise, Inc.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Text(
            'Terms of Service | Privacy Policy',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildColumn("Products", [
                "Product",
                "Pricing",
                "Log in",
                "Request access",
                "Partnerships"
              ]),
              _buildColumn("About us",
                  ["About heilsa", "Contact us", "Features", "Careers"]),
              _buildColumn("Resources",
                  ["Help center", "Book a demo", "Server status", "Blog"]),
              _buildColumn("Get in touch",
                  ["Questions or feedback?", "We’d love to hear from you"]),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.facebook),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.one_x_mobiledata_rounded),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.library_add_check),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColumn(String title, List<String> items) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ...items.map(
            (item) => Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Text(item, style: TextStyle(color: Colors.grey)),
            ),
          ),
        ],
      ),
    );
  }
}
