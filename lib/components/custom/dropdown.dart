import 'package:flutter/material.dart';

class DropdownCustom extends StatefulWidget {
  const DropdownCustom(
      {super.key, required this.items, required this.onChanged});
  final Function(String) onChanged;
  final List<String> items;

  @override
  State<DropdownCustom> createState() => _DropdownCustomState();
}

class _DropdownCustomState extends State<DropdownCustom> {
  String? selectedValue;
  @override
  void initState() {
    super.initState();
    selectedValue = widget.items.isNotEmpty ? widget.items[0] : null;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      underline: const SizedBox.shrink(),
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(8),
      value: selectedValue,
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
        if (newValue != null) {
          widget.onChanged(newValue);
          setState(() {
            selectedValue = newValue;
          });
        }
      },
    );
  }
}
