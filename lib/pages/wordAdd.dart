import 'package:flutter/material.dart';
import 'package:my_language_app/components/elements/form.dart';
import 'package:my_language_app/components/elements/radio.dart';
import 'package:my_language_app/components/tools/pageScaffold.dart';
import 'package:my_language_app/config/db/tables/words.dart';
import 'package:my_language_app/config/values.dart';
import 'package:my_language_app/constants/studyType.const.dart';
import 'package:my_language_app/constants/theme.const.dart';
import 'package:my_language_app/lib/dialog.lib.dart';
import 'package:my_language_app/lib/route.lib.dart';
import 'package:my_language_app/models/components/elements/dialog/options.dart';
import 'package:my_language_app/models/services/word.model.dart';
import 'package:my_language_app/services/word.service.dart';

class PageWordAdd extends StatefulWidget {
  final BuildContext context;
  late Map<String, dynamic>? args;

  PageWordAdd({Key? key, required this.context}) : super(key: key) {
    args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
  }

  @override
  State<StatefulWidget> createState() => _PageWordAddState();
}

class _PageWordAddState extends State<PageWordAdd> {
  late bool _statePageIsLoading = true;
  late bool _stateIsUpdated = false;
  late Map<String, dynamic>? _stateWord = null;
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
    if(widget.args != null){
      var words = await WordService.get(WordGetParamModel(wordLanguageId: Values.getLanguageId, wordId: widget.args![DBTableWords.columnId]));
      if(words.isNotEmpty){
        var word = words[0];
        setState(() {
          _stateWord = word;
          _stateSelectedStudyType = word[DBTableWords.columnStudyType];
          _controllerTextNative.text = word[DBTableWords.columnTextNative];
          _controllerTextTarget.text = word[DBTableWords.columnTextTarget];
          _controllerComment.text = word[DBTableWords.columnComment];
        });
      }else {
        await RouteLib(context).change(target: '/word/list');
        return false;
      }
    }

    setState(() {
      _statePageIsLoading = false;
    });
  }

  void onClickAdd() async {
    DialogLib.show(
        context,
        ComponentDialogOptions(
            title: "Are you sure?",
            icon: ComponentDialogIcon.confirm,
            showCancelButton: true,
            content:
                "Do you want to ${_stateWord != null ? "update" : "add"} '${_controllerTextNative.text}' as a word for your '${StudyTypeConst.getTypeName(_stateSelectedStudyType)}' study?",
            onPressed: (bool isConfirm) async {
              if (isConfirm) {
                DialogLib.show(
                    context,
                    ComponentDialogOptions(
                        content: _stateWord != null ? "Updating..." : "Adding...",
                        icon: ComponentDialogIcon.loading));
                int result = 0;
                if(_stateWord != null){
                  result = await WordService.update(WordUpdateParamModel(
                      wordId: _stateWord![DBTableWords.columnId],
                      wordTextNative: _controllerTextNative.text,
                      wordTextTarget: _controllerTextTarget.text,
                      wordComment: _controllerComment.text,
                      wordStudyType: _stateSelectedStudyType));
                }else {
                  result = await WordService.add(WordAddParamModel(
                      wordLanguageId: Values.getLanguageId,
                      wordTextNative: _controllerTextNative.text,
                      wordTextTarget: _controllerTextTarget.text,
                      wordComment: _controllerComment.text,
                      wordStudyType: _stateSelectedStudyType));
                }

                if (result > 0) {
                  if(_stateWord != null){
                    setState(() {
                      _stateIsUpdated = true;
                    });
                  }else {
                    _controllerTextNative.text = "";
                    _controllerTextTarget.text = "";
                    _controllerComment.text = "";
                    setState(() {
                      _stateSelectedStudyType = StudyTypeConst.Daily;
                    });
                  }
                  DialogLib.show(
                      context,
                      ComponentDialogOptions(
                          content:
                          "'${_controllerTextNative.text}' has successfully ${_stateWord != null ? "updated" : "added"}!",
                          icon: ComponentDialogIcon.success));
                } else {
                  DialogLib.show(
                      context,
                      ComponentDialogOptions(
                          content: "It couldn't ${_stateWord != null ? "update" : "add"}!",
                          icon: ComponentDialogIcon.error));
                }
                return false;
              }
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
      title: _stateWord != null ? "Update Word"  : "Add New Word",
      withScroll: true,
      leadingArgs: _stateIsUpdated,
      hideSidebar: _stateWord != null,
      body: Center(
        child: ComponentForm(
          formKey: _formKey,
          onSubmit: onClickAdd,
          submitButtonText: _stateWord != null ? "Update" : "Add",
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
