import 'package:flutter/material.dart';
import 'package:my_language_app/components/elements/dropdown.dart';
import 'package:my_language_app/components/elements/form.dart';
import 'package:my_language_app/components/elements/pageScaffold.dart';
import 'package:my_language_app/components/elements/radio.dart';
import 'package:my_language_app/lib/element.lib.dart';
import 'package:my_language_app/models/dependencies/tts/voice.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:my_language_app/myLib/variable/array.dart';

class PageStudySettings extends StatefulWidget {
  PageStudySettings({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageStudySettingsState();
}

class _PageStudySettingsState extends State<PageStudySettings> {
  String selectedVoiceGenderRadio = "male";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late List<TTSVoiceModel> _ttsVoices = [];

  FlutterTts flutterTts = FlutterTts();

  Future<List<TTSVoiceModel>> getVoices() async {
    List<TTSVoiceModel> voices = [];
    var rows = await flutterTts.getVoices;
    for(var row in rows) {
      var map = MyLibraryArray.convertLinkedHashMapToMap(row);
      print(map);
      voices.add(TTSVoiceModel(map["name"].toString(), map["locale"].toString()));
    }
    return voices;
  }

  @override
  void initState() {
    super.initState();
    _updateState();
  }

  void _updateState() async {
    var voices = await getVoices();
    setState(() {
      _ttsVoices = voices;
    });
  }

  void onClickSave() {
    if (_formKey.currentState!.validate()) {
      (ElementLib(context)).showMessageBox(
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
        selectedVoiceGenderRadio = value;
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
        title: "Settings",
        hideSidebar: true,
        withScroll: true,
        body: Column(
          children: <Widget>[
            const SizedBox(height: 50),
            ComponentForm(
              formKey: _formKey,
              onSubmit: onClickSave,
              submitButtonText: "Save",
              submitButtonIcon: Icons.save,
              children: <Widget>[
                const Center(
                    child:
                        Text("Text To Speech", style: TextStyle(fontSize: 25))),
                const SizedBox(height: 25),
                const Text("Language Code"),
                ComponentDropdown<TTSVoiceModel>(
                  items: _ttsVoices,
                  itemAsString: (TTSVoiceModel u) =>  "${u.name} - ${u.locale}",
                  onChanged: (TTSVoiceModel? data) => print({data?.name, data?.locale}),
                  hintText: "country in menu mode",
                ),
                const SizedBox(height: 16),
                ComponentRadio<String>(
                  title: 'Male',
                  value: 'male',
                  groupValue: selectedVoiceGenderRadio,
                  onChanged: onChangeVoiceGenderRadio,
                ),
                ComponentRadio<String>(
                  title: 'Female',
                  value: 'female',
                  groupValue: selectedVoiceGenderRadio,
                  onChanged: onChangeVoiceGenderRadio,
                )
              ],
            ),
          ],
        ));
  }
}
