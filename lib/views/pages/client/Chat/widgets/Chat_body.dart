import 'package:flutter/material.dart';

class ChatBody extends StatelessWidget {
  const ChatBody({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data đơn giản bên trong luôn
    final users = [
      {
        'name': 'Shane Martinez',
        'message': 'On my way home but I needed...',
        'time': '5 min',
        'avatar': 'https://i.pravatar.cc/150?img=1',
        'unread': true,
      },
      {
        'name': 'Katie Keller',
        'message': 'I\'m watching Friends. What are you doing?',
        'time': '15 min',
        'avatar': 'https://i.pravatar.cc/150?img=2',
        'unread': false,
      },
      {
        'name': 'Stephen Mann',
        'message': 'I\'m working now. I\'m making a deposit...',
        'time': '1 hour',
        'avatar': 'https://i.pravatar.cc/150?img=3',
        'unread': false,
      },
    ];

    final messages = [
      {'text': 'I\'m meeting a friend here for dinner.', 'isMe': true},
      {'text': 'Voice Message (2:30)', 'isMe': false},
      {'text': 'I\'m doing my homework, need a break.', 'isMe': true},
      {'text': 'On my way home but stopped by bookstore.', 'isMe': false},
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;
        return Container(
          color: Colors.white,
          child: Row(
            children: [
              if (!isMobile)
                Flexible(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        right: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                    ),
                    child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(user['avatar']! as String),
                          ),
                          title: Text(user['name']! as String,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(user['message']! as String,
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(user['time']! as String,
                                  style: const TextStyle(fontSize: 12)),
                              if (user['unread']! as bool)
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Text('1',
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.white)),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              Flexible(
                flex: 5,
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    const Text('Today', style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final msg = messages[index];
                          return Align(
                            alignment: msg['isMe']! as bool
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: msg['isMe']! as bool
                                    ? Colors.blueAccent
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                msg['text']! as String,
                                style: TextStyle(
                                    color: msg['isMe']! as bool
                                        ? Colors.white
                                        : Colors.black87),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      color: Colors.white,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Message...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                                fillColor: const Color(0xFFF0F0F0),
                                filled: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 0),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            child: const Icon(Icons.send, color: Colors.white),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
