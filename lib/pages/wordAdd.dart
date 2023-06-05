import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_language_app/components/elements/autoCompleteTextField.dart';
import 'package:my_language_app/components/elements/form.dart';
import 'package:my_language_app/components/elements/radio.dart';
import 'package:my_language_app/config/db/tables/words.dart';
import 'package:my_language_app/constants/studyType.const.dart';
import 'package:my_language_app/constants/theme.const.dart';
import 'package:my_language_app/constants/wordType.const.dart';
import 'package:my_language_app/lib/dialog.lib.dart';
import 'package:my_language_app/lib/provider.lib.dart';
import 'package:my_language_app/models/components/elements/dialog/options.model.dart';
import 'package:my_language_app/models/providers/language.provider.model.dart';
import 'package:my_language_app/models/providers/page.provider.model.dart';
import 'package:my_language_app/models/services/word.model.dart';
import 'package:my_language_app/services/word.service.dart';

class PageWordAdd extends StatefulWidget {
  final BuildContext context;
  late int wordId = 0;

  PageWordAdd({Key? key, required this.context}) : super(key: key) {
    var args =
    ModalRoute
        .of(context)!
        .settings
        .arguments as Map<String, dynamic>?;
    if (args != null && args[DBTableWords.columnId] != null) {
      wordId = int.tryParse(args[DBTableWords.columnId].toString()) ?? 0;
    }
  }

  @override
  State<StatefulWidget> createState() => _PageWordAddState();
}

class _PageWordAddState extends State<PageWordAdd> {
  late WordGetResultModel? _stateWord = null;
  late int _stateSelectedStudyType = StudyTypeConst.daily;
  late int _stateSelectedWordType = WordTypeConst.word;
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
    final pageProviderModel = ProviderLib.get<PageProviderModel>(context);
    pageProviderModel
        .setTitle(widget.wordId > 0 ? "Update Word" : "Add New Word");
    final languageProviderModel =
    ProviderLib.get<LanguageProviderModel>(context);

    if(widget.wordId > 0){
      var words = await WordService.get(WordGetParamModel(
          wordLanguageId: languageProviderModel.selectedLanguage.languageId,
          wordId: widget.wordId));
      if (words.isNotEmpty) {
        var word = words[0];
        setState(() {
          _stateWord = word;
          _stateSelectedStudyType = word.wordStudyType;
          _stateSelectedWordType = word.wordType;
          _controllerTextNative.text = word.wordTextNative;
          _controllerTextTarget.text = word.wordTextTarget;
          _controllerComment.text = word.wordComment;
        });
      }
    }

