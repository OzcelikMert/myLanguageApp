import 'package:flutter/material.dart';
import 'package:my_language_app/constants/theme.const.dart';

import 'button.dart';

class ComponentForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final VoidCallback onSubmit;
  final String? submitButtonText;
  final IconData? submitButtonIcon;
  final List<Widget> children;

  const ComponentForm(
      {Key? key,
      required this.formKey,
      required this.onSubmit,
      this.submitButtonText,
      required this.children, this.submitButtonIcon})
      : super(key: key);

  void _onPressed() {
    if (formKey.currentState!.validate()) {
      formKey.currentState?.save();
      onSubmit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ...children,
          Padding(padding: EdgeInsets.all(ThemeConst.paddings.md)),
          ComponentButton(
            onPressed: () => _onPressed(),
            text: submitButtonText ?? "Submit",
            icon: submitButtonIcon,
          ),
        ],
      ),
    );
  }
}
