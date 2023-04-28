import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class ComponentDropdown<T> extends StatelessWidget {
  final List<T> items;
  final void Function(T?)? onChanged;
  final String Function(T)? itemAsString;
  final String? hintText;

  const ComponentDropdown({Key? key, required this.items, this.onChanged, this.itemAsString, this.hintText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      popupProps: const PopupProps.dialog(
          showSearchBox: true,
          searchDelay: Duration(milliseconds: 100)
      ),
      items: items,
      itemAsString: itemAsString,
      onChanged: onChanged,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          hintText: hintText,
        ),
      ),
    );
  }
}