import 'package:computer_sales_app/config/color.dart';
import 'package:flutter/material.dart';

class DescriptionProduct extends StatefulWidget {
  const DescriptionProduct({super.key});

  @override
  State<DescriptionProduct> createState() => _DescriptionProductState();
}

class _DescriptionProductState extends State<DescriptionProduct> {
//   Bộ xử lý - Processor
  List<String> descriptionList = [
    'Processor',
    'RAM',
    'Storage',
    'Display',
    'Graphics and Audio',
    'Ports & Expansion Features',
    'Other Features',
  ];

  final Map<String, List<Map<String, String>>> detailDescriptions = {
    'Processor': [
      {'Công nghệ CPU': 'Intel Core i7 Alder Lake - 1260P'},
      {'Số nhân': '12'},
      {'Số luồng': '16'},
      {'Tốc độ CPU': '2.1GHz'},
      {'Tốc độ tối đa': 'Turbo Boost 4.7 GHz'},
    ],
    'RAM': [
      {'Dung lượng': '16GB DDR4'},
      {'Bus RAM': '3200MHz'},
      {'Số khe RAM': '2 khe'},
    ],
    'Storage': [
      {'Ổ cứng': '512GB SSD NVMe'},
    ],
    'Display': [
      {'Màn hình': '15.6 inch Full HD'},
      {'Tần số quét': '144Hz'},
    ],
    'Graphics and Audio': [
      {'Card đồ họa': 'NVIDIA RTX 3050'},
      {'Âm thanh': 'Realtek High Definition Audio'},
    ],
    'Ports & Expansion Features': [
      {'Cổng kết nối': 'USB-C, USB 3.2, HDMI'},
    ],
    'Other Features': [
      {'Pin': '4 Cell 56WHr'},
      {'Hệ điều hành': 'Windows 11 bản quyền'},
    ],
  };

  int? expandedIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          'Description',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Column(
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: descriptionList.length,
              itemBuilder: (context, index) {
                bool isExpanded = expandedIndex == index;
                final String title = descriptionList[index];
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.grey.withAlpha(20),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          setState(() {
                            if (isExpanded) {
                              expandedIndex = null; // nếu đang mở thì đóng lại
                            } else {
                              expandedIndex = index; // mở cái mới
                            }
                          });
                        },
                        title: Text(
                          descriptionList[index],
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.black,
                          size: 20,
                        ),
                      ),
                      if (isExpanded)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              detailDescriptions[title]!.length,
                              (i) {
                                final entry = detailDescriptions[title]![i];
                                final key = entry.keys.first;
                                final value = entry.values.first;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$key: $value',
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.black87),
                                    ),
                                    if (i <
                                        detailDescriptions[title]!.length - 1)
                                      Divider(
                                        color: Colors.grey.shade300,
                                        thickness: 0.5,
                                        height: 12,
                                      ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 10,
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
