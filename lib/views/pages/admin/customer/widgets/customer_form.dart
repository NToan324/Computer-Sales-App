import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomerForm extends StatefulWidget {
  final void Function(Map<String, dynamic>) onSubmit;
  final String buttonLabel;
  final Map<String, dynamic>? initialCustomer;
  final List<String> visibleFields;

  const CustomerForm({
    super.key,
    required this.onSubmit,
    required this.buttonLabel,
    this.initialCustomer,
    required this.visibleFields,
  });

  @override
  State<CustomerForm> createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  late bool isDisabled;

  @override
  void initState() {
    super.initState();
    final data = widget.initialCustomer;
    isDisabled = data?['status'] == 'Disabled';
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
                  child: Center(
                    child: CircleAvatar(
                      radius: 100,
                      backgroundImage: widget.initialCustomer?['avatar'] != null &&
                          widget.initialCustomer!['avatar']['url'].isNotEmpty
                          ? NetworkImage(widget.initialCustomer!['avatar']['url'])
                          : const NetworkImage(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hiển thị thông tin chỉ đọc
                  if (widget.visibleFields.contains('fullName')) ...[
                    const Text(
                      "Customer Name",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(widget.initialCustomer?['name'] ?? ''),
                    const SizedBox(height: 20),
                  ],
                  if (widget.visibleFields.contains('phone')) ...[
                    const Text(
                      "Phone Number",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(widget.initialCustomer?['phone'] ?? ''),
                    const SizedBox(height: 20),
                  ],
                  if (widget.visibleFields.contains('email')) ...[
                    const Text(
                      "Email Address",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(widget.initialCustomer?['email'] ?? ''),
                    const SizedBox(height: 20),
                  ],
                  if (widget.visibleFields.contains('address')) ...[
                    const Text(
                      "Address",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(widget.initialCustomer?['address'] ?? ''),
                    const SizedBox(height: 20),
                  ],
                  if (widget.visibleFields.contains('isActive')) ...[
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
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final customerData = {
                              if (widget.visibleFields.contains('isActive'))
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