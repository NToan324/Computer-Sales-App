import 'package:flutter/material.dart';
import 'package:computer_sales_app/models/user.model.dart';
import 'package:computer_sales_app/services/user.service.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'customer_form.dart';

class CustomerTable extends StatefulWidget {
  final List<UserModel> customers;

  const CustomerTable({super.key, required this.customers});

  @override
  State<CustomerTable> createState() => _CustomerTableState();
}

class _CustomerTableState extends State<CustomerTable> {
  final TextEditingController _searchController = TextEditingController();
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  List<UserModel> get filteredCustomers {
    var customers = widget.customers;
    if (_searchController.text.isNotEmpty) {
      customers = customers.where((customer) {
        return customer.fullName
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
      }).toList();
    }
    final start = (_currentPage - 1) * _itemsPerPage;
    return customers.skip(start).take(_itemsPerPage).toList();
  }

  int get totalPages => (widget.customers.length / _itemsPerPage).ceil();

  Color _getStatusColor(bool isActive) {
    return isActive ? Colors.green : Colors.red;
  }

  List<Map<String, dynamic>> _getVisibleFields(UserModel customer) {
    final fields = [
      {'key': 'id', 'label': 'ID', 'isVisible': customer.id.isNotEmpty},
      {
        'key': 'fullName',
        'label': 'Customer',
        'isVisible': customer.fullName.isNotEmpty
      },
      {
        'key': 'phone',
        'label': 'Phone',
        'isVisible': customer.phone != null && customer.phone!.isNotEmpty
      },
      {
        'key': 'email',
        'label': 'Email',
        'isVisible': customer.email.isNotEmpty
      },
      {
        'key': 'loyaltyPoints',
        'label': 'Points',
        'isVisible': customer.loyaltyPoints > 0
      },
      {'key': 'isActive', 'label': 'Status', 'isVisible': true},
    ];
    return fields.where((field) => field['isVisible'] as bool).toList();
  }

  void _toggleStatus(UserModel customer) async {
    try {
      final updatedUser = await UserService().updateUserInfoById(
        userId: customer.id,
        isActive: !customer.isActive,
      );
      setState(() {
        final index = widget.customers.indexWhere((c) => c.id == customer.id);
        if (index != -1) {
          widget.customers[index] = updatedUser;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to toggle status: $e')),
      );
    }
  }

  void _showCustomerForm(UserModel customer) {
    final visibleFields = _getVisibleFields(customer);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            customer.fullName,
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
                'id': customer.id,
                'name': customer.fullName,
                'phone': customer.phone ?? '',
                'email': customer.email,
                'address': customer.address ?? '',
                'status': customer.isActive ? 'Active' : 'Disabled',
                'avatar': {
                  'url': customer.avatar?.url ?? '',
                  'public_id': customer.avatar?.public_id ?? '',
                },
              },
              visibleFields: visibleFields.map((
                  field) => field['key'] as String).toList(),
              onSubmit: (updatedCustomerData) async {
                try {
                  final updatedUser = await UserService().updateUserInfoById(
                    userId: customer.id,
                    isActive: updatedCustomerData['status'] == 'Active',
                  );
                  setState(() {
                    final index = widget.customers.indexWhere((c) =>
                    c.id == customer.id);
                    if (index != -1) {
                      widget.customers[index] = updatedUser;
                    }
                  });
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update customer: $e')),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  TableRow buildHeaderRow(List<Map<String, dynamic>> fields,
      List<double> colWidths) {
    return TableRow(
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 240, 240, 240)),
      children: List.generate(fields.length, (index) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          width: colWidths[index],
          child: Text(
            fields[index]['label'] as String,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      }),
    );
  }

  TableRow buildCustomerRow(UserModel customer,
      List<Map<String, dynamic>> fields, List<double> colWidths) {
    final isMobile = Responsive.isMobile(context);
    final visibleFields = isMobile ? fields.take(3).toList() : fields;

    return TableRow(
      children: visibleFields
          .asMap()
          .entries
          .map((entry) {
        final index = entry.key;
        final field = entry.value;
        final key = field['key'] as String;

        Widget cellContent;
        if (key == 'fullName') {
          cellContent = customerCell(customer, colWidths[index]);
        } else if (key == 'isActive') {
          cellContent = GestureDetector(
            onTap: () => _toggleStatus(customer),
            child: Container(
              width: colWidths[index],
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Chip(
                label: Text(
                  customer.isActive ? 'Active' : 'Disabled',
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: _getStatusColor(customer.isActive),
              ),
            ),
          );
        } else {
          String value;
          switch (key) {
            case 'id':
              value =
              customer.id.length > 5 ? customer.id.substring(0, 5) : customer
                  .id; // Chỉ lấy 5 ký tự đầu
              break;
            case 'phone':
              value = customer.phone ?? '';
              break;
            case 'email':
              value = customer.email;
              break;
            case 'loyaltyPoints':
              value = customer.loyaltyPoints.toString();
              break;
            default:
              value = '';
          }
          cellContent = cellText(value, colWidths[index]);
        }

        return InkWell(
          onTap: () => _showCustomerForm(customer),
          child: cellContent,
        );
      }).toList(),
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

  Widget customerCell(UserModel customer, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: customer.avatar?.url.isNotEmpty ?? false
                ? NetworkImage(customer.avatar!.url)
                : const NetworkImage(
              'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer.fullName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "ID: ${customer.id.length > 5
                      ? customer.id.substring(0, 5)
                      : customer.id}", // Chỉ lấy 5 ký tự đầu
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
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

        final visibleFields = widget.customers.isNotEmpty
            ? _getVisibleFields(widget.customers.first)
            : [
          {'key': 'id', 'label': 'ID', 'isVisible': true},
          {'key': 'fullName', 'label': 'Customer', 'isVisible': true},
          {'key': 'isActive', 'label': 'Status', 'isVisible': true},
        ];

        final List<double> colWidths = isMobile
            ? [tableWidth * 0.08, tableWidth * 0.45, tableWidth * 0.3]
            : List.generate(
            visibleFields.length, (index) => tableWidth / visibleFields.length);

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
          child: ConstrainedBox( // Thêm ConstrainedBox để giới hạn kích thước
            constraints: BoxConstraints(maxHeight: MediaQuery
                .of(context)
                .size
                .height * 0.8), // Giới hạn chiều cao
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: tableWidth.toDouble(),
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: {
                      for (int i = 0; i < visibleFields.length; i++)
                        i: FixedColumnWidth(colWidths[i]),
                    },
                    border: TableBorder.all(color: Colors.grey.shade300),
                    children: [
                      buildHeaderRow(visibleFields, colWidths),
                      ...filteredCustomers.map(
                            (customer) =>
                            buildCustomerRow(
                                customer, visibleFields, colWidths),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}