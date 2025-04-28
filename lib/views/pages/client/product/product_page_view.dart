import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:computer_sales_app/views/pages/client/home/widgets/appBar_widget.dart';
import 'package:computer_sales_app/views/pages/client/home/widgets/product_widget.dart';
import 'package:flutter/material.dart';

class ProductPageView extends StatelessWidget {
  const ProductPageView({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 768; // Tùy chỉnh ngưỡng theo ý bạn

    return Scaffold(
      appBar: AppBarHomeCustom(),
      body: ListView(children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => const FilterWidget(),
                        );
                      },
                      icon: const Icon(
                        Icons.filter_list,
                        color: Colors.black,
                        size: 16,
                      ),
                      label: const Text(
                        'Filter',
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.resolveWith<Color?>(
                          (states) {
                            if (states.contains(WidgetState.hovered)) {
                              return Colors.grey[100]; // Hover thì đổi nền xám
                            }
                            return Colors.white; // Bình thường màu trắng
                          },
                        ),
                        elevation:
                            WidgetStateProperty.all(0), // Luôn không shadow
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            side: const BorderSide(
                              color: Colors.black45,
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ShowListProductWidget(),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 1, child: const FilterWidget()),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 4,
                      child: ShowListProductWidget(),
                    ),
                  ],
                ),
        ),
      ]),
    );
  }
}

class FilterWidget extends StatefulWidget {
  const FilterWidget({super.key});

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  List<String> categories = [
    'Laptop',
    'PC (Desktop)',
    'Screen',
    'Keyboard, Mouse',
    'Headphones, Speakers',
    'Accessories (Cables, Cooling Pads...)',
  ];
  List<String> brands = [
    'Dell',
    'HP',
    'Asus',
    'Acer',
    'Lenovo',
    'Apple',
    'MSI',
    'Gigabyte',
    'Razer',
  ];
  List<String> cpu = [
    'CPU i3',
    'CPU i5',
    'CPU i7',
    'CPU i9',
    'M1',
    'M2',
    'M1 Pro',
    'M1 Max',
    'M2 Pro',
    'M2 Max',
    'M1 Ultra',
  ];
  List<String> ram = [
    '4GB',
    '8GB',
    '16GB',
    '32GB',
    '64GB',
  ];
  List<String> storage = [
    'HDD',
    'SSD',
    'NVMe',
  ];
  List<String> gpu = [
    'NVIDIA',
    'AMD',
    'Intel',
  ];

  // State cho show more
  Map<String, bool> isExpanded = {
    'Category': false,
    'Brand': false,
    'CPU': false,
    'RAM': false,
    'Storage': false,
    'GPU': false,
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 10,
              children: [
                const Text(
                  'Filter',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (Responsive.isMobile(context))
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Done",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            buildFilterSection('Product Category', categories, 'Category'),
            buildFilterSection('Brand', brands, 'Brand'),
            buildFilterSection('CPU', cpu, 'CPU'),
            buildFilterSection('RAM', ram, 'RAM'),
            buildFilterSection('Storage', storage, 'Storage'),
            buildFilterSection('GPU', gpu, 'GPU'),
          ],
        ),
      ),
    );
  }

  Widget buildFilterSection(String title, List<String> items, String key) {
    bool expanded = isExpanded[key] ?? false;
    int displayCount = expanded ? items.length : 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (items.length > 3)
              IconButton(
                onPressed: () {
                  setState(() {
                    isExpanded[key] = !expanded;
                  });
                },
                icon: Icon(
                  expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.black,
                ),
              ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount:
              (displayCount > items.length) ? items.length : displayCount,
          itemBuilder: (context, index) {
            return CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(items[index], style: const TextStyle(fontSize: 14)),
              value: false,
              onChanged: (bool? value) {},
            );
          },
        ),
      ],
    );
  }
}

class ShowListProductWidget extends StatelessWidget {
  const ShowListProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          Wrap(
            runSpacing: 10,
            spacing: 20,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                'Product List',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                spacing: 10,
                children: [
                  Text('Sort by: ',
                      style: TextStyle(fontSize: 14, color: Colors.black54)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black45, width: 0.5),
                    ),
                    child: DropdownButton<String>(
                      underline: const SizedBox.shrink(),
                      dropdownColor: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      value: 'Newest',
                      items: <String>[
                        'Newest',
                        'Price: Low to High',
                        'Price: High to Low',
                        'Best Selling',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        // Handle sort change
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
          //List filter
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: List.generate(4, (index) {
              return Container(
                padding: const EdgeInsets.all(8),
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black45, width: 0.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        'Filter $index',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                      iconSize: 20,
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              );
            }),
          ),
          ProductListViewWidget(),
        ],
      ),
    );
  }
}
