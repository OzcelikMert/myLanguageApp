import 'package:flutter/material.dart';
import 'package:my_language_app/components/elements/dropdown.dart';
import 'package:my_language_app/components/elements/form.dart';
import 'package:my_language_app/components/elements/iconButton.dart';
import 'package:my_language_app/components/elements/radio.dart';
import 'package:my_language_app/components/tools/pageScaffold.dart';
import 'package:my_language_app/config/db/tables/languages.dart';
import 'package:my_language_app/config/values.dart';
import 'package:my_language_app/constants/theme.const.dart';
import 'package:my_language_app/lib/dialog.lib.dart';
import 'package:my_language_app/lib/voices.lib.dart';
import 'package:my_language_app/models/components/elements/dialog/options.dart';
import 'package:my_language_app/models/dependencies/tts/voice.model.dart';
import 'package:my_language_app/models/services/language.model.dart';
import 'package:my_language_app/myLib/variable/array.dart';
import 'package:my_language_app/services/language.service.dart';
import 'package:permission_handler/permission_handler.dart';

class PageSettings extends StatefulWidget {
  const PageSettings({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageSettingsState();
}

class _PageSettingsState extends State<PageSettings> {
  late bool _statePageIsLoading = true;
  late List<Map<String, dynamic>> _stateTTSVoices = [];
  String _stateSelectedVoiceGenderRadio = "male";
  Map<String, dynamic>? _stateSelectedVoice;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _pageInit();
  }

  _pageInit() async {
    var voices = await VoicesLib.getVoices();
    var languages = await LanguageService.get(LanguageGetParamModel(languageId: Values.getLanguageId));
    var language = languages[0];
    var findVoice = MyLibArray.findSingle(array: voices, key: TTSVoiceKeys.keyName, value: language[DBTableLanguages.columnTTSArtist]);
    setState(() {
      _stateTTSVoices = voices;
      _stateSelectedVoice = findVoice ?? voices[0];
      _stateSelectedVoiceGenderRadio = language[DBTableLanguages.columnTTSGender];
      _statePageIsLoading = false;
    });
  }

  void onClickTTS() async {
    if (await Permission.speech.request() != PermissionStatus.granted) {
      return;
    }
    var voice = MyLibArray.findSingle(array: _stateTTSVoices, key: TTSVoiceKeys.keyName, value: _stateSelectedVoice![TTSVoiceKeys.keyName]);
    if(voice != null){
      await (await VoicesLib.flutterTts).setVoice({"name": voice[TTSVoiceKeys.keyName], "locale": voice[TTSVoiceKeys.keyLocale], "gender": _stateSelectedVoiceGenderRadio});
      await (await VoicesLib.flutterTts).setSpeechRate(0.7);
      await (await VoicesLib.flutterTts).setVolume(1.0);
      await (await VoicesLib.flutterTts).speak("Text to speech");
    }
  }

  void onChangeVoiceGenderRadio(String? value) {
    if (value != null) {
      setState(() {
        _stateSelectedVoiceGenderRadio = value;
      });
    }
  }

  void onClickSave() async {
    DialogLib.show(
        context,
        ComponentDialogOptions(
            title: "Are you sure?",
            content: "Are you sure want to save settings?",
            icon: ComponentDialogIcon.confirm,
            showCancelButton: true,
            onPressed: (bool isConfirm) async {
              if (isConfirm) {
                DialogLib.show(
                    context,
                    ComponentDialogOptions(
                        content: "Saving...",
                        icon: ComponentDialogIcon.loading));
                var result = await LanguageService.update(LanguageUpdateParamModel(
                    whereLanguageId: Values.getLanguageId,
                    languageTTSArtist: _stateSelectedVoice![TTSVoiceKeys.keyName],
                    languageTTSGender: _stateSelectedVoiceGenderRadio));
                if (result > 0) {
                  DialogLib.show(
                      context,
                      ComponentDialogOptions(
                          content:
                          "Settings has successfully saved!",
                          icon: ComponentDialogIcon.success));
                } else {
                  DialogLib.show(
                      context,
                      ComponentDialogOptions(
                          content: "It couldn't saved!",
                          icon: ComponentDialogIcon.error));
                }
                return false;
              }
            }));
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
      title: "Settings",
      withScroll: true,
      body: _statePageIsLoading ? Container() : Center(
        child: ComponentForm(
          formKey: _formKey,
          onSubmit: () => onClickSave(),
          submitButtonText: "Save",
          children: <Widget>[
            Center(
                child: Text("Text To Speech",
                    style: TextStyle(fontSize: ThemeConst.fontSizes.lg))),
            Padding(padding: EdgeInsets.all(ThemeConst.paddings.sm)),
            Center(
                child: ComponentIconButton(
                  onPressed: onClickTTS,
                  icon: Icons.volume_up,
                  color: ThemeConst.colors.info,
                )),
            Padding(padding: EdgeInsets.all(ThemeConst.paddings.md)),
            const Text("Language Code"),
            ComponentDropdown<Map<String, dynamic>>(
              selectedItem: _stateSelectedVoice,
              items: _stateTTSVoices,
              itemAsString: (Map<String, dynamic> u) =>
              u[TTSVoiceKeys.keyDisplayName],
              onChanged: (Map<String, dynamic>? data) => setState(() {
                _stateSelectedVoice = data;
              }),
              hintText: "ex: en-UK",
            ),
            Padding(padding: EdgeInsets.all(ThemeConst.paddings.md)),
            const Text("Gender"),
            Text(
                "Sometimes the selected language code may not support the selected gender. In these cases, you can try other language codes.",
              style: TextStyle(
                fontSize: ThemeConst.fontSizes.sm
              ),
            ),
            ComponentRadio<String>(
              title: 'Male',
              value: 'male',
              groupValue: _stateSelectedVoiceGenderRadio,
              onChanged: onChangeVoiceGenderRadio,
            ),
            ComponentRadio<String>(
              title: 'Female',
              value: 'female',
              groupValue: _stateSelectedVoiceGenderRadio,
              onChanged: onChangeVoiceGenderRadio,
            )
          ],
        ),
      ),
    );
  }
}