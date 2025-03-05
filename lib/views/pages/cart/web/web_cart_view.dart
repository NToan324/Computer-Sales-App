import 'package:flutter/material.dart';

class WebCartView extends StatelessWidget {
  const WebCartView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                margin: const EdgeInsets.only(top: 20),
                child: const Text("My Cart",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }
}
