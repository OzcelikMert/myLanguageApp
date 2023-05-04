import 'package:flutter/material.dart';
import 'package:my_language_app/components/elements/dropdown.dart';
import 'package:my_language_app/components/elements/form.dart';
import 'package:my_language_app/components/tools/pageScaffold.dart';
import 'package:my_language_app/components/elements/radio.dart';
import 'package:my_language_app/config/db/tables/languages.dart';
import 'package:my_language_app/config/values.dart';
import 'package:my_language_app/constants/theme.const.dart';
import 'package:my_language_app/lib/dialog.lib.dart';
import 'package:my_language_app/lib/voices.lib.dart';
import 'package:my_language_app/models/dependencies/tts/voice.model.dart';
import 'package:my_language_app/models/services/language.model.dart';
import 'package:my_language_app/myLib/variable/array.dart';
import 'package:my_language_app/services/language.service.dart';

class PageSettings extends StatefulWidget {
  PageSettings({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageSettingsState();
}

class _PageSettingsState extends State<PageSettings> {
  late bool _statePageIsLoading = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late List<Map<String, dynamic>> _stateTTSVoices = [];
  String _stateSelectedVoiceGenderRadio = "male";
  Map<String, dynamic>? _stateSelectedVoice;
  late Map<String, dynamic> _stateLanguage = {};

  @override
  void initState() {
    super.initState();
    _pageInit();
  }

  void _pageInit() async {
    var languages = await LanguageService.get(
        LanguageGetParamModel(languageId: Values.getLanguageId));
    var voices = await VoicesLib.getVoices();

    var language = languages[0];
    var findVoice = MyLibArray.findSingle(array: voices, key: TTSVoiceKeys.keyName, value: language[DBTableLanguages.columnTTSArtist]);

    setState(() {
      _stateLanguage = language;
      _stateTTSVoices = voices;
      _stateSelectedVoice = findVoice ?? voices[0];
      _stateSelectedVoiceGenderRadio = language[DBTableLanguages.columnTTSGender];
      _statePageIsLoading = false;
    });
  }

  void onClickSave() {

  }

  void onChangeVoiceGenderRadio(String? value) {
    if (value != null) {
      setState(() {
        _stateSelectedVoiceGenderRadio = value;
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
        title: "Settings",
        withScroll: true,
        body: Column(
          children: <Widget>[
            ComponentForm(
              formKey: _formKey,
              onSubmit: onClickSave,
              submitButtonText: "Save",
              submitButtonIcon: Icons.save,
              children: <Widget>[
                Center(
                    child:
                        Text("Text To Speech", style: TextStyle(fontSize: ThemeConst.fontSizes.lg))),
                Padding(padding: EdgeInsets.all(ThemeConst.paddings.md)),
                const Text("Language Code"),
                ComponentDropdown<Map<String, dynamic>>(
                  selectedItem: _stateSelectedVoice,
                  items: _stateTTSVoices,
                  itemAsString: (Map<String, dynamic> u) => u[TTSVoiceKeys.keyDisplayName],
                  onChanged: (Map<String, dynamic>? data) => setState(() {
                    _stateSelectedVoice = data;
                  }),
                  hintText: "ex: en-UK",
                ),
                Padding(padding: EdgeInsets.all(ThemeConst.paddings.md)),
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
          ],
        ));
  }
}
