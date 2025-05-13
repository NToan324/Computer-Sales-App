import 'package:flutter/material.dart';

class DropdownCustom extends StatefulWidget {
  const DropdownCustom({super.key, required this.items});
  final List<String> items;

  @override
  State<DropdownCustom> createState() => _DropdownCustomState();
}

class _DropdownCustomState extends State<DropdownCustom> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      underline: const SizedBox.shrink(),
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(8),
      value: widget.items[0],
      items: widget.items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        // Handle sort change
      },
    );
  }
}
