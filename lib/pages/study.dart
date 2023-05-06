import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:my_language_app/components/elements/form.dart';
import 'package:my_language_app/components/elements/iconButton.dart';
import 'package:my_language_app/components/elements/radio.dart';
import 'package:my_language_app/components/tools/pageScaffold.dart';
import 'package:my_language_app/config/db/tables/languages.dart';
import 'package:my_language_app/config/db/tables/words.dart';
import 'package:my_language_app/config/values.dart';
import 'package:my_language_app/constants/studyType.const.dart';
import 'package:my_language_app/constants/theme.const.dart';
import 'package:my_language_app/lib/dialog.lib.dart';
import 'package:my_language_app/lib/route.lib.dart';
import 'package:my_language_app/lib/voices.lib.dart';
import 'package:my_language_app/models/components/elements/dialog/options.dart';
import 'package:my_language_app/models/dependencies/tts/voice.model.dart';
import 'package:my_language_app/models/services/language.model.dart';
import 'package:my_language_app/models/services/word.model.dart';
import 'package:my_language_app/myLib/variable/array.dart';
import 'package:my_language_app/services/language.service.dart';
import 'package:my_language_app/services/word.service.dart';
import 'package:permission_handler/permission_handler.dart';
import '../components/elements/button.dart';

class PageStudy extends StatefulWidget {
  late int studyType = 0;
  final BuildContext context;

  PageStudy({Key? key, required this.context}) : super(key: key) {
    var args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args != null && args[DBTableWords.columnStudyType] != null) {
      studyType =
          int.tryParse(args[DBTableWords.columnStudyType].toString()) ?? 0;
    }
  }

  @override
  State<StatefulWidget> createState() => _PageStudyState();
}

