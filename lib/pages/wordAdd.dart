import 'package:flutter/material.dart';
import 'package:my_language_app/components/elements/form.dart';
import 'package:my_language_app/components/tools/pageScaffold.dart';
import 'package:my_language_app/lib/dialog.lib.dart';

class PageWordAdd extends StatefulWidget {
  const PageWordAdd({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageWordAddState();
}

class _PageWordAddState extends State<PageWordAdd> {
  late bool _statePageIsLoading = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _pageInit();
  }

  _pageInit() async {
    setState(() {
      _statePageIsLoading = false;
    });
  }

  void onClickAdd() {
    if (_formKey.currentState!.validate()) {
      (DialogLib(context)).showMessage(
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
      isLoading: _statePageIsLoading,
      title: "Add New",
      body: Center(
        child: ComponentForm(
          formKey: _formKey,
          onSubmit: onClickAdd,
          submitButtonText: "Add",
          children: <Widget>[
            const Text("Target Language"),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Word, Sentence or Question',
              ),
              validator: onValidator,
            ),
            const Padding(padding: EdgeInsets.all(16)),
            const Text("Native Language"),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Word, Sentence or Question',
              ),
              validator: onValidator,
            ),
            const Padding(padding: EdgeInsets.all(16)),
            const Text("Comment"),
            TextFormField(
              decoration: const InputDecoration(
                hintText: '...',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
