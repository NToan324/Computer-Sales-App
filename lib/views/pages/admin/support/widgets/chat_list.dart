import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatList extends StatelessWidget {
  final List<Map<String, dynamic>> customers;
  final void Function(Map<String, dynamic>) onSelectCustomer;

  const ChatList({
    super.key,
    required this.customers,
    required this.onSelectCustomer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Messages",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              const Text(
                "Sort by",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 12), // Tăng khoảng cách giữa "Sort by" và Dropdown
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return DropdownMenu<String>(
                      initialSelection: "Newest",
                      onSelected: (value) {},
                      dropdownMenuEntries: ["Newest", "Oldest"]
                          .map((value) => DropdownMenuEntry(value: value, label: value))
                          .toList(),
                      textStyle: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      menuStyle: MenuStyle(
                        elevation: const WidgetStatePropertyAll(4),
                        backgroundColor: const WidgetStatePropertyAll(Colors.white),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Colors.grey, width: 0.5),
                          ),
                        ),
                      ),
                      inputDecorationTheme: InputDecorationTheme(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Colors.blue, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.separated(
            itemCount: customers.length,
            itemBuilder: (context, index) {
              final customer = customers[index];
              return ChatListItem(
                customer: customer,
                onTap: () => onSelectCustomer(customer),
                showTyping: index == 1, // Giả lập "is typing" cho khách hàng thứ 2
              );
            },
            separatorBuilder: (context, index) => const Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}

class ChatListItem extends StatelessWidget {
  final Map<String, dynamic> customer;
  final VoidCallback onTap;
  final bool showTyping;

  const ChatListItem({
    super.key,
    required this.customer,
    required this.onTap,
    this.showTyping = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(customer['avatar']),
          ),
          if (customer['isOnline'])
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Text(customer['name']),
      subtitle: Text(
        customer['lastMessage'],
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat('HH:mm').format(customer['lastMessageTime']),
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          if (showTyping)
            const Text(
              "...is typing",
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
        ],
      ),
      onTap: onTap,
    );
  }
}