import 'dart:async';

import 'package:flutter/material.dart';

class ComponentSearchTextField extends StatefulWidget {
  final Function(String) onTextChanged;
  final String? hintText;

  ComponentSearchTextField({required this.onTextChanged, this.hintText});

  @override
  State<StatefulWidget> createState() => _ComponentSearchTextFieldState();
}

class _ComponentSearchTextFieldState extends State<ComponentSearchTextField> {
  Timer? _timer;
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onSearchTextChanged(String searchText) {
    if(searchText.isEmpty){
      setState(() {
        _controller.clear();
      });
    }

    if (_timer?.isActive ?? false) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: 100), () {
      widget.onTextChanged(searchText);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: _onSearchTextChanged,
      controller: _controller,
      decoration: InputDecoration(
        hintText: widget.hintText ?? 'Search...',
        border: InputBorder.none,
      ),
    );
  }
}