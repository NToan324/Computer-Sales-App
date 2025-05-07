import 'package:computer_sales_app/config/color.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:intl/intl.dart';

class ChatArea extends StatefulWidget {
  final Map<String, dynamic> customer;
  final VoidCallback? onBack;

  const ChatArea({super.key, required this.customer, this.onBack});

  @override
  State<ChatArea> createState() => _ChatAreaState();
}

class _ChatAreaState extends State<ChatArea> {
  final ScrollController _scrollController = ScrollController();
  late List<Map<String, dynamic>> messages;

  @override
  void initState() {
    super.initState();
    messages = List.from(widget.customer['messages']);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      messages.add({
        'sender': 'support',
        'text': text.trim(),
        'timestamp': DateTime.now(),
      });
      widget.customer['lastMessage'] = text.trim();
      widget.customer['lastMessageTime'] = DateTime.now();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Column(
      children: [
        if (isMobile)
          AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: widget.onBack,
            ),
            title: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.customer['avatar']),
                ),
                const SizedBox(width: 8),
                Text(widget.customer['name']),
                const SizedBox(width: 8),
                if (widget.customer['isOnline'])
                  const Text(
                    "Online",
                    style: TextStyle(fontSize: 14, color: AppColors.lime),
                  ),
              ],
            ),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
        if (!isMobile)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.customer['avatar']),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.customer['name'],
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                if (widget.customer['isOnline'])
                  const Text(
                    "Online",
                    style: TextStyle(fontSize: 14, color: Colors.green),
                  ),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              final messageDate = message['timestamp'] as DateTime;
              final isToday = messageDate.day == DateTime.now().day &&
                  messageDate.month == DateTime.now().month &&
                  messageDate.year == DateTime.now().year;

              bool showDateHeader = index == 0 ||
                  messages[index - 1]['timestamp'].day != messageDate.day;

              return ChatMessage(
                message: message,
                isSupport: message['sender'] == 'support',
                customerAvatar: widget.customer['avatar'],
                showDateHeader: showDateHeader,
                isToday: isToday,
              );
            },
          ),
        ),
        ChatInput(
          onSend: _sendMessage,
        ),
      ],
    );
  }
}

class ChatMessage extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool isSupport;
  final String customerAvatar;
  final bool showDateHeader;
  final bool isToday;

  const ChatMessage({
    super.key,
    required this.message,
    required this.isSupport,
    required this.customerAvatar,
    required this.showDateHeader,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showDateHeader)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              isToday ? "Today" : DateFormat('dd/MM/yyyy').format(message['timestamp']),
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        Align(
          alignment: isSupport ? Alignment.centerRight : Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: isSupport ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isSupport)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    radius: 15,
                    backgroundImage: NetworkImage(customerAvatar),
                  ),
                ),
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.6,
                ),
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSupport ? AppColors.primary : Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment:
                      isSupport ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(
                      message['text'],
                      style: TextStyle(
                        color: isSupport ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateFormat('HH:mm').format(message['timestamp']),
                          style: TextStyle(
                            color: isSupport ? Colors.white70 : Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                        if (isSupport) ...[
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.done_all,
                            size: 16,
                            color: Colors.white70,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ChatInput extends StatelessWidget {
  final void Function(String) onSend;

  const ChatInput({super.key, required this.onSend});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file, color: Colors.grey),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Type your message here...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              onSubmitted: (value) {
                onSend(value);
                _controller.clear();
              },
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(
              Icons.send,
              color: AppColors.primary,
              size: 30,
            ),
            onPressed: () {
              onSend(_controller.text);
              _controller.clear();
            },
          ),
        ],
      ),
    );
  }
}