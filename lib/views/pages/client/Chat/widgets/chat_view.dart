import 'package:computer_sales_app/views/pages/client/home/widgets/appBar_widget.dart';
import 'package:flutter/material.dart';
import 'chat_appbar.dart';
import 'chat_body.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarHomeCustom(),
      body: const ChatBody(),
    );
  }
}
