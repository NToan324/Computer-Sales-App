import 'package:flutter/material.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:intl/intl.dart';
import 'invoice_detail_dialog.dart';

class InvoiceTable extends StatefulWidget {
  final List<Map<String, dynamic>> invoices; // Thêm thuộc tính để nhận dữ liệu

  const InvoiceTable({super.key, required this.invoices}); // Yêu cầu invoices qua constructor

  @override
  State<InvoiceTable> createState() => _InvoiceTableState();
}

class _InvoiceTableState extends State<InvoiceTable> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = "All";
  DateTimeRange? _customDateRange;
  int _currentPage = 1;
  final int _itemsPerPage = 20;

 List<Map<String, dynamic>> get filteredInvoices {
    List<Map<String, dynamic>> sortedInvoices =
        List.from(widget.invoices)..sort((a, b) {
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
        sortedInvoices = sortedInvoices
            .where((invoice) {
              DateTime invoiceDate = DateTime.parse(invoice['orderDate']);
              return invoiceDate.isAfter(todayStart) ||
                  invoiceDate.isAtSameMomentAs(todayStart);
            })
            .toList();
        break;
      case "Yesterday":
        sortedInvoices = sortedInvoices
            .where((invoice) {
              DateTime invoiceDate = DateTime.parse(invoice['orderDate']);
              return invoiceDate.isAfter(yesterdayStart) &&
                  invoiceDate.isBefore(todayStart);
            })
            .toList();
        break;
      case "This Week":
        sortedInvoices = sortedInvoices
            .where((invoice) {
              DateTime invoiceDate = DateTime.parse(invoice['orderDate']);
              return invoiceDate.isAfter(weekStart) ||
                  invoiceDate.isAtSameMomentAs(weekStart);
            })
            .toList();
        break;
      case "This Month":
        sortedInvoices = sortedInvoices
            .where((invoice) {
              DateTime invoiceDate = DateTime.parse(invoice['orderDate']);
              return invoiceDate.isAfter(monthStart) ||
                  invoiceDate.isAtSameMomentAs(monthStart);
            })
            .toList();
        break;
      case "Custom":
        if (_customDateRange != null) {
          sortedInvoices = sortedInvoices
              .where((invoice) {
                DateTime invoiceDate = DateTime.parse(invoice['orderDate']);
                return invoiceDate.isAfter(_customDateRange!.start) &&
                    invoiceDate.isBefore(_customDateRange!.end.add(const Duration(days: 1)));
              })
              .toList();
        }
        break;
      default:
        break;
    }

    if (_searchController.text.isNotEmpty) {
      sortedInvoices = sortedInvoices.where((invoice) {
        return invoice['id']
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
      }).toList();
    }

    return sortedInvoices;
  }

  List<Map<String, dynamic>> get paginatedInvoices {
    int startIndex = (_currentPage - 1) * _itemsPerPage;
    int endIndex = startIndex + _itemsPerPage;
    if (startIndex >= filteredInvoices.length) return [];
    return filteredInvoices.sublist(
        startIndex, endIndex > filteredInvoices.length ? filteredInvoices.length : endIndex);
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Pending":
        return Colors.orange;
      case "Confirmed":
        return Colors.green;
      default:
        return Colors.blueGrey;
    }
  }

  void _showInvoiceDetail(Map<String, dynamic> invoice) {
    showDialog(
      context: context,
      builder: (context) {
        return InvoiceDetailDialog(
          invoice: invoice,
          onStatusChanged: (newStatus) {
            setState(() {
              invoice['status'] = newStatus;
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

  TableRow buildInvoiceRow(Map<String, dynamic> invoice, List<double> colWidths) {
    final isMobile = Responsive.isMobile(context);

    return TableRow(
      children: isMobile
          ? [
              InkWell(
                onTap: () => _showInvoiceDetail(invoice),
                child: cellText(invoice['id'], colWidths[0]),
              ),
              InkWell(
                onTap: () => _showInvoiceDetail(invoice),
                child: cellText(
                    DateFormat('dd/MM/yyyy').format(DateTime.parse(invoice['orderDate'])),
                    colWidths[1]),
              ),
              InkWell(
                onTap: () => _showInvoiceDetail(invoice),
                child: cellText("${invoice['totalAmount']}đ", colWidths[2]),
              ),
            ]
          : [
              InkWell(
                onTap: () => _showInvoiceDetail(invoice),
                child: cellText(invoice['id'], colWidths[0]),
              ),
              InkWell(
                onTap: () => _showInvoiceDetail(invoice),
                child: cellText(invoice['customerName'], colWidths[1]),
              ),
              InkWell(
                onTap: () => _showInvoiceDetail(invoice),
                child: cellText(
                    DateFormat('dd/MM/yyyy').format(DateTime.parse(invoice['orderDate'])),
                    colWidths[2]),
              ),
              InkWell(
                onTap: () => _showInvoiceDetail(invoice),
                child: cellText("${invoice['totalAmount']}đ", colWidths[3]),
              ),
              InkWell(
                onTap: () => _showInvoiceDetail(invoice),
                child: cellText("${invoice['discountApplied']}đ", colWidths[4]),
              ),
              InkWell(
                onTap: () => _showInvoiceDetail(invoice),
                child: Container(
                  width: colWidths[5],
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Chip(
                    label: Text(
                      invoice['status'],
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: _getStatusColor(invoice['status']),
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
                    "Invoice List",
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
                      ...paginatedInvoices.map((invoice) => buildInvoiceRow(invoice, colWidths)),
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
                    onPressed: (_currentPage * _itemsPerPage) < filteredInvoices.length
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