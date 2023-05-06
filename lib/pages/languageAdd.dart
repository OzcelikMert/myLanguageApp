import 'package:flutter/material.dart';
import 'package:my_language_app/components/elements/dropdown.dart';
import 'package:my_language_app/components/elements/form.dart';
import 'package:my_language_app/components/elements/radio.dart';
import 'package:my_language_app/components/tools/pageScaffold.dart';
import 'package:my_language_app/constants/theme.const.dart';
import 'package:my_language_app/lib/dialog.lib.dart';
import 'package:my_language_app/lib/voices.lib.dart';
import 'package:my_language_app/models/components/elements/dialog/options.dart';
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
  late bool _stateIsAdded = false;

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
    DialogLib.show(
        context,
        ComponentDialogOptions(
            title: "Are you sure?",
            content:
                "Are you sure want to add '${_controllerName.text}' as a language ?",
            icon: ComponentDialogIcon.confirm,
            showCancelButton: true,
            onPressed: (bool isConfirm) async {
              if (isConfirm) {
                await DialogLib.show(
                    context,
                    ComponentDialogOptions(
                        content: "Adding...",
                        icon: ComponentDialogIcon.loading));
                var result = await LanguageService.add(LanguageAddParamModel(
                    languageName: _controllerName.text,
                    languageTTSArtist:
                        _stateSelectedVoice![TTSVoiceKeys.keyName],
                    languageTTSGender: _stateSelectedVoiceGenderRadio));
                if (result > 0) {
                  setState(() {
                    _stateIsAdded = true;
                  });
                  DialogLib.show(
                      context,
                      ComponentDialogOptions(
                          content:
                              "'${_controllerName.text}' has successfully added!",
                          icon: ComponentDialogIcon.success));
                  _controllerName.text = "";
                  _stateSelectedVoice = _stateTTSVoices[0];
                  _stateSelectedVoiceGenderRadio = "male";
                } else {
                  DialogLib.show(
                      context,
                      ComponentDialogOptions(
                          content: "It couldn't add!",
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
      leadingArgs: _stateIsAdded,
      isLoading: _statePageIsLoading,
      title: "Add New",
      withScroll: true,
      hideSidebar: true,
      body: _statePageIsLoading ? Container() : Center(
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
            Padding(padding: EdgeInsets.all(ThemeConst.paddings.md)),
            Center(
                child: Text("Text To Speech",
                    style: TextStyle(fontSize: ThemeConst.fontSizes.lg))),
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
