import 'package:flutter/material.dart';
import 'package:my_language_app/components/elements/form.dart';
import 'package:my_language_app/components/elements/iconButton.dart';
import 'package:my_language_app/components/elements/pageScaffold.dart';
import 'package:my_language_app/lib/element.lib.dart';
import 'package:my_language_app/lib/route.lib.dart';

import '../components/elements/button.dart';

class PageStudy extends StatefulWidget {
  final int type;

  const PageStudy({Key? key, required this.type}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageStudyState();
}

class _PageStudyState extends State<PageStudy> {
  late int _type = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _type = widget.type;
  }

  void onClickApprove() {
    if (_formKey.currentState!.validate()) {
      (ElementLib(context)).showMessageBox(
          title: "Are you sure?",
          content: "You have selected 'daily'. Are you sure about this?",
          onPressedOkay: () {
            Navigator.pushNamed(context, '/study/daily');
          });
    }
  }

  void onClickBack() {
    if (_formKey.currentState!.validate()) {
      (ElementLib(context)).showMessageBox(
          title: "Are you sure?",
          content: "You have selected 'daily'. Are you sure about this?",
          onPressedOkay: () {
            RouteLib(context).change(target: "/study/plan");
          });
    }
  }

  void onClickSettings() {
    if (_formKey.currentState!.validate()) {
      (ElementLib(context)).showMessageBox(
          title: "Are you sure?",
          content: "You have selected 'daily'. Are you sure about this?",
          onPressedOkay: () {
            RouteLib(context).change(target: "/study/settings");
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
        title: "Study",
        hideAppBar: true,
        hideSidebar: true,
        withScroll: true,
        body: Column(
          children: <Widget>[
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  child: ComponentIconButton(
                      onPressed: onClickBack,
                      icon: Icons.arrow_back,
                  ),
                ),
                Container(
                  child: ComponentIconButton(
                      onPressed: onClickSettings,
                      icon: Icons.settings
                  ),
                )
              ],
            ),
            const SizedBox(height: 100),
            const Text(
              "[word]",
              style: TextStyle(fontSize: 35),
            ),
            const SizedBox(height: 50),
            const Text(
              "[comment]",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 75),
            ComponentForm(
              formKey: _formKey,
              onSubmit: onClickApprove,
              submitButtonText: "Approve",
              submitButtonIcon: Icons.check,
              children: <Widget>[
                const Text("[Native or Target Language Name]"),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: '...',
                  ),
                  validator: onValidator,
                ),
              ],
            ),
          ],
        ));
  }
}
