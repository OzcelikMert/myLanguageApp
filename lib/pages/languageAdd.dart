import 'package:flutter/material.dart';
import 'package:my_language_app/components/elements/form.dart';
import 'package:my_language_app/components/elements/pageScaffold.dart';
import 'package:my_language_app/lib/element.lib.dart';

import '../components/elements/button.dart';

class PageLanguageAdd extends StatefulWidget {
  const PageLanguageAdd({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageLanguageAddState();
}

class _PageLanguageAddState extends State<PageLanguageAdd> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void onClickAdd() {
    if (_formKey.currentState!.validate()) {
      (ElementLib(context)).showMessageBox(
          title: "Are you sure?",
          content: "You have selected 'daily'. Are you sure about this?",
          onPressedOkay: () {
            Navigator.pushNamed(context, '/study/daily');
          });
    }
  }

  String? onValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ComponentPageScaffold(
      title: "Add New",
      hideSidebar: true,
      body: Center(
        child: ComponentForm(
          formKey: _formKey,
          onSubmit: onClickAdd,
          submitButtonText: "Add",
          children: <Widget>[
            const Text("Language Name"),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Ex: English (UK)',
              ),
              validator: onValidator,
            ),
          ],
        ),
      ),
    );
  }
}