class _PageStudyState extends State<PageStudy> {
  late bool _stateIsStudied = false;
  late bool _stateIsTrue = false;
  late bool _stateIsLanguageDisplayedNative = false;
  late bool _statePageIsLoading = true;
  late List<Map<String, dynamic>> _stateVoices = [];
  int _stateSelectedStudyType = StudyTypeConst.Daily;
  late List<Map<String, dynamic>> _stateWords = [];
  late Map<String, dynamic> _stateCurrentWord = {};
  late Map<String, dynamic> _stateLanguage = {};
  final _controllerText = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _pageInit();
  }

  _pageInit() async {
    if (widget.studyType == 0) {
      await RouteLib(context).change(target: "/study/plan");
      return;
    }

    var words = await WordService.get(WordGetParamModel(
        wordLanguageId: Values.getLanguageId,
        wordStudyType: widget.studyType,
        wordIsStudy: 0));

    var languages = await LanguageService.get(
        LanguageGetParamModel(languageId: Values.getLanguageId));

    var voices = await VoicesLib.getVoices();

    setState(() {
      _stateLanguage = languages[0];
      _stateWords = words;
      _stateVoices = voices;
    });

    setCurrentWord();

    await setTTS();

    setState(() {
      _statePageIsLoading = false;
    });
  }

  Future<void> setTTS() async {
    var voice = MyLibArray.findSingle(array: _stateVoices, key: TTSVoiceKeys.keyName, value: _stateLanguage[DBTableLanguages.columnTTSArtist]);
    if(voice != null){
      await (await VoicesLib.flutterTts).setVoice({"name": voice[TTSVoiceKeys.keyName], "locale": voice[TTSVoiceKeys.keyLocale], "gender": _stateLanguage[DBTableLanguages.columnTTSGender]});
      await (await VoicesLib.flutterTts).setSpeechRate(0.7);
      await (await VoicesLib.flutterTts).setVolume(1.0);
    }
  }

  void setCurrentWord() {
    var random = Random();
    int randomNumber = random.nextInt(_stateWords.length);
    setState(() {
      _stateCurrentWord = _stateWords[randomNumber];
      _stateSelectedStudyType = _stateCurrentWord[DBTableWords.columnStudyType];
      _stateIsTrue = false;
      _stateIsStudied = false;
    });
  }

  void onChangeStudyType(int? value) {
    if (value != null) {
      setState(() {
        _stateSelectedStudyType = value;
      });
    }
  }

  void onClickCheck() async {
    DialogLib.show(
        context,
        ComponentDialogOptions(
            content: "Checking...", icon: ComponentDialogIcon.loading));

    String answer = _stateCurrentWord[_stateIsLanguageDisplayedNative
            ? DBTableWords.columnTextNative
            : DBTableWords.columnTextTarget]
        .toString();

    setState(() {
      _stateIsStudied = true;
      _stateIsTrue =
          answer.toLowerCase() == _controllerText.text.toString().toLowerCase();
    });

    if (_stateIsTrue) {
      var updateWord = await WordService.update(WordUpdateParamModel(
          whereWordLanguageId: Values.getLanguageId,
          whereWordId: _stateCurrentWord[DBTableWords.columnId],
          wordIsStudy: 1));
      if (updateWord > 0) {
        setState(() {
          _stateWords = MyLibArray.findMulti(array: _stateWords, key: DBTableWords.columnId, value: _stateCurrentWord[DBTableWords.columnId], isLike: false);
        });
        //DialogLib.hide(context);
        DialogLib.show(
            context,
            ComponentDialogOptions(
                title: "🤗 Correct! 🤗",
                content: "Congratulations your answer is correct! 🤗",
                icon: ComponentDialogIcon.success));
      } else {
        //DialogLib.hide(context);
        DialogLib.show(
            context,
            ComponentDialogOptions(
                content: "It' couldn't be update!",
                icon: ComponentDialogIcon.error));
      }
    } else {
      //DialogLib.hide(context);
      DialogLib.show(
          context,
          ComponentDialogOptions(
              title: "😥 Wrong! 😥",
              content: "Unfortunately your answer is wrong! 😥",
              icon: ComponentDialogIcon.error));
    }
  }

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
    if (isUpdated == true) {
      setState(() {
        _stateIsLanguageDisplayedNative =
            Values.getLanguageDisplayedLanguage == 0;
      });
    }
  }

  void onClickNext() async {
    DialogLib.show(
        context,
        ComponentDialogOptions(
            content: "Loading...", icon: ComponentDialogIcon.loading));

    if(_stateCurrentWord[DBTableWords.columnStudyType] != _stateSelectedStudyType){
      await WordService.update(WordUpdateParamModel(
        whereWordLanguageId: Values.getLanguageId,
        whereWordId: _stateCurrentWord[DBTableWords.columnId],
        wordStudyType: _stateSelectedStudyType
      ));
    }

    setCurrentWord();

    _controllerText.text = "";
    DialogLib.hide(context);
  }

  void onClickTTS() async {
    if (await Permission.speech.request() != PermissionStatus.granted) {
      return;
    }
    await (await VoicesLib.flutterTts).speak(_stateCurrentWord[_stateIsLanguageDisplayedNative
        ? DBTableWords.columnTextNative
        : DBTableWords.columnTextTarget].toString());
  }

  void onClickComment() async {
    DialogLib.show(
        context,
        ComponentDialogOptions(
            title: "🧐 Comment 🧐",
            content: _stateCurrentWord[DBTableWords.columnComment]
        ));
  }

  String? onValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }

  Widget ComponentAnswer() {
    return ComponentForm(
      formKey: _formKey,
      onSubmit: onClickCheck,
      submitButtonText: "Check",
      children: <Widget>[
        Text(_stateIsLanguageDisplayedNative
            ? "Native"
            : Values.getLanguageName),
        TextFormField(
            controller: _controllerText,
            validator: onValidator,
            decoration: const InputDecoration(
              hintText: '...',
            ))
      ],
    );
  }

  Widget ComponentResult() {
    return Column(
      children: [
        Text(
          _controllerText.text,
          style: TextStyle(
            fontSize: ThemeConst.fontSizes.lg,
            color: _stateIsTrue ? ThemeConst.colors.success : ThemeConst.colors.danger,
            fontWeight: FontWeight.bold,
          ),
        ),
        _stateIsTrue ? Column(
          children: [
            Padding(padding: EdgeInsets.all(ThemeConst.paddings.md)),
            const Text("Word Study Type"),
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
        ) : Container(),
        Padding(padding: EdgeInsets.all(ThemeConst.paddings.md)),
        ComponentButton(
          text: "Next",
          onPressed: onClickNext,
          bgColor: ThemeConst.colors.success,
        )
      ],
    );
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
        body: _statePageIsLoading ? Container() : Column(
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
              _stateCurrentWord[_stateIsLanguageDisplayedNative
                  ? DBTableWords.columnTextNative
                  : DBTableWords.columnTextTarget],
              style: TextStyle(fontSize: ThemeConst.fontSizes.lg),
            ),
            Padding(padding: EdgeInsets.all(ThemeConst.paddings.sm)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ComponentIconButton(
                  onPressed: onClickTTS,
                  icon: Icons.volume_up,
                  color: ThemeConst.colors.info,
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: ThemeConst.paddings.sm)),
                ComponentIconButton(
                  onPressed: onClickComment,
                  icon: Icons.lightbulb,
                  color: ThemeConst.colors.warning,
                ),
              ],
            ),
            Padding(padding: EdgeInsets.all(ThemeConst.paddings.md)),
            _stateIsStudied ? ComponentResult() : ComponentAnswer(),
          ],
        ));
  }
}
