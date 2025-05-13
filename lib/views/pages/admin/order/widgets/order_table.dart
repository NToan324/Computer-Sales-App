import 'package:flutter/material.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:intl/intl.dart';
import 'order_detail_dialog.dart';

class OrderManagementTable extends StatefulWidget {
  final List<Map<String, dynamic>> orders; // Thêm thuộc tính để nhận dữ liệu

  const OrderManagementTable({super.key, required this.orders}); // Yêu cầu Orders qua constructor

  @override
  State<OrderManagementTable> createState() => _OrderManagementTableState();
}

class _OrderManagementTableState extends State<OrderManagementTable> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = "All";
  DateTimeRange? _customDateRange;
  int _currentPage = 1;
  final int _itemsPerPage = 20;

 List<Map<String, dynamic>> get filteredOrders {
    List<Map<String, dynamic>> sortedOrders =
        List.from(widget.orders)..sort((a, b) {
          DateTime dateA = DateTime.parse(a['orderDate']);
          DateTime dateB = DateTime.parse(b['orderDate']);
          return dateB.compareTo(dateA);
        });
    DateTime now = DateTime.now();
    DateTime todayStart = DateTime(now.year, now.month, now.day);
    DateTime yesterdayStart = todayStart.subtract(const Duration(days: 1));
    DateTime weekStart = todayStart.subtract(Duration(days: now.weekday - 1));
    DateTime monthStart = DateTime(now.year, now.month, 1);

    switch (_selectedFilter) {
      case "Today":
        sortedOrders = sortedOrders
            .where((order) {
              DateTime orderDate = DateTime.parse(order['orderDate']);
              return orderDate.isAfter(todayStart) ||
                  orderDate.isAtSameMomentAs(todayStart);
            })
            .toList();
        break;
      case "Yesterday":
        sortedOrders = sortedOrders
            .where((order) {
              DateTime orderDate = DateTime.parse(order['orderDate']);
              return orderDate.isAfter(yesterdayStart) &&
                  orderDate.isBefore(todayStart);
            })
            .toList();
        break;
      case "This Week":
        sortedOrders = sortedOrders
            .where((order) {
              DateTime orderDate = DateTime.parse(order['orderDate']);
              return orderDate.isAfter(weekStart) ||
                  orderDate.isAtSameMomentAs(weekStart);
            })
            .toList();
        break;
      case "This Month":
        sortedOrders = sortedOrders
            .where((order) {
              DateTime orderDate = DateTime.parse(order['orderDate']);
              return orderDate.isAfter(monthStart) ||
                  orderDate.isAtSameMomentAs(monthStart);
            })
            .toList();
        break;
      case "Custom":
        if (_customDateRange != null) {
          sortedOrders = sortedOrders
              .where((order) {
                DateTime orderDate = DateTime.parse(order['orderDate']);
                return orderDate.isAfter(_customDateRange!.start) &&
                    orderDate.isBefore(_customDateRange!.end.add(const Duration(days: 1)));
              })
              .toList();
        }
        break;
      default:
        break;
    }

    if (_searchController.text.isNotEmpty) {
      sortedOrders = sortedOrders.where((order) {
        return order['id']
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
      }).toList();
    }

    return sortedOrders;
  }

  List<Map<String, dynamic>> get paginatedOrders {
    int startIndex = (_currentPage - 1) * _itemsPerPage;
    int endIndex = startIndex + _itemsPerPage;
    if (startIndex >= filteredOrders.length) return [];
    return filteredOrders.sublist(
        startIndex, endIndex > filteredOrders.length ? filteredOrders.length : endIndex);
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Pending":
        return Colors.orange;
      case "Confirmed":
        return Colors.green;
      case "Shipped":
        return Colors.blue;
      case "Delivered":
        return Colors.teal;
      default:
        return Colors.blueGrey;
    }
  }

  void _showOrderDetail(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) {
        return OrderDetailDialog(
          order: order,
          onStatusChanged: (newStatus) {
            setState(() {
              order['status'] = newStatus;
            });
          },
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

  TableRow buildOrderRow(Map<String, dynamic> order, List<double> colWidths) {
    final isMobile = Responsive.isMobile(context);

    return TableRow(
      children: isMobile
          ? [
              InkWell(
                onTap: () => _showOrderDetail(order),
                child: cellText(order['id'], colWidths[0]),
              ),
              InkWell(
                onTap: () => _showOrderDetail(order),
                child: cellText(
                    DateFormat('dd/MM/yyyy').format(DateTime.parse(order['orderDate'])),
                    colWidths[1]),
              ),
              InkWell(
                onTap: () => _showOrderDetail(order),
                child: cellText("${order['totalAmount']}đ", colWidths[2]),
              ),
            ]
          : [
              InkWell(
                onTap: () => _showOrderDetail(order),
                child: cellText(order['id'], colWidths[0]),
              ),
              InkWell(
                onTap: () => _showOrderDetail(order),
                child: cellText(order['customerName'], colWidths[1]),
              ),
              InkWell(
                onTap: () => _showOrderDetail(order),
                child: cellText(
                    DateFormat('dd/MM/yyyy').format(DateTime.parse(order['orderDate'])),
                    colWidths[2]),
              ),
              InkWell(
                onTap: () => _showOrderDetail(order),
                child: cellText("${order['totalAmount']}đ", colWidths[3]),
              ),
              InkWell(
                onTap: () => _showOrderDetail(order),
                child: cellText("${order['discountApplied']}đ", colWidths[4]),
              ),
              InkWell(
                onTap: () => _showOrderDetail(order),
                child: Container(
                  width: colWidths[5],
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Chip(
                    label: Text(
                      order['status'],
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: _getStatusColor(order['status']),
                  ),
                ),
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
                tableWidth * 0.15,
                tableWidth * 0.2,
                tableWidth * 0.15,
                tableWidth * 0.15,
                tableWidth * 0.15,
                tableWidth * 0.15,
              ];

        final headers = isMobile
            ? ["Order ID", "Date", "Total Amount"]
            : [
                "Order ID",
                "Customer",
                "Date",
                "Total Amount",
                "Discount",
                "Status",
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
                    "Order List",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: isMobile ? 120 : 200,
                        height: 36,
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 8 : 12),
                            hintText: "Search by Order ID",
                            prefixIcon: Icon(Icons.search,
                                size: isMobile ? 16 : 18),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.orange),
                            ),
                            hintStyle: TextStyle(
                                fontSize: isMobile ? 12 : 14),
                            labelStyle: TextStyle(
                                fontSize: isMobile ? 12 : 14),
                          ),
                          style: TextStyle(
                              fontSize: isMobile ? 12 : 14),
                          onChanged: (value) {
                            setState(() {
                              _currentPage = 1;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: isMobile ? 120 : 200,
                        child: DropdownMenu<String>(
                          initialSelection: _selectedFilter,
                          onSelected: (value) async {
                            if (value == "Custom") {
                              final DateTimeRange? picked =
                                  await showDateRangePicker(
                                context: context,
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                                initialDateRange: _customDateRange,
                              );
                              if (picked != null) {
                                setState(() {
                                  _customDateRange = picked;
                                  _selectedFilter = value!;
                                  _currentPage = 1;
                                });
                              }
                            } else {
                              setState(() {
                                _selectedFilter = value!;
                                _customDateRange = null;
                                _currentPage = 1;
                              });
                            }
                          },
                          dropdownMenuEntries: [
                            "All",
                            "Today",
                            "Yesterday",
                            "This Week",
                            "This Month",
                            "Custom"
                          ]
                              .map((value) => DropdownMenuEntry(
                                    value: value,
                                    label: value,
                                  ))
                              .toList(),
                          textStyle: TextStyle(
                            fontSize: isMobile ? 12 : 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          menuStyle: const MenuStyle(
                            elevation: WidgetStatePropertyAll(4),
                            backgroundColor: WidgetStatePropertyAll(Colors.white),
                          ),
                          inputDecorationTheme: InputDecorationTheme(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.orange, width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 8 : 16, vertical: isMobile ? 0 : 12),
                          ),
                        ),
                      ),
                    ],
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
                      ...paginatedOrders.map((order) => buildOrderRow(order, colWidths)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: _currentPage > 1
                        ? () {
                            setState(() {
                              _currentPage--;
                            });
                          }
                        : null,
                  ),
                  Text("Page $_currentPage"),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: (_currentPage * _itemsPerPage) < filteredOrders.length
                        ? () {
                            setState(() {
                              _currentPage++;
                            });
                          }
                        : null,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}