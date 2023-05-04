import 'package:flutter/material.dart';

class ComponentSearchTextField extends StatelessWidget {
  final Function(String) onTextChanged;

  ComponentSearchTextField({required this.onTextChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onTextChanged,
      decoration: InputDecoration(
        hintText: 'Search...',
        border: InputBorder.none,
      ),
    );
  }
}