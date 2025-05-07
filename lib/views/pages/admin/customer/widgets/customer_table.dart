import 'package:flutter/material.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:intl/intl.dart'; // Thêm intl để định dạng ngày
import 'customer_form.dart';

class CustomerTable extends StatefulWidget {
  final List<Map<String, dynamic>> customers; // Nhận customers từ ngoài

  const CustomerTable({super.key, required this.customers});

  @override
  State<CustomerTable> createState() => _CustomerTableState();
}

class _CustomerTableState extends State<CustomerTable> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> get filteredCustomers {
    if (_searchController.text.isEmpty) {
      return widget.customers;
    } else {
      return widget.customers.where((customer) {
        return customer['name']
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
      }).toList();
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Active":
        return Colors.green;
      case "Disabled":
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }

  void _toggleStatus(Map<String, dynamic> customer) {
    setState(() {
      customer['status'] = customer['status'] == "Active" ? "Disabled" : "Active";
    });
  }

  void _showCustomerForm(Map<String, dynamic> customer) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            customer['name'],
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
            child: CustomerForm(
              buttonLabel: "Save",
              initialCustomer: {
                'name': customer['name'],
                'phone': customer['phone'],
                'email': customer['email'] ?? '',
                'address': customer['address'] ?? '',
                'dateJoined': customer['dateJoined'],
                'rank': customer['rank'],
                'status': customer['status'],
              },
              onSubmit: (updatedCustomerData) {
                setState(() {
                  customer['name'] = updatedCustomerData['name'];
                  customer['phone'] = updatedCustomerData['phone'];
                  customer['email'] = updatedCustomerData['email'];
                  customer['address'] = updatedCustomerData['address'];
                  customer['dateJoined'] = updatedCustomerData['dateJoined'];
                  customer['rank'] = updatedCustomerData['rank'];
                  customer['status'] = updatedCustomerData['status'];
                });
                Navigator.of(context).pop();
              },
              onDelete: () {
                setState(() {
                  widget.customers.remove(customer);
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
      decoration:
          const BoxDecoration(color: Color.fromARGB(255, 240, 240, 240)),
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

  Color _getRankColor(String rank) {
    switch (rank) {
      case "Bronze":
        return Colors.brown;
      case "Silver":
        return Colors.grey;
      case "Gold":
        return Colors.yellow[700]!;
      default:
        return Colors.blueGrey;
    }
  }

  // Hàm định dạng ngày
  String _formatDate(String date) {
    try {
      final DateTime parsedDate = DateTime.parse(date);
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    } catch (e) {
      return date; // Trả về nguyên bản nếu có lỗi
    }
  }

  TableRow buildCustomerRow(Map<String, dynamic> customer, List<double> colWidths) {
    final isMobile = Responsive.isMobile(context);

    return TableRow(
      children: isMobile
          ? [
              InkWell(
                onTap: () => _showCustomerForm(customer),
                child: cellText(customer['id'].toString(), colWidths[0]),
              ),
              InkWell(
                onTap: () => _showCustomerForm(customer),
                child: customerCell(customer, colWidths[1]),
              ),
              InkWell(
                onTap: () => _showCustomerForm(customer),
                child: cellText(customer['phone'], colWidths[2]),
              ),
            ]
          : [
              InkWell(
                onTap: () => _showCustomerForm(customer),
                child: cellText(customer['id'].toString(), colWidths[0]),
              ),
              InkWell(
                onTap: () => _showCustomerForm(customer),
                child: customerCell(customer, colWidths[1]),
              ),
              InkWell(
                onTap: () => _showCustomerForm(customer),
                child: cellText(customer['phone'], colWidths[2]),
              ),
              InkWell(
                onTap: () => _showCustomerForm(customer),
                child: cellText(_formatDate(customer['dateJoined']), colWidths[3]), // Định dạng ngày
              ),
              InkWell(
                onTap: () => _showCustomerForm(customer),
                child: cellText(customer['transaction'].toString(), colWidths[4]),
              ),
              InkWell(
                onTap: () => _showCustomerForm(customer),
                child: cellText(customer['point'].toString(), colWidths[5]),
              ),
              InkWell(
                onTap: () => _showCustomerForm(customer),
                child: Container(
                  width: colWidths[6],
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Chip(
                    label: Text(
                      customer['rank'],
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: _getRankColor(customer['rank']),
                  ),
                ),
              ),
              InkWell(
                onTap: () => _showCustomerForm(customer),
                child: GestureDetector(
                  onTap: () => _toggleStatus(customer),
                  child: Container(
                    width: colWidths[7],
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Chip(
                      label: Text(
                        customer['status'],
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: _getStatusColor(customer['status']),
                    ),
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

  Widget customerCell(Map<String, dynamic> customer, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde',
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                customer['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                "ID: ${customer['id']}",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = Responsive.isMobile(context);
        final tableWidth = constraints.maxWidth;

        final List<double> colWidths = isMobile
            ? [tableWidth * 0.08, tableWidth * 0.45, tableWidth * 0.3]
            : [
                tableWidth * 0.05,
                tableWidth * 0.20,
                tableWidth * 0.1,
                tableWidth * 0.1,
                tableWidth * 0.1,
                tableWidth * 0.1,
                tableWidth * 0.1,
                tableWidth * 0.12,
              ];

        final headers = isMobile
            ? ["ID", "Customer", "Phone"]
            : [
                "ID",
                "Customer",
                "Phone",
                "Date Joined",
                "Transaction",
                "Point",
                "Rank",
                "Status"
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
              /// Header + Search
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Customer List",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 200,
                    height: 36,
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        hintText: "Search by name",
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

              /// Table
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
                      ...filteredCustomers
                          .map((customer) => buildCustomerRow(customer, colWidths)),
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