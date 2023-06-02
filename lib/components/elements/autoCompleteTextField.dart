import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:my_language_app/constants/theme.const.dart';

class ComponentAutoCompleteTextField<T> extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? onValidator;
  final Future<List<T>> Function(String) suggestionItems;
  final String Function(T) itemBuilderText;
  final Function(T) onSuggestionSelected;

  ComponentAutoCompleteTextField({this.hintText, this.controller, this.onValidator, required this.suggestionItems, required this.itemBuilderText, required this.onSuggestionSelected});

  @override
  State<StatefulWidget> createState() => _ComponentAutoCompleteTextFieldState<T>();
}

class _ComponentAutoCompleteTextFieldState<T> extends State<ComponentAutoCompleteTextField<T>> {
  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField<T>(
      keepSuggestionsOnLoading: false,
      validator: widget.onValidator,
      textFieldConfiguration: TextFieldConfiguration(
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.hintText,
        ),
      ),
      layoutArchitecture: (items, scrollController) {
        return ListView(
            controller: scrollController,
            shrinkWrap: true,
            children: [
              Padding(padding: EdgeInsets.all(ThemeConst.paddings.sm)),
              Center(child: Text("${items.length} items found", style: TextStyle(fontSize: ThemeConst.fontSizes.sm, color: ThemeConst.colors.light))),
              ...items.map((e) => Column(children: [Divider(), e])).toList()
            ]);
      },
      suggestionsCallback: (pattern) async {
        if(pattern != null && pattern.isNotEmpty){
          return await widget.suggestionItems(pattern) as dynamic;
        }
        return [];
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(widget.itemBuilderText(suggestion)),
        );
      },
      onSuggestionSelected: widget.onSuggestionSelected,
    );
  }
}