import 'package:flutter/material.dart';
import 'package:my_language_app/components/elements/form.dart';
import 'package:my_language_app/components/tools/pageScaffold.dart';
import 'package:my_language_app/components/elements/radio.dart';
import 'package:my_language_app/constants/studyTypes.const.dart';
import 'package:my_language_app/lib/dialog.lib.dart';

class PageStudySettings extends StatefulWidget {
  PageStudySettings({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageStudySettingsState();
}

class _PageStudySettingsState extends State<PageStudySettings> {
  int _stateSelectedStudyType = StudyTypes.Daily;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _updateState();
  }

  void _updateState() async {

  }

  void onClickSave() {
    if (_formKey.currentState!.validate()) {
      (DialogLib(context)).showMessage(
          title: "Are you sure?",
          content: "You have selected 'daily'. Are you sure about this?",
          onPressedOkay: () {
            Navigator.pushNamed(context, '/study/daily');
          });
    }
  }

  void onChangeStudyType(int? value) {
    if (value != null) {
      setState(() {
        _stateSelectedStudyType = value;
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
        title: "Study Settings",
        hideSidebar: true,
        withScroll: true,
        body: Column(
          children: <Widget>[
            const Padding(padding: EdgeInsets.all(50)),
            ComponentForm(
              formKey: _formKey,
              onSubmit: onClickSave,
              submitButtonText: "Save",
              submitButtonIcon: Icons.save,
              children: <Widget>[
                const Center(
                    child: Text("Type", style: TextStyle(fontSize: 25))
                ),
                const Padding(padding: EdgeInsets.all(16)),
                ComponentRadio<int>(
                  title: StudyTypes.getTypeName(StudyTypes.Daily),
                  value: StudyTypes.Daily,
                  groupValue: _stateSelectedStudyType,
                  onChanged: onChangeStudyType,
                ),
                ComponentRadio<int>(
                  title: StudyTypes.getTypeName(StudyTypes.Weekly),
                  value: StudyTypes.Weekly,
                  groupValue: _stateSelectedStudyType,
                  onChanged: onChangeStudyType,
                ),
                ComponentRadio<int>(
                  title: StudyTypes.getTypeName(StudyTypes.Monthly),
                  value: StudyTypes.Monthly,
                  groupValue: _stateSelectedStudyType,
                  onChanged: onChangeStudyType,
                ),
              ],
            ),
          ],
        ));
  }
}
