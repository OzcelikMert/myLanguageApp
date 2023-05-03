import 'package:flutter/material.dart';
import 'package:my_language_app/components/elements/dropdown.dart';
import 'package:my_language_app/components/elements/form.dart';
import 'package:my_language_app/components/elements/radio.dart';
import 'package:my_language_app/components/tools/pageScaffold.dart';
import 'package:my_language_app/lib/dialog.lib.dart';
import 'package:my_language_app/lib/voices.lib.dart';
import 'package:my_language_app/models/dependencies/tts/voice.model.dart';
import 'package:my_language_app/models/services/language.model.dart';
import 'package:my_language_app/services/language.service.dart';

class PageLanguageAdd extends StatefulWidget {
  const PageLanguageAdd({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageLanguageAddState();
}

class _PageLanguageAddState extends State<PageLanguageAdd> {
  late bool _statePageIsLoading = true;
  late List<Map<String, dynamic>> _stateTTSVoices = [];
  String _stateSelectedVoiceGenderRadio = "male";
  Map<String, dynamic>? _stateSelectedVoice;
  final _controllerName = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late bool _isAdded = false;

  @override
  void initState() {
    super.initState();
    _pageInit();
  }

  _pageInit() async {
    var voices = await VoicesLib.getVoices();

    setState(() {
      _stateTTSVoices = voices;
      _stateSelectedVoice = voices[0];
      _statePageIsLoading = false;
    });
  }

  void onChangeVoiceGenderRadio(String? value) {
    if (value != null) {
      setState(() {
        _stateSelectedVoiceGenderRadio = value;
      });
    }
  }

  void onClickAdd() async {
    DialogLib(context).showMessage(
        title: "Are you sure?",
        content:
            "Are you sure want to add '${_controllerName.text}' as a language ?",
        onPressedOkay: () async {
          var loaderDialog = DialogLib(context);
          loaderDialog.showLoader();
          var result = await LanguageService.add(LanguageAddParamModel(
              languageName: _controllerName.text,
              languageTTSArtist: _stateSelectedVoice![TTSVoiceKeys.keyName],
              languageTTSGender: _stateSelectedVoiceGenderRadio));
          if (result > 0) {
            setState(() {
              _isAdded = true;
            });
            // DialogLib(context).showSuccess(
            //    content: "'${_controllerName.text}' successfully added!");
            _controllerName.text = "";
          } else {
            // DialogLib(context).showError(content: "It couldn't add!");
          }
          loaderDialog.hide();
        });
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
      leadingArgs: _isAdded,
      isLoading: _statePageIsLoading,
      title: "Add New",
      withScroll: true,
      hideSidebar: true,
      body: Center(
        child: ComponentForm(
          formKey: _formKey,
          onSubmit: () => onClickAdd(),
          submitButtonText: "Add",
          children: <Widget>[
            const Text("Language Name"),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Ex: English (UK)',
              ),
              validator: onValidator,
              controller: _controllerName,
            ),
            const Padding(padding: EdgeInsets.all(16)),
            Center(
                child: Text("Text To Speech", style: TextStyle(fontSize: 20))),
            const Padding(padding: EdgeInsets.all(16)),
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
      ),
    );
  }
}
