import 'package:computer_sales_app/components/custom/dropdown.dart';
import 'package:computer_sales_app/components/custom/radio.dart';
import 'package:computer_sales_app/components/custom/range_slider.dart';
import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:computer_sales_app/views/pages/client/home/widgets/product_widget.dart';
import 'package:computer_sales_app/views/pages/client/login/widgets/button.dart';
import 'package:flutter/material.dart';

class ProductPageView extends StatelessWidget {
  const ProductPageView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: [
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
                                  return Colors.grey[100];
                                }
                                return Colors.white;
                              },
                            ),
                            elevation: WidgetStateProperty.all(0),
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
          ],
        ),
      ),
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

  // State cho show more
  Map<String, bool> isExpanded = {
    'Category': false,
    'Brand': false,
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
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
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
                        "Cancel",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                ],
              ),
              buildFilterSection('Product Category', categories, 'Category'),
              buildFilterSection('Brand', brands, 'Brand'),
              const SizedBox(height: 16),
              RangeSliderCustom(
                title: 'Price',
                maxValue: 10000000,
                divisions: 50,
              ),
              const SizedBox(height: 16),
              RatingFilter(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 10,
                children: [
                  Expanded(
                    child: MyButton(
                      text: 'Reset',
                      variantIsOutline: true,
                      onTap: (_) {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Expanded(
                    child: MyButton(
                      text: 'Apply',
                      onTap: (_) {
                        // Handle apply filter action
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFilterSection(String title, List<String> items, String key) {
    bool expanded = isExpanded[key] ?? false;
    int displayCount = expanded ? items.length : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  isExpanded[key] = !expanded;
                });
              },
              icon: Icon(
                expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: Colors.black,
              ),
            ),
          ],
        ),
        if (expanded)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayCount,
            itemBuilder: (context, index) {
              return CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  items[index],
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                value: false,
                onChanged: (bool? value) {},
              );
            },
          ),
      ],
    );
  }
}

enum RatingFilterValue { all, oneStar, twoStar, threeStar, fourStar, fiveStar }

class RatingFilter extends StatefulWidget {
  const RatingFilter({
    super.key,
  });

  @override
  State<RatingFilter> createState() => _RatingFilterState();
}

class _RatingFilterState extends State<RatingFilter> {
  RatingFilterValue selectedRatingValue = RatingFilterValue.all;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Rating',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    5 - index,
                    (index) {
                      return Icon(
                        Icons.star,
                        color: Colors.amber,
                      );
                    },
                  ),
                ),
                RadioCustom<RatingFilterValue>(
                  value: RatingFilterValue
                      .values[RatingFilterValue.values.length - index - 1],
                  groupValue: selectedRatingValue,
                  onChanged: (value) {
                    setState(() {
                      selectedRatingValue = value!;
                    });
                  },
                )
              ],
            ),
            separatorBuilder: (context, _) => SizedBox(height: 5),
            itemCount: 5,
          ),
        ),
      ],
    );
  }
}

class ShowListProductWidget extends StatelessWidget {
  ShowListProductWidget({super.key});

  final List<String> sortOptions = [
    'All Products',
    'Name: A to Z',
    'Name: Z to A',
    'Price: Low to High',
    'Price: High to Low',
  ];

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    return Container(
      padding: !isMobile ? const EdgeInsets.all(16) : null,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: !isMobile
            ? [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ]
            : null,
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
              if (!isMobile)
                const Text(
                  'Product List',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                spacing: 10,
                children: [
                  Text(
                    'Sort by: ',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black45, width: 0.5),
                    ),
                    child: DropdownCustom(items: sortOptions),
                  ),
                ],
              )
            ],
          ),
          //List filter
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: List.generate(3, (index) {
              return Container(
                padding: const EdgeInsets.only(
                  left: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(25),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 14),
                      child: Text(
                        'Filter $index',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.primary,
                      ),
                      iconSize: 16,
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
