import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_language_app/components/elements/form.dart';
import 'package:my_language_app/components/elements/iconButton.dart';
import 'package:my_language_app/components/tools/pageScaffold.dart';
import 'package:my_language_app/config/db/tables/words.dart';
import 'package:my_language_app/config/values.dart';
import 'package:my_language_app/constants/studyType.const.dart';
import 'package:my_language_app/constants/theme.const.dart';
import 'package:my_language_app/lib/dialog.lib.dart';
import 'package:my_language_app/lib/route.lib.dart';
import 'package:my_language_app/models/components/elements/dialog/options.dart';
import 'package:my_language_app/models/services/language.model.dart';
import 'package:my_language_app/models/services/word.model.dart';
import 'package:my_language_app/services/language.service.dart';
import 'package:my_language_app/services/word.service.dart';
import '../components/elements/button.dart';

class PageStudy extends StatefulWidget {
  late int studyType = 0;
  final BuildContext context;

  PageStudy({Key? key, required this.context}) : super(key: key) {
    var args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args != null && args[DBTableWords.columnStudyType] != null) {
      studyType = int.tryParse(args[DBTableWords.columnStudyType].toString()) ?? 0;
    }

    if (studyType == 0) {
      RouteLib(context).change(target: "/study/plan");
    }
  }

  @override
  State<StatefulWidget> createState() => _PageStudyState();
}

class _PageStudyState extends State<PageStudy> {
  late bool _stateIsStudied = false;
  late bool _stateIsLanguageDisplayedNative = false;
  late bool _statePageIsLoading = true;
  late List<Map<String, dynamic>> _stateWords = [];
  late Map<String, dynamic> _stateCurrentWord;
  late Map<String, dynamic> _stateLanguage;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _pageInit();
  }

  _pageInit() async {
    var words = await WordService.get(WordGetParamModel(
        wordLanguageId: Values.getLanguageId,
        wordStudyType: widget.studyType,
        wordIsStudy: 0));

    setState(() {
      _stateWords = words;
    });

    setLanguage();

    setCurrentWord();

    setState(() {
      _statePageIsLoading = false;
    });
  }

  void setLanguage() async {
    var languages = await LanguageService.get(LanguageGetParamModel(
        languageId: Values.getLanguageId
    ));

    setState(() {
      _stateLanguage = languages[0];
    });
  }

  void setCurrentWord() {
    var random = Random();
    int randomNumber = random.nextInt(_stateWords.length + 1);
    setState(() {
      _stateCurrentWord = _stateWords[randomNumber];
    });
  }

  void onClickNext() {}

  void onClickApprove() {}

  void onClickBack() {
    DialogLib.show(
        context,
        ComponentDialogOptions(
            title: "Are you sure?",
            content: "You have selected 'daily'. Are you sure about this?",
            showCancelButton: true,
            onPressed: (bool isConfirm) async {
              if (isConfirm) {
               await RouteLib(context).change(target: "/study/plan");
              }
            }));
  }

  void onClickSettings() async {
    bool isUpdated = await RouteLib(context)
        .change(target: "/study/settings", safeHistory: true);
    if(isUpdated == true) {
      setState(() {
        _stateIsLanguageDisplayedNative = Values.getLanguageDisplayedLanguage == 0;
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
        title: "Study",
        hideBackButton: true,
        hideAppBar: true,
        hideSidebar: true,
        withScroll: true,
        body: Column(
          children: <Widget>[
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
                  child: Text(StudyTypeConst.getTypeName(widget.studyType),
                      style: TextStyle(fontSize: ThemeConst.fontSizes.lg)),
                ),
                Container(
                  child: ComponentIconButton(
                      onPressed: onClickSettings, icon: Icons.settings),
                )
              ],
            ),
            Padding(padding: EdgeInsets.all(ThemeConst.paddings.xlg)),
            Text(
              _stateCurrentWord[_stateIsLanguageDisplayedNative ? DBTableWords.columnTextNative : DBTableWords.columnTextTarget],
              style: TextStyle(fontSize: ThemeConst.fontSizes.lg),
            ),
            Padding(padding: EdgeInsets.all(ThemeConst.paddings.sm)),
            Text(
              _stateCurrentWord[DBTableWords.columnComment],
              style: TextStyle(fontSize: ThemeConst.fontSizes.sm),
            ),
            Padding(padding: EdgeInsets.all(ThemeConst.paddings.xlg)),
            Text(_stateIsLanguageDisplayedNative ? "Native" : Values.getLanguageName),
            TextFormField(
              decoration: const InputDecoration(
                hintText: '...',
              )
            ),
            Padding(padding: EdgeInsets.all(ThemeConst.paddings.md)),
            ComponentButton(
              onPressed: onClickApprove,
              text: "Approve",
              icon: Icons.check
            ),
            Padding(padding: EdgeInsets.all(ThemeConst.paddings.md)),
            ComponentButton(
              onPressed: onClickNext,
              text: "Skip Next",
              icon: Icons.arrow_forward,
              bgColor: ThemeConst.colors.gray,
              reverseIconAlign: true,
            ),
          ],
        ));
  }
}
