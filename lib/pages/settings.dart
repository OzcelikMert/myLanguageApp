import 'package:flutter/material.dart';
import 'package:my_language_app/components/elements/dropdown.dart';
import 'package:my_language_app/components/elements/form.dart';
import 'package:my_language_app/components/tools/pageScaffold.dart';
import 'package:my_language_app/components/elements/radio.dart';
import 'package:my_language_app/lib/dialog.lib.dart';
import 'package:my_language_app/models/dependencies/tts/voice.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:my_language_app/myLib/variable/array.dart';

class PageSettings extends StatefulWidget {
  PageSettings({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageSettingsState();
}

class _PageSettingsState extends State<PageSettings> {
  late bool _statePageIsLoading = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late List<TTSVoiceModel> _stateTTSVoices = [];
  String _stateSelectedVoiceGenderRadio = "male";
  TTSVoiceModel? _stateSelectedVoice;

  FlutterTts flutterTts = FlutterTts();

  Future<List<TTSVoiceModel>> getVoices() async {
    List<TTSVoiceModel> voices = [];
    var rows = await flutterTts.getVoices;
    for(var row in rows) {
      var map = MyLibraryArray.convertLinkedHashMapToMap(row);
      voices.add(TTSVoiceModel(map["name"].toString(), map["locale"].toString()));
    }
    return voices;
  }

  @override
  void initState() {
    super.initState();
    _pageInit();
  }

  void _pageInit() async {
    var voices = await getVoices();
    setState(() {
      _statePageIsLoading = false;
      _stateTTSVoices = voices;
      _stateSelectedVoice = voices[0];
    });
  }

  void onClickSave() {
    if (_formKey.currentState!.validate()) {
      (DialogLib(context)).showMessage(
          title: "Are you sure?",
          content: "You have selected 'daily'. Are you sure about this?",
          onPressedOkay: () {
            Navigator.pushNamed(context, '/study/daily');
          });
    }
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
            const Padding(padding: EdgeInsets.all(50)),
            ComponentForm(
              formKey: _formKey,
              onSubmit: onClickSave,
              submitButtonText: "Save",
              submitButtonIcon: Icons.save,
              children: <Widget>[
                const Center(
                    child:
                        Text("Text To Speech", style: TextStyle(fontSize: 25))),
                const Padding(padding: EdgeInsets.all(25)),
                const Text("Language Code"),
                ComponentDropdown<TTSVoiceModel>(
                  selectedItem: _stateSelectedVoice,
                  items: _stateTTSVoices,
                  itemAsString: (TTSVoiceModel u) =>  "${u.name} - ${u.locale}",
                  onChanged: (TTSVoiceModel? data) => setState(() {
                    _stateSelectedVoice = data;
                  }),
                  hintText: "ex: en-UK",
                ),
                const Padding(padding: EdgeInsets.all(16)),
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
