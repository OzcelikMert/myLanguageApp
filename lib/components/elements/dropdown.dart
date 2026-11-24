import 'package:flutter/material.dart';
import 'package:advanced_searchable_dropdown/advanced_searchable_dropdown.dart';

class ComponentDropdown<T> extends StatelessWidget {
  final List<T> items;
  final void Function(T?)? onChanged;
  final String Function(T)? itemAsString;
  final String? hintText;
  final T? selectedItem;

  const ComponentDropdown({
    Key? key,
    required this.items,
    this.onChanged,
    this.itemAsString,
    this.hintText,
    this.selectedItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Map your custom items to SearchableDropDownItem structure
    final dropdownItems = items.map((item) {
      final labelText = itemAsString != null ? itemAsString!(item) : item.toString();
      return SearchableDropDownItem(
        label: labelText,
        value: item,
      );
    }).toList();

    return SearchableDropDown(
      menuList: dropdownItems,
      value: selectedItem,
      hintText: hintText ?? "Select option",
      decoration: InputDecoration(
        labelText: hintText,
        border: const OutlineInputBorder(),
      ),
      onSelected: (SearchableDropDownItem? selectedDropDownItem) {
        if (onChanged != null) {
          onChanged!(selectedDropDownItem?.value);
        }
      },
    );
  }
}