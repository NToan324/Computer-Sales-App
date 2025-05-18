import 'package:flutter/material.dart';
import 'package:computer_sales_app/config/color.dart';

class MyTextField extends StatefulWidget {
  final String hintText;
  final IconData prefixIcon;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool obscureText;
  final bool disable;
  final TextInputType fieldType;

  const MyTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    required this.controller,
    this.focusNode,
    this.disable = false,
    this.fieldType = TextInputType.text,
    required this.obscureText,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 350,
      child: TextField(
        enabled: !widget.disable,
        keyboardType: widget.fieldType,
        controller: widget.controller,
        focusNode: widget.focusNode,
        obscureText: _obscure,
        cursorColor: AppColors.primary,
        decoration: InputDecoration(
          prefixIcon: Icon(
            widget.prefixIcon,
            color: Colors.grey,
          ),
          hintText: widget.hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black26),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.primary, width: 1),
          ),
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscure = !_obscure;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
