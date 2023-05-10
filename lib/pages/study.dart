import 'dart:math';
import 'package:flutter/material.dart';
import 'package:my_language_app/components/elements/form.dart';
import 'package:my_language_app/components/elements/iconButton.dart';
import 'package:my_language_app/components/elements/progress.dart';
import 'package:my_language_app/components/elements/radio.dart';
import 'package:my_language_app/components/tools/pageScaffold.dart';
import 'package:my_language_app/config/db/tables/languages.dart';
import 'package:my_language_app/config/db/tables/words.dart';
import 'package:my_language_app/config/values.dart';
import 'package:my_language_app/constants/audio.const.dart';
import 'package:my_language_app/constants/displayedLanguage.const.dart';
import 'package:my_language_app/constants/studyType.const.dart';
import 'package:my_language_app/constants/theme.const.dart';
import 'package:my_language_app/lib/audio.lib.dart';
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
  late bool _stateIsActiveVoice = false;
  late int _stateTotalWords = 0;
  late int _stateStudiedWords = 0;
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

    setState(() {
      _stateWords = words;
      _stateTotalWords = words.length;
    });

    setLanguage();

    await setTTS();

    setCurrentWord();

    setTextDisplayedAndAnswer();

    setState(() {
      _statePageIsLoading = false;
    });
  }

  setTextDisplayedAndAnswer() {
    int displayedLanguage = _stateLanguage[DBTableLanguages.columnDisplayedLanguage];

    String columnDisplayedText = DBTableWords.columnTextNative;
    String columnAnswerText = DBTableWords.columnTextTarget;

    if(displayedLanguage == DisplayedLanguageConst.target || displayedLanguage == DisplayedLanguageConst.onlyVoiceTarget){
      columnDisplayedText = DBTableWords.columnTextTarget;
      columnAnswerText = DBTableWords.columnTextNative;
    }else if(displayedLanguage == DisplayedLanguageConst.random){
      var random = Random();
      int randomNumber = random.nextInt(2);

      if(randomNumber == 1){
        columnDisplayedText = DBTableWords.columnTextTarget;
        columnAnswerText = DBTableWords.columnTextNative;
      }
    }

    setState(() {
      _stateTextDisplayed = _stateCurrentWord[columnDisplayedText].toString();
      _stateTextAnswer = _stateCurrentWord[columnAnswerText].toString();
      _stateIsActiveVoice = columnDisplayedText == DBTableWords.columnTextTarget;
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
    if(_stateLanguage[DBTableLanguages.columnIsAutoVoice] == 1 && _stateIsActiveVoice){
      onClickTTS();
    }
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
          _stateStudiedWords += 1;
        });
        AudioLib.play(AudioConst.positive);
        DialogLib.show(
            context,
            ComponentDialogOptions(
                title: "🤗 Correct! 🤗",
                content: "Congratulations your answer is correct! 🤗",
                icon: ComponentDialogIcon.success,
                onPressed: (isConfirm) async {
                  if(isConfirm){
                    if(_stateWords.isEmpty) {
                      AudioLib.play(AudioConst.positive_2);
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
      AudioLib.play(AudioConst.negative);
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
      setTextDisplayedAndAnswer();
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
      setTextDisplayedAndAnswer();
      _controllerText.text = "";
      DialogLib.hide(context);
    }
  }

  void onClickTTS() async {
    if (await Permission.speech.request() != PermissionStatus.granted) {
      return;
    }
    await (await VoicesLib.flutterTts).setSpeechRate(0.5);
    await (await VoicesLib.flutterTts).setVolume(1.0);
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

  Widget _componentAnswer() {
    return ComponentForm(
      formKey: _formKey,
      onSubmit: onClickCheck,
      submitButtonText: "Check",
      children: <Widget>[
        Text(_stateLanguage[DBTableLanguages.columnDisplayedLanguage] == DisplayedLanguageConst.native
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

  Widget _componentResult() {
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

  Widget _componentInfo() {
    Widget _componentVoice() {
      return _stateIsActiveVoice ? ComponentIconButton(
        onPressed: onClickTTS,
        icon: Icons.volume_up,
        color: ThemeConst.colors.info,
      ) : Container();
    }

    Widget _componentComment() {
      return ComponentIconButton(
        onPressed: onClickComment,
        icon: Icons.lightbulb,
        color: ThemeConst.colors.warning,
      );
    }


    return _stateCurrentWord[DBTableWords.columnComment].toString().isNotEmpty ?
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _componentVoice(),
        Padding(padding: EdgeInsets.symmetric(horizontal: ThemeConst.paddings.sm)),
        _componentComment(),
      ],
    ) : _componentVoice();
  }

  Widget _componentProgress() {
    return Column(
      children: [
        Text(
          "$_stateTotalWords / $_stateStudiedWords",
          style: TextStyle(fontSize: ThemeConst.fontSizes.md),
        ),
        Padding(padding: EdgeInsets.symmetric(vertical: ThemeConst.paddings.sm)),
        ComponentProgress(
            maxValue: _stateTotalWords.toDouble(),
            currentValue: _stateStudiedWords.toDouble()
        )
      ],
    );
  }

  Widget _componentNavbar() {
    return Row(
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
            _componentNavbar(),
            Padding(padding: EdgeInsets.symmetric(vertical: ThemeConst.paddings.sm)),
            _componentProgress(),
            Padding(padding: EdgeInsets.all(ThemeConst.paddings.xlg)),
            _stateLanguage[DBTableLanguages.columnDisplayedLanguage] != DisplayedLanguageConst.onlyVoiceTarget ? Text(_stateTextDisplayed,
              style: TextStyle(fontSize: ThemeConst.fontSizes.lg),
            ) : Container(),
            Padding(padding: EdgeInsets.all(ThemeConst.paddings.xsm)),
            Padding(padding: EdgeInsets.all(ThemeConst.paddings.sm)),
            _componentInfo(),
            Padding(padding: EdgeInsets.all(ThemeConst.paddings.md)),
            _stateIsStudied ? _componentResult() : _componentAnswer(),
          ],
        ));
  }
}
