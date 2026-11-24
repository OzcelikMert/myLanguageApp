import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mylanguageapp/constants/theme.const.dart';

class ComponentAutoCompleteTextField<T> extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? onValidator;
  final Future<List<T>> Function(String) suggestionItems;
  final String Function(T) itemBuilderText;
  final Function(T) onSuggestionSelected;

  ComponentAutoCompleteTextField({
    this.hintText,
    this.controller,
    this.onValidator,
    required this.suggestionItems,
    required this.itemBuilderText,
    required this.onSuggestionSelected,
  });

  @override
  State<StatefulWidget> createState() =>
      _ComponentAutoCompleteTextFieldState<T>();
}

class _ComponentAutoCompleteTextFieldState<T>
    extends State<ComponentAutoCompleteTextField<T>> {
  @override
  Widget build(BuildContext context) {
    return TypeAheadField<T>(
      retainOnLoading: false,
      builder: (context, controller, focusNode) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          validator: widget.onValidator,
          decoration: InputDecoration(labelText: widget.hintText),
        );
      },
      listBuilder: (context, children) {
        return ListView(
          shrinkWrap: true,
          children: [
            Padding(padding: EdgeInsets.all(ThemeConst.paddings.sm)),
            Center(
              child: Text(
                "${children.length} items found",
                style: TextStyle(
                  fontSize: ThemeConst.fontSizes.sm,
                  color: ThemeConst.colors.light,
                ),
              ),
            ),
            ...children.map((e) => Column(children: [Divider(), e])).toList(),
          ],
        );
      },
      suggestionsCallback: (pattern) async {
        if (pattern != null && pattern.isNotEmpty) {
          return await widget.suggestionItems(pattern) as List<T>;
        }
        return [];
      },
      itemBuilder: (context, suggestion) {
        return ListTile(title: Text(widget.itemBuilderText(suggestion)));
      },
      onSelected: widget.onSuggestionSelected,
    );
  }
}
