import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; // Thêm intl để định dạng ngày

class CustomerForm extends StatefulWidget {
  final void Function(Map<String, dynamic>) onSubmit;
  final void Function()? onDelete;
  final String buttonLabel;
  final Map<String, dynamic>? initialCustomer;

  const CustomerForm({
    super.key,
    required this.onSubmit,
    this.onDelete,
    required this.buttonLabel,
    this.initialCustomer,
  });

  @override
  State<CustomerForm> createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController addressController;
  late TextEditingController dateJoinedController;
  String rank = 'Bronze';
  bool isDisabled = false;

  // Định dạng ngày
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    final data = widget.initialCustomer;

    nameController = TextEditingController(text: data?['name'] ?? '');
    phoneController = TextEditingController(text: data?['phone'] ?? '');
    emailController = TextEditingController(text: data?['email'] ?? '');
    addressController = TextEditingController(text: data?['address'] ?? '');

    // Định dạng dateJoined từ yyyy-MM-dd sang dd/MM/yyyy
    String initialDate = data?['dateJoined'] ?? '';
    if (initialDate.isNotEmpty) {
      try {
        final DateTime parsedDate = DateTime.parse(initialDate);
        initialDate = _dateFormat.format(parsedDate);
      } catch (e) {
        // Nếu không parse được, giữ nguyên giá trị
      }
    }
    dateJoinedController = TextEditingController(text: initialDate);

    rank = data?['rank'] ?? 'Bronze';
    isDisabled = data?['status'] == 'Disabled';
  }

  // Hàm chuyển đổi từ dd/MM/yyyy sang yyyy-MM-dd
  String _convertToApiFormat(String date) {
    try {
      final DateTime parsedDate = _dateFormat.parseStrict(date);
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      return date; // Trả về nguyên bản nếu không parse được
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 800,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: CircleAvatar(
                      radius: 100,
                      backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Customer Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9\-]')),
                    ],
                    decoration: const InputDecoration(
                      labelText: "Phone Number",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Email Address",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: "Address",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: dateJoinedController,
                    keyboardType: TextInputType.datetime,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')), // Chỉ cho phép số và dấu /
                      LengthLimitingTextInputFormatter(10), // Giới hạn độ dài
                      _DateInputFormatter(), // Formatter tùy chỉnh
                    ],
                    decoration: const InputDecoration(
                      labelText: "Date Joined (dd/MM/yyyy)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Rank",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return SizedBox(
                            width: double.infinity,
                            child: DropdownMenu<String>(
                              width: constraints.maxWidth,
                              initialSelection: rank,
                              onSelected: (value) => setState(() => rank = value!),
                              dropdownMenuEntries: ['Bronze', 'Silver', 'Gold', 'Platinum']
                                  .map((rank) => DropdownMenuEntry(value: rank, label: rank))
                                  .toList(),
                              textStyle: const TextStyle(fontSize: 14, color: Colors.black),
                              menuStyle: MenuStyle(
                                maximumSize: WidgetStatePropertyAll(
                                  Size(constraints.maxWidth, double.infinity),
                                ),
                                backgroundColor: const WidgetStatePropertyAll(Colors.white),
                              ),
                              inputDecorationTheme: const InputDecorationTheme(
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                        value: isDisabled,
                        onChanged: (value) => setState(() => isDisabled = value!),
                      ),
                      const Text("Disable Customer"),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final customerData = {
                              'name': nameController.text,
                              'phone': phoneController.text,
                              'email': emailController.text,
                              'address': addressController.text,
                              'dateJoined': _convertToApiFormat(dateJoinedController.text), // Chuyển sang yyyy-MM-dd
                              'rank': rank,
                              'status': isDisabled ? 'Disabled' : 'Active',
                            };
                            widget.onSubmit(customerData);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            minimumSize: const Size(double.infinity, 48),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          child: Text(widget.buttonLabel, style: const TextStyle(color: Colors.white)),
                        ),
                      ),
                      if (widget.onDelete != null) ...[
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: widget.onDelete,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              minimumSize: const Size(double.infinity, 48),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            child: const Text("Delete", style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Formatter tùy chỉnh để đảm bảo định dạng dd/MM/yyyy
class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    // Xóa các ký tự không hợp lệ
    text = text.replaceAll(RegExp(r'[^0-9/]'), '');

    // Tự động thêm dấu / khi cần
    if (text.length == 2 && oldValue.text.length < newValue.text.length) {
      text += '/';
    } else if (text.length == 5 && oldValue.text.length < newValue.text.length) {
      text += '/';
    }

    // Giới hạn độ dài
    if (text.length > 10) {
      text = text.substring(0, 10);
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}