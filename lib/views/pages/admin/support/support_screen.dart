import 'package:flutter/material.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:computer_sales_app/views/pages/admin/support/widgets/chat_area.dart';
import 'package:computer_sales_app/views/pages/admin/support/widgets/chat_list.dart';
class SupportScreen extends StatefulWidget {
  final ValueChanged<bool> onChatAreaVisibilityChanged;

  const SupportScreen({
    super.key,
    required this.onChatAreaVisibilityChanged,
  });

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  Map<String, dynamic>? selectedCustomer;

  final List<Map<String, dynamic>> customers = [
    {
      "id": 1,
      "name": "John Doe",
      "phone": "123-456-7890",
      "email": "john.doe@example.com",
      "address": "123 Main St",
      "dateJoined": "2023-01-15",
      "transaction": 5,
      "point": 150,
      "rank": "Silver",
      "status": "Active",
      "avatar": "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde",
      "lastMessage": "How are you doing?",
      "lastMessageTime": DateTime.now().subtract(const Duration(minutes: 5)),
      "isOnline": true,
      "messages": [
        {
          "sender": "customer",
          "text": "Hello! I need help with my order.",
          "timestamp": DateTime.now().subtract(const Duration(days: 1)),
        },
        {
          "sender": "support",
          "text": "Hi! Please provide your order ID.",
          "timestamp": DateTime.now().subtract(const Duration(days: 1, minutes: 5)),
        },
        {
          "sender": "customer",
          "text": "How are you doing?",
          "timestamp": DateTime.now().subtract(const Duration(minutes: 5)),
        },
      ],
    },
    {
      "id": 2,
      "name": "Jane Smith",
      "phone": "987-654-3210",
      "email": "jane.smith@example.com",
      "address": "456 Oak Ave",
      "dateJoined": "2022-06-20",
      "transaction": 12,
      "point": 300,
      "rank": "Gold",
      "status": "Disabled",
      "avatar": "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde",
      "lastMessage": "See you tomorrow!",
      "lastMessageTime": DateTime.now().subtract(const Duration(minutes: 10)),
      "isOnline": false,
      "messages": [
        {
          "sender": "customer",
          "text": "I have a question about my account.",
          "timestamp": DateTime.now().subtract(const Duration(days: 2)),
        },
        {
          "sender": "support",
          "text": "Sure, what would you like to know?",
          "timestamp": DateTime.now().subtract(const Duration(days: 2, minutes: 10)),
        },
        {
          "sender": "customer",
          "text": "See you tomorrow!",
          "timestamp": DateTime.now().subtract(const Duration(minutes: 10)),
        },
      ],
    },
    {
      "id": 3,
      "name": "Alice Johnson",
      "phone": "555-123-4567",
      "email": "alice.j@example.com",
      "address": "789 Pine Rd",
      "dateJoined": "2024-03-10",
      "transaction": 2,
      "point": 50,
      "rank": "Bronze",
      "status": "Active",
      "avatar": "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde",
      "lastMessage": "Hello! Have you seen my backpack anywhere in office?",
      "lastMessageTime": DateTime.now().subtract(const Duration(minutes: 2)),
      "isOnline": true,
      "messages": [
        {
          "sender": "customer",
          "text": "Hello! Have you seen my backpack anywhere in office?",
          "timestamp": DateTime.now().subtract(const Duration(minutes: 2)),
        },
        {
          "sender": "support",
          "text": "Hi, yes, David have found it, ask our concierge...",
          "timestamp": DateTime.now().subtract(const Duration(minutes: 1)),
        },
      ],
    },
  ];

  void _selectCustomer(Map<String, dynamic> customer) {
    setState(() {
      selectedCustomer = customer;
      widget.onChatAreaVisibilityChanged(selectedCustomer != null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Container(
      color: Colors.grey[100],
      child: isMobile
          ? selectedCustomer == null
              ? ChatList(
                  customers: customers,
                  onSelectCustomer: _selectCustomer,
                )
              : ChatArea(
                  customer: selectedCustomer!,
                  onBack: () {
                    setState(() {
                      selectedCustomer = null;
                      widget.onChatAreaVisibilityChanged(selectedCustomer != null);
                    });
                  },
                )
          : Row(
              children: [
                SizedBox(
                  width: 300,
                  child: ChatList(
                    customers: customers,
                    onSelectCustomer: _selectCustomer,
                  ),
                ),
                Expanded(
                  child: selectedCustomer == null
                      ? const Center(child: Text("Chọn một khách hàng để trò chuyện"))
                      : ChatArea(customer: selectedCustomer!),
                ),
              ],
            ),
    );
  }
}