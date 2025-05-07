import 'package:flutter/material.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:intl/intl.dart';
import 'coupon_form.dart';

class CouponTable extends StatefulWidget {
  final List<Map<String, dynamic>> coupons; // Nhận coupons từ ngoài

  const CouponTable({super.key, required this.coupons});

  @override
  State<CouponTable> createState() => _CouponTableState();
}

class _CouponTableState extends State<CouponTable> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> get filteredCoupons {
    if (_searchController.text.isEmpty) {
      return widget.coupons;
    } else {
      return widget.coupons.where((coupon) {
        return coupon['code']
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
      }).toList();
    }
  }

  void _showCouponForm(Map<String, dynamic> coupon) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            coupon['code'],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange, width: 2),
                ),
                labelStyle: TextStyle(color: Colors.black),
                floatingLabelStyle: TextStyle(color: Colors.orange),
              ),
            ),
            child: CouponForm(
              buttonLabel: "Save",
              initialCoupon: coupon,
              onSubmit: (updatedCouponData) {
                setState(() {
                  final index = widget.coupons.indexOf(coupon);
                  if (index != -1) {
                    widget.coupons[index] = updatedCouponData;
                  }
                });
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
    );
  }

  TableRow buildHeaderRow(List<String> headers, List<double> colWidths) {
    return TableRow(
      decoration: const BoxDecoration(color: Color.fromARGB(255, 240, 240, 240)),
      children: List.generate(headers.length, (index) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          width: colWidths[index],
          child: Text(
            headers[index],
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      }),
    );
  }

  TableRow buildCouponRow(Map<String, dynamic> coupon, List<double> colWidths) {
    final isMobile = Responsive.isMobile(context);

    return TableRow(
      children: isMobile
          ? [
              InkWell(
                onTap: () => _showCouponForm(coupon),
                child: cellText(coupon['code'], colWidths[0]),
              ),
              InkWell(
                onTap: () => _showCouponForm(coupon),
                child: cellText(
                    DateFormat('dd/MM/yyyy').format(coupon['createdAt']),
                    colWidths[1]),
              ),
              InkWell(
                onTap: () => _showCouponForm(coupon),
                child: cellText("${coupon['discountValue']}đ", colWidths[2]),
              ),
            ]
          : [
              InkWell(
                onTap: () => _showCouponForm(coupon),
                child: cellText(coupon['code'], colWidths[0]),
              ),
              InkWell(
                onTap: () => _showCouponForm(coupon),
                child: cellText(
                    DateFormat('dd/MM/yyyy').format(coupon['createdAt']),
                    colWidths[1]),
              ),
              InkWell(
                onTap: () => _showCouponForm(coupon),
                child: cellText("${coupon['discountValue']}đ", colWidths[2]),
              ),
              InkWell(
                onTap: () => _showCouponForm(coupon),
                child: cellText(coupon['usageCount'].toString(), colWidths[3]),
              ),
              InkWell(
                onTap: () => _showCouponForm(coupon),
                child: cellText(coupon['maxUsage'].toString(), colWidths[4]),
              ),
              InkWell(
                onTap: () => _showCouponForm(coupon),
                child: cellText(coupon['appliedOrders'].join(", "), colWidths[5]),
              ),
            ],
    );
  }

  Widget cellText(String text, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Text(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = Responsive.isMobile(context);
        final tableWidth = constraints.maxWidth;

        final List<double> colWidths = isMobile
            ? [tableWidth * 0.3, tableWidth * 0.3, tableWidth * 0.3]
            : [
                tableWidth * 0.1,
                tableWidth * 0.2,
                tableWidth * 0.1,
                tableWidth * 0.1,
                tableWidth * 0.1,
                tableWidth * 0.2,
              ];

        final headers = isMobile
            ? ["Code", "Created At", "Discount Value"]
            : [
                "Code",
                "Created At",
                "Discount Value",
                "Usage Count",
                "Max Usage",
                "Applied Orders"
              ];

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(50),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Coupon List",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 200,
                    height: 36,
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        hintText: "Search by code",
                        prefixIcon: const Icon(Icons.search, size: 18),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.orange),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: tableWidth - 40,
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: {
                      for (int i = 0; i < colWidths.length; i++)
                        i: FixedColumnWidth(colWidths[i]),
                    },
                    border: TableBorder.all(color: Colors.grey.shade300),
                    children: [
                      buildHeaderRow(headers, colWidths),
                      ...filteredCoupons
                          .map((coupon) => buildCouponRow(coupon, colWidths)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}