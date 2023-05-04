import 'package:flutter/material.dart';
import 'package:my_language_app/components/elements/form.dart';
import 'package:my_language_app/components/elements/radio.dart';
import 'package:my_language_app/components/tools/pageScaffold.dart';
import 'package:my_language_app/config/values.dart';
import 'package:my_language_app/constants/studyType.const.dart';
import 'package:my_language_app/constants/theme.const.dart';
import 'package:my_language_app/lib/dialog.lib.dart';
import 'package:my_language_app/models/components/elements/dialog/options.dart';
import 'package:my_language_app/models/services/word.model.dart';
import 'package:my_language_app/services/word.service.dart';

class PageWordAdd extends StatefulWidget {
  const PageWordAdd({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageWordAddState();
}

class _PageWordAddState extends State<PageWordAdd> {
  late bool _statePageIsLoading = true;
  int _stateSelectedStudyType = StudyTypeConst.Daily;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _controllerTextNative = TextEditingController();
  final _controllerTextTarget = TextEditingController();
  final _controllerComment = TextEditingController();

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

  void onClickAdd() async {
    DialogLib.show(
        context,
        ComponentDialogOptions(
            title: "Are you sure?",
            content:
                "Do you want to add '${_controllerTextNative.text}' as a new word for your '${StudyTypeConst.getTypeName(_stateSelectedStudyType)}' study?",
            onPressed: (bool isConfirm) {
              Future(() async {
                DialogLib.show(context,
                    ComponentDialogOptions(icon: ComponentDialogIcon.loading));
                var result = await WordService.add(WordAddParamModel(
                    wordLanguageId: Values.getLanguageId,
                    wordTextNative: _controllerTextNative.text,
                    wordTextTarget: _controllerTextTarget.text,
                    wordComment: _controllerComment.text,
                    wordStudyType: _stateSelectedStudyType));

                if (result > 0) {
                  DialogLib.show(
                      context,
                      ComponentDialogOptions(
                          content:
                              "'${_controllerTextNative.text}' successfully added!",
                          icon: ComponentDialogIcon.success));
                  _controllerTextNative.text = "";
                  _controllerTextTarget.text = "";
                  _controllerComment.text = "";
                  setState(() {
                    _stateSelectedStudyType = StudyTypeConst.Daily;
                  });
                } else {
                  DialogLib.show(
                      context,
                      ComponentDialogOptions(
                          content: "It couldn't add!",
                          icon: ComponentDialogIcon.error));
                }
              });
            }));
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
      isLoading: _statePageIsLoading,
      title: "Add New Word",
      withScroll: true,
      body: Center(
        child: ComponentForm(
          formKey: _formKey,
          onSubmit: onClickAdd,
          submitButtonText: "Add",
          children: <Widget>[
            Text("Target Language (${Values.getLanguageName})"),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Word, Sentence or Question',
              ),
              validator: onValidator,
              controller: _controllerTextTarget,
            ),
            Padding(padding: EdgeInsets.all(ThemeConst.paddings.md)),
            const Text("Native Language"),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Word, Sentence or Question',
              ),
              validator: onValidator,
              controller: _controllerTextNative,
            ),
            Padding(padding: EdgeInsets.all(ThemeConst.paddings.md)),
            const Text("Comment"),
            TextFormField(
              decoration: const InputDecoration(
                hintText: '...',
              ),
              controller: _controllerComment,
            ),
            Padding(padding: EdgeInsets.all(ThemeConst.paddings.md)),
            const Text("Study Type"),
            ComponentRadio<int>(
              title: StudyTypeConst.getTypeName(StudyTypeConst.Daily),
              value: StudyTypeConst.Daily,
              groupValue: _stateSelectedStudyType,
              onChanged: onChangeStudyType,
            ),
            ComponentRadio<int>(
              title: StudyTypeConst.getTypeName(StudyTypeConst.Weekly),
              value: StudyTypeConst.Weekly,
              groupValue: _stateSelectedStudyType,
              onChanged: onChangeStudyType,
            ),
            ComponentRadio<int>(
              title: StudyTypeConst.getTypeName(StudyTypeConst.Monthly),
              value: StudyTypeConst.Monthly,
              groupValue: _stateSelectedStudyType,
              onChanged: onChangeStudyType,
            )
          ],
        ),
      ),
    );
  }
}
