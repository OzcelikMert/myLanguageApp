import 'dart:math';
import 'package:flutter/material.dart';
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
  late bool _statePageIsLoading = true;
  int _stateSelectedStudyType = StudyTypeConst.Daily;
  late List<Map<String, dynamic>> _stateWords = [];
  late Map<String, dynamic> _stateCurrentWord = {};
  late Map<String, dynamic> _stateLanguage = {};
  late String _stateTextDisplayed = "";
  late String _stateTextAnswer = "";
  late String _stateVoiceText = "";
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

    setLanguage();

    setState(() {
      _stateWords = words;
    });

    setCurrentWord();

    await setTTS();

    setTextDisplayed();
    setTextAnswer();

    setState(() {
      _statePageIsLoading = false;
    });
  }

  setTextDisplayed() {
    setState(() {
      _stateTextDisplayed = _stateCurrentWord[_stateLanguage[DBTableLanguages.columnDisplayedLanguage] == 0
          ? DBTableWords.columnTextNative
          : DBTableWords.columnTextTarget].toString();
    });
  }

  setTextAnswer() {
    setState(() {
      _stateTextAnswer = _stateCurrentWord[_stateLanguage[DBTableLanguages.columnDisplayedLanguage] == 0
          ? DBTableWords.columnTextTarget
          : DBTableWords.columnTextNative].toString();
    });
  }

  Future<void> setLanguage() async {
    var languages = await LanguageService.get(
        LanguageGetParamModel(languageId: Values.getLanguageId));

    setState(() {
      _stateLanguage = languages[0];
    });

  }

  Future<void> setTTS() async {
    var voices = await VoicesLib.getVoices();
    var voice = MyLibArray.findSingle(array: voices, key: TTSVoiceKeys.keyName, value: _stateLanguage[DBTableLanguages.columnTTSArtist]);
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
    await DialogLib.show(
        context,
        ComponentDialogOptions(
            content: "Checking...", icon: ComponentDialogIcon.loading));

    setState(() {
      _stateIsStudied = true;
      _stateIsTrue = _stateTextAnswer.toLowerCase() == _controllerText.text.toString().toLowerCase().trim();
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
        DialogLib.show(
            context,
            ComponentDialogOptions(
                title: "🤗 Correct! 🤗",
                content: "Congratulations your answer is correct! 🤗",
                icon: ComponentDialogIcon.success,
                onPressed: (isConfirm) async {
                  if(isConfirm){
                    if(_stateWords.isEmpty) {
                      DialogLib.show(
                          context,
                          ComponentDialogOptions(
                              title: "🤩 Finally Over! 🤩",
                              content: "Congratulations, you have mastered all the words. 🤩",
                              icon: ComponentDialogIcon.success
                          ));
                      return false;
                    }
                  }
                },
            )
        );
      } else {
        DialogLib.show(
            context,
            ComponentDialogOptions(
                content: "It' couldn't be update!",
                icon: ComponentDialogIcon.error));
      }
    } else {
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
            icon: ComponentDialogIcon.confirm,
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
      await DialogLib.show(
          context,
          ComponentDialogOptions(
              content: "Loading...", icon: ComponentDialogIcon.loading));
      await setLanguage();
      setTextDisplayed();
      setTextAnswer();
      DialogLib.hide(context);
    }
  }

  void onClickNext() async {
    await DialogLib.show(
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

    if(_stateWords.isEmpty) {
      DialogLib.show(
          context,
          ComponentDialogOptions(
              content:
              "Word's study type has successfully saved!",
              icon: ComponentDialogIcon.success));
    }else {
      setCurrentWord();
      setTextDisplayed();
      setTextAnswer();
      _controllerText.text = "";
      DialogLib.hide(context);
    }
  }

  void onClickTTS() async {
    if (await Permission.speech.request() != PermissionStatus.granted) {
      return;
    }
    await (await VoicesLib.flutterTts).speak(_stateTextDisplayed);
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
        Text(_stateLanguage[DBTableLanguages.columnDisplayedLanguage] == 0
            ? Values.getLanguageName
            : "Native"),
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
          "Answer: ${_controllerText.text}",
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
        ) : Column(
          children: [
            Padding(padding: EdgeInsets.all(ThemeConst.paddings.md)),
            Text(
              "Correct Word: ${_stateTextAnswer}",
              style: TextStyle(
                fontSize: ThemeConst.fontSizes.lg,
                color: ThemeConst.colors.info,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
        Padding(padding: EdgeInsets.all(ThemeConst.paddings.md)),
        ComponentButton(
          text: _stateWords.isNotEmpty ? "Next" : "Save",
          onPressed: onClickNext,
          bgColor: ThemeConst.colors.success,
        )
      ],
    );
  }

  Widget ComponentInfo() {
    return _stateCurrentWord[DBTableWords.columnComment].toString().isNotEmpty ?
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ComponentIconButton(
          onPressed: onClickTTS,
          icon: Icons.volume_up,
          color: ThemeConst.colors.info,
        ),
        Padding(padding: EdgeInsets.symmetric(horizontal: ThemeConst.paddings.sm)),
        Container(
          child: ComponentIconButton(
            onPressed: onClickComment,
            icon: Icons.lightbulb,
            color: ThemeConst.colors.warning,
          ),
        ),
      ],
    ) : ComponentIconButton(
      onPressed: onClickTTS,
      icon: Icons.volume_up,
      color: ThemeConst.colors.info,
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
            Padding(padding: EdgeInsets.symmetric(vertical: ThemeConst.paddings.md)),
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
            Text(_stateTextDisplayed,
              style: TextStyle(fontSize: ThemeConst.fontSizes.lg),
            ),
            Padding(padding: EdgeInsets.all(ThemeConst.paddings.xsm)),
            Text(_stateVoiceText,
              style: TextStyle(fontSize: ThemeConst.fontSizes.md),
            ),
            Padding(padding: EdgeInsets.all(ThemeConst.paddings.sm)),
            ComponentInfo(),
            Padding(padding: EdgeInsets.all(ThemeConst.paddings.md)),
            _stateIsStudied ? ComponentResult() : ComponentAnswer(),
          ],
        ));
  }
}
