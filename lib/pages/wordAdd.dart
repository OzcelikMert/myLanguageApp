import 'package:flutter/material.dart';
import 'package:my_language_app/components/elements/form.dart';
import 'package:my_language_app/components/elements/radio.dart';
import 'package:my_language_app/config/db/tables/languages.dart';
import 'package:my_language_app/config/db/tables/words.dart';
import 'package:my_language_app/constants/studyType.const.dart';
import 'package:my_language_app/constants/theme.const.dart';
import 'package:my_language_app/lib/dialog.lib.dart';
import 'package:my_language_app/lib/provider.lib.dart';
import 'package:my_language_app/models/components/elements/dialog/options.dart';
import 'package:my_language_app/models/providers/language.provider.dart';
import 'package:my_language_app/models/providers/page.provider.dart';
import 'package:my_language_app/models/services/word.model.dart';
import 'package:my_language_app/services/word.service.dart';

class PageWordAdd extends StatefulWidget {
  final BuildContext context;
  late int wordId = 0;

  PageWordAdd({Key? key, required this.context}) : super(key: key) {
    var args =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args != null && args[DBTableWords.columnId] != null) {
      wordId = int.tryParse(args[DBTableWords.columnId].toString()) ?? 0;
    }
  }

  @override
  State<StatefulWidget> createState() => _PageWordAddState();
}

class _PageWordAddState extends State<PageWordAdd> {
  late Map<String, dynamic>? _stateWord = null;
  int _stateSelectedStudyType = StudyTypeConst.Daily;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _controllerTextNative = TextEditingController();
  final _controllerTextTarget = TextEditingController();
  final _controllerComment = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _pageInit();
    });
  }

  _pageInit() async {
    final pageProviderModel =
   ProviderLib.get<PageProviderModel>(context);
    pageProviderModel.setTitle(widget.wordId > 0 ? "Update Word"  : "Add New Word");
    final languageProviderModel =
   ProviderLib.get<LanguageProviderModel>(context);

    var words = await WordService.get(WordGetParamModel(wordLanguageId: languageProviderModel.selectedLanguage[DBTableLanguages.columnId], wordId: widget.wordId));
    if(words.isNotEmpty){
      var word = words[0];
      setState(() {
        _stateWord = word;
        _stateSelectedStudyType = word[DBTableWords.columnStudyType];
        _controllerTextNative.text = word[DBTableWords.columnTextNative];
        _controllerTextTarget.text = word[DBTableWords.columnTextTarget];
        _controllerComment.text = word[DBTableWords.columnComment];
      });
    }

    pageProviderModel.setIsLoading(false);
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
                final languageProviderModel =
               ProviderLib.get<LanguageProviderModel>(context);
                await DialogLib.show(
                    context,
                    ComponentDialogOptions(
                        content: _stateWord != null ? "Updating..." : "Adding...",
                        icon: ComponentDialogIcon.loading));
                int result = 0;
                if(_stateWord != null){
                  result = await WordService.update(WordUpdateParamModel(
                      whereWordLanguageId: languageProviderModel.selectedLanguage[DBTableLanguages.columnId],
                      whereWordId: _stateWord![DBTableWords.columnId],
                      wordTextNative: _controllerTextNative.text.trim(),
                      wordTextTarget: _controllerTextTarget.text.trim(),
                      wordComment: _controllerComment.text.trim(),
                      wordStudyType: _stateSelectedStudyType));
                }else {
                  result = await WordService.add(WordAddParamModel(
                      wordLanguageId: languageProviderModel.selectedLanguage[DBTableLanguages.columnId],
                      wordTextNative: _controllerTextNative.text.trim(),
                      wordTextTarget: _controllerTextTarget.text.trim(),
                      wordComment: _controllerComment.text.trim(),
                      wordStudyType: _stateSelectedStudyType));
                }

                if (result > 0) {
                  if(_stateWord != null){
                    final pageProviderModel =
                   ProviderLib.get<PageProviderModel>(context);
                    pageProviderModel.setLeadingArgs(true);
                  }else {
                    _controllerTextNative.text = "";
                    _controllerTextTarget.text = "";
                    _controllerComment.text = "";
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
    final pageProviderModel =
   ProviderLib.get<PageProviderModel>(context, listen: true);
    final languageProviderModel =
   ProviderLib.get<LanguageProviderModel>(context, listen: true);

    return pageProviderModel.isLoading ? Container() : Center(
      child: ComponentForm(
        formKey: _formKey,
        onSubmit: onClickAdd,
        submitButtonText: _stateWord != null ? "Update" : "Add",
        children: <Widget>[
          Text("Target Language (${languageProviderModel.selectedLanguage[DBTableLanguages.columnName]})"),
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
    );
  }
}
