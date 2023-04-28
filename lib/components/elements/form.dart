import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ...children,
          const Padding(padding: EdgeInsets.all(16)),
          ComponentButton(
            onPressed: () => onSubmit(),
            text: submitButtonText ?? "Submit",
            icon: submitButtonIcon,
          ),
        ],
      ),
    );
  }
}
