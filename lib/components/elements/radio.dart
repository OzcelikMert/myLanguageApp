import 'package:flutter/material.dart';

class ComponentRadio<T> extends StatelessWidget {
  final String title;
  final void Function(T?) onChanged;
  final T value;
  final T groupValue;

  const ComponentRadio({Key? key, required this.title, required this.onChanged, required this.value, required this.groupValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onChanged(value),
      title: Text(title),
      leading: Radio(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
      ),
    );
  }
}