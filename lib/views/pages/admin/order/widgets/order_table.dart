import 'package:flutter/material.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../../provider/order_provider.dart';
import 'order_detail_dialog.dart';
import 'dart:async';

class OrderManagementTable extends StatefulWidget {
  final List<Map<String, dynamic>> orders;

  const OrderManagementTable({super.key, required this.orders});

  @override
  State<OrderManagementTable> createState() => _OrderManagementTableState();
}

class _OrderManagementTableState extends State<OrderManagementTable> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = "All";
  DateTimeRange? _customDateRange;
  int _currentPage = 1;
  final int _itemsPerPage = 20;
  final List<String> _orderStatuses = ['PENDING', 'SHIPPING', 'DELIVERED', 'CANCELLED'];
  bool _isLoadingOrders = false;

  @override
  void initState() {
    super.initState();
    // Move _loadOrders to a post-frame callback to ensure provider is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadOrders();
    });
  }

  Future<void> _loadOrders() async {
    setState(() {
      _isLoadingOrders = true;
    });
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    try {
      if (_searchController.text.isNotEmpty || _selectedFilter != "All") {
        await orderProvider.searchOrders(
          orderId: _searchController.text.isNotEmpty ? _searchController.text : null,
          fromDate: _customDateRange?.start != null
              ? DateFormat('yyyy-MM-dd').format(_customDateRange!.start)
              : null,
          toDate: _customDateRange?.end != null
              ? DateFormat('yyyy-MM-dd').format(_customDateRange!.end)
              : null,
          page: _currentPage,
          limit: _itemsPerPage,
        );
      } else {
        await orderProvider.loadOrders(page: _currentPage, limit: _itemsPerPage);
      }
    } catch (e) {
      // Handle error (e.g., show a snackbar)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load orders: $e')),
      );
    }
    setState(() {
      _isLoadingOrders = false;
    });
  }

  List<Map<String, dynamic>> get filteredOrders {
    List<Map<String, dynamic>> sortedOrders = List.from(widget.orders)
      ..sort((a, b) {
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
        sortedOrders = sortedOrders.where((order) {
          DateTime orderDate = DateTime.parse(order['orderDate']);
          return orderDate.isAfter(todayStart) || orderDate.isAtSameMomentAs(todayStart);
        }).toList();
        break;
      case "Yesterday":
        sortedOrders = sortedOrders.where((order) {
          DateTime orderDate = DateTime.parse(order['orderDate']);
          return orderDate.isAfter(yesterdayStart) && orderDate.isBefore(todayStart);
        }).toList();
        break;
      case "This Week":
        sortedOrders = sortedOrders.where((order) {
          DateTime orderDate = DateTime.parse(order['orderDate']);
          return orderDate.isAfter(weekStart) || orderDate.isAtSameMomentAs(weekStart);
        }).toList();
        break;
      case "This Month":
        sortedOrders = sortedOrders.where((order) {
          DateTime orderDate = DateTime.parse(order['orderDate']);
          return orderDate.isAfter(monthStart) || orderDate.isAtSameMomentAs(monthStart);
        }).toList();
        break;
      case "Custom":
        if (_customDateRange != null) {
          sortedOrders = sortedOrders.where((order) {
            DateTime orderDate = DateTime.parse(order['orderDate']);
            return orderDate.isAfter(_customDateRange!.start) &&
                orderDate.isBefore(_customDateRange!.end.add(const Duration(days: 1)));
          }).toList();
        }
        break;
      default:
        break;
    }

    if (_searchController.text.isNotEmpty) {
      sortedOrders = sortedOrders.where((order) {
        return (order['id'] as String?)?.toLowerCase().contains(_searchController.text.toLowerCase()) ?? false;
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
    switch (status.toUpperCase()) {
      case 'PENDING':
        return Colors.orange;
      case 'SHIPPING':
        return Colors.blue;
      case 'DELIVERED':
        return Colors.teal;
      case 'CANCELLED':
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }

  void _showOrderDetail(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        // Wrap dialog in ProviderScope to ensure OrderProvider is available
        return ProviderScope(
          parentContext: context, // Pass the parent context with OrderProvider
          child: OrderDetailDialog(
            order: order,
            onStatusChanged: (newStatus) async {
              final orderProvider = Provider.of<OrderProvider>(context, listen: false);
              try {
                await orderProvider.updateOrderStatus(orderId: order['id'], status: newStatus);
                setState(() {
                  order['status'] = newStatus;
                });
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to update status: $e')),
                );
              }
            },
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

  TableRow buildOrderRow(Map<String, dynamic> order, List<double> colWidths) {
    final isMobile = Responsive.isMobile(context);
    final String orderId = order['id'] as String? ?? '';
    final String firstFiveChars = orderId.length >= 5 ? orderId.substring(0, 5) : orderId;

    return TableRow(
      children: isMobile
          ? [
        InkWell(
          onTap: () => _showOrderDetail(order),
          child: cellText(firstFiveChars, colWidths[0]),
        ),
        InkWell(
          onTap: () => _showOrderDetail(order),
          child: cellText(
              DateFormat('dd/MM/yyyy').format(DateTime.parse(order['orderDate'])),
              colWidths[1]),
        ),
        InkWell(
          onTap: () => _showOrderDetail(order),
          child: cellText('${(order['totalAmount'] as double? ?? 0.0).toStringAsFixed(0)}đ', colWidths[2]),
        ),
      ]
          : [
        InkWell(
          onTap: () => _showOrderDetail(order),
          child: cellText(firstFiveChars, colWidths[0]),
        ),
        InkWell(
          onTap: () => _showOrderDetail(order),
          child: cellText(order['customerName'] ?? 'Unknown', colWidths[1]),
        ),
        InkWell(
          onTap: () => _showOrderDetail(order),
          child: cellText(
              DateFormat('dd/MM/yyyy').format(DateTime.parse(order['orderDate'])),
              colWidths[2]),
        ),
        InkWell(
          onTap: () => _showOrderDetail(order),
          child: cellText('${(order['totalAmount'] as double? ?? 0.0).toStringAsFixed(0)}đ', colWidths[3]),
        ),
        InkWell(
          onTap: () => _showOrderDetail(order),
          child: cellText('${(order['discountApplied'] as double? ?? 0.0).toStringAsFixed(0)}đ', colWidths[4]),
        ),
        InkWell(
          onTap: () => _showOrderDetail(order),
          child: Container(
            width: colWidths[5],
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Chip(
              label: Text(
                order['status'] ?? 'PENDING',
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: _getStatusColor(order['status'] ?? 'PENDING'),
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
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        softWrap: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = Responsive.isMobile(context);
        final double tableWidth = constraints.maxWidth;

        final List<double> colWidths = isMobile
            ? [tableWidth * 0.3, tableWidth * 0.3, tableWidth * 0.3]
            : List.generate(6, (index) => tableWidth / 6);

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
              if (_isLoadingOrders)
                const Center(child: CircularProgressIndicator()),
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
                            contentPadding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 12),
                            hintText: "Search by Order ID",
                            prefixIcon: Icon(Icons.search, size: isMobile ? 16 : 18),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.orange),
                            ),
                            hintStyle: TextStyle(fontSize: isMobile ? 12 : 14),
                            labelStyle: TextStyle(fontSize: isMobile ? 12 : 14),
                          ),
                          style: TextStyle(fontSize: isMobile ? 12 : 14),
                          onChanged: (value) {
                            setState(() {
                              _currentPage = 1;
                              _loadOrders();
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
                              final DateTimeRange? picked = await showDateRangePicker(
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
                                  _loadOrders();
                                });
                              }
                            } else {
                              setState(() {
                                _selectedFilter = value!;
                                _customDateRange = null;
                                _currentPage = 1;
                                _loadOrders();
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
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: tableWidth,
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: {
                    for (int i = 0; i < colWidths.length; i++) i: FixedColumnWidth(colWidths[i]),
                  },
                  border: TableBorder.all(color: Colors.grey.shade300),
                  children: [
                    buildHeaderRow(headers, colWidths),
                    ...paginatedOrders.map((order) => buildOrderRow(order, colWidths)),
                  ],
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
                        _loadOrders();
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
                        _loadOrders();
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

// Helper class to pass parent context to dialog
class ProviderScope extends StatelessWidget {
  final Widget child;
  final BuildContext parentContext;

  const ProviderScope({super.key, required this.child, required this.parentContext});

  @override
  Widget build(BuildContext context) {
    return ProviderScopeWrapper(
      parentContext: parentContext,
      child: child,
    );
  }
}

class ProviderScopeWrapper extends InheritedWidget {
  final BuildContext parentContext;

  const ProviderScopeWrapper({
    super.key,
    required this.parentContext,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  static BuildContext of(BuildContext context) {
    final wrapper = context.dependOnInheritedWidgetOfExactType<ProviderScopeWrapper>();
    return wrapper?.parentContext ?? context;
  }
}