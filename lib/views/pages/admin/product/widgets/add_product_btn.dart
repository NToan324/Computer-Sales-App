import 'package:flutter/material.dart';

class AddProductButton extends StatelessWidget {
  const AddProductButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        // Xử lý khi nhấn thêm sản phẩm ở đây
        print("Thêm sản phẩm");
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green, // Màu nền xanh
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Text(
        "ADD PRODUCT",
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