    pageProviderModel.setLeadingArgs(null);
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
            "Do you want to ${_stateWord != null
                ? "update"
                : "add"} '${_controllerTextNative
                .text}' as a word for your '${StudyTypeConst.getTypeName(
                _stateSelectedStudyType)}' study?",
            onPressed: (bool isConfirm) async {
              if (isConfirm) {
                final languageProviderModel =
                ProviderLib.get<LanguageProviderModel>(context);
                await DialogLib.show(
                    context,
                    ComponentDialogOptions(
                        content:
                        _stateWord != null ? "Updating..." : "Adding...",
                        icon: ComponentDialogIcon.loading));
                int result = 0;
                if (_stateWord != null) {
                  result = await WordService.update(WordUpdateParamModel(
                      whereWordLanguageId:
                      languageProviderModel.selectedLanguage.languageId,
                      whereWordId: _stateWord!.wordId,
                      wordTextNative: _controllerTextNative.text.trim(),
                      wordTextTarget: _controllerTextTarget.text.trim(),
                      wordComment: _controllerComment.text.trim(),
                      wordStudyType: _stateSelectedStudyType,
                      wordType: _stateSelectedWordType
                  ));
                } else {
                  result = await WordService.add(WordAddParamModel(
                      wordLanguageId:
                      languageProviderModel.selectedLanguage.languageId,
                      wordTextNative: _controllerTextNative.text.trim(),
                      wordTextTarget: _controllerTextTarget.text.trim(),
                      wordComment: _controllerComment.text.trim(),
                      wordStudyType: _stateSelectedStudyType,
                      wordType: _stateSelectedWordType
                  ));
                }

                if (result > 0) {
                  DialogLib.show(
                      context,
                      ComponentDialogOptions(
                          content:
                          "'${_controllerTextNative
                              .text}' has successfully ${_stateWord != null
                              ? "updated"
                              : "added"}!",
                          icon: ComponentDialogIcon.success));
                  if (_stateWord != null) {
                    final pageProviderModel =
                    ProviderLib.get<PageProviderModel>(context);
                    var wordList = await WordService.get(
                        WordGetParamModel(
                            wordLanguageId: languageProviderModel
                                .selectedLanguage.languageId,
                            wordId: _stateWord!.wordId));
                    pageProviderModel.setLeadingArgs(wordList[0]);
                  } else {
                    _controllerTextNative.text = "";
                    _controllerTextTarget.text = "";
                    _controllerComment.text = "";
                  }
                } else {
                  DialogLib.show(
                      context,
                      ComponentDialogOptions(
                          content:
                          "It couldn't ${_stateWord != null
                              ? "update"
                              : "add"}!",
                          icon: ComponentDialogIcon.error));
                }
                return false;
              }
            }));
  }

  Future<List<WordGetResultModel>> getTargetSuggestions(String pattern) async {
    final languageProviderModel =
    ProviderLib.get<LanguageProviderModel>(context);

    return await WordService.get(WordGetParamModel(
        wordLanguageId: languageProviderModel.selectedLanguage.languageId,
        wordTextTarget: pattern
    ));
  }

  Future<List<WordGetResultModel>> getNativeSuggestions(String pattern) async {
    final languageProviderModel =
    ProviderLib.get<LanguageProviderModel>(context);

    return await WordService.get(WordGetParamModel(
        wordLanguageId: languageProviderModel.selectedLanguage.languageId,
        wordTextNative: pattern
    ));
  }

  void onChangeStudyType(int? value) {
    if (value != null) {
      setState(() {
        _stateSelectedStudyType = value;
      });
    }
  }

  void onChangeWordType(int? value) {
    if (value != null) {
      setState(() {
        _stateSelectedWordType = value;
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

    return pageProviderModel.isLoading
        ? Container()
        : Center(
      child: ComponentForm(
        formKey: _formKey,
        onSubmit: onClickAdd,
        submitButtonText: _stateWord != null ? "Update" : "Add",
        children: <Widget>[
          Text(
              "Target Language (${languageProviderModel.selectedLanguage
                  .languageName})"),
          ComponentAutoCompleteTextField<WordGetResultModel>(
              controller: _controllerTextTarget,
              hintText: 'Word, Sentence or Question',
              onValidator: onValidator,
              suggestionItems: getTargetSuggestions,
              itemBuilderText: (item) => item.wordTextTarget,
              onSuggestionSelected: (suggestion) {
                setState(() {
                  _controllerTextTarget.text = suggestion.wordTextTarget;
                });
              }
          ),
          Padding(padding: EdgeInsets.all(ThemeConst.paddings.md)),
          const Text("Native Language"),
          ComponentAutoCompleteTextField<WordGetResultModel>(
              controller: _controllerTextNative,
              hintText: 'Word, Sentence or Question',
              onValidator: onValidator,
              suggestionItems: getNativeSuggestions,
              itemBuilderText: (item) => item.wordTextNative,
              onSuggestionSelected: (suggestion) {
                setState(() {
                  _controllerTextNative.text = suggestion.wordTextNative;
                });
              }
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
          const Text("Word Type"),
          ComponentRadio<int>(
            title: WordTypeConst.getTypeName(WordTypeConst.word),
            value: WordTypeConst.word,
            groupValue: _stateSelectedWordType,
            onChanged: onChangeWordType,
          ),
          ComponentRadio<int>(
            title: WordTypeConst.getTypeName(WordTypeConst.sentence),
            value: WordTypeConst.sentence,
            groupValue: _stateSelectedWordType,
            onChanged: onChangeWordType,
          ),
          Padding(padding: EdgeInsets.all(ThemeConst.paddings.md)),
          const Text("Study Type"),
          ComponentRadio<int>(
            title: StudyTypeConst.getTypeName(StudyTypeConst.daily),
            value: StudyTypeConst.daily,
            groupValue: _stateSelectedStudyType,
            onChanged: onChangeStudyType,
          ),
          ComponentRadio<int>(
            title: StudyTypeConst.getTypeName(StudyTypeConst.weekly),
            value: StudyTypeConst.weekly,
            groupValue: _stateSelectedStudyType,
            onChanged: onChangeStudyType,
          ),
          ComponentRadio<int>(
            title: StudyTypeConst.getTypeName(StudyTypeConst.monthly),
            value: StudyTypeConst.monthly,
            groupValue: _stateSelectedStudyType,
            onChanged: onChangeStudyType,
          ),
        ],
      ),
    );
  }
}
