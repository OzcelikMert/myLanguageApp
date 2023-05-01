import 'package:flutter/material.dart';
import 'package:my_language_app/components/elements/form.dart';
import 'package:my_language_app/components/tools/pageScaffold.dart';
import 'package:my_language_app/lib/dialog.lib.dart';
import 'package:my_language_app/models/services/language.model.dart';
import 'package:my_language_app/services/language.service.dart';

class PageLanguageAdd extends StatefulWidget {
  const PageLanguageAdd({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageLanguageAddState();
}

class _PageLanguageAddState extends State<PageLanguageAdd> {
  late bool _stateIsLoading = true;
  final _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _pageInit();
  }

  _pageInit() async {
    setState(() {
      _stateIsLoading = false;
    });
  }

  void onClickAdd() async {
    DialogLib(context).showMessage(
        title: "Are you sure?",
        content: "Are you sure want to add '${_nameController.text}' as a language ?",
        onPressedOkay: () async {
          DialogLib(context).showLoader();
          await Future.delayed(Duration(seconds: 1));
          var result = await LanguageService.add(LanguageAddParamModel(
            languageName: _nameController.text,
          ));
          DialogLib(context).hide();

          if(result > 0){
            DialogLib(context).showSuccess(content: "'${_nameController.text}' added!");
          }else {
            DialogLib(context).showError(content: "It couldn't add!");
          }
        });
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
      isLoading: _stateIsLoading,
      hideSidebar: true,
      body: Center(
        child: ComponentForm(
          formKey: _formKey,
          onSubmit: () => onClickAdd(),
          submitButtonText: "Add",
          children: <Widget>[
            const Text("Language Name"),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Ex: English (UK)',
              ),
              validator: onValidator,
              controller: _nameController,
            ),
          ],
        ),
      ),
    );
  }
}
