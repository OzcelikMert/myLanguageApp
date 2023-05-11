import 'package:flutter/material.dart';
import 'package:my_language_app/components/elements/dropdown.dart';
import 'package:my_language_app/components/elements/form.dart';
import 'package:my_language_app/components/elements/radio.dart';
import 'package:my_language_app/constants/theme.const.dart';
import 'package:my_language_app/lib/dialog.lib.dart';
import 'package:my_language_app/lib/provider.lib.dart';
import 'package:my_language_app/lib/voices.lib.dart';
import 'package:my_language_app/models/components/elements/dialog/options.dart';
import 'package:my_language_app/models/dependencies/tts/voice.model.dart';
import 'package:my_language_app/models/providers/page.provider.dart';
import 'package:my_language_app/models/services/language.model.dart';
import 'package:my_language_app/services/language.service.dart';

class PageLanguageAdd extends StatefulWidget {
  final BuildContext context;

  const PageLanguageAdd({Key? key, required this.context}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageLanguageAddState();
}

class _PageLanguageAddState extends State<PageLanguageAdd> {
  late List<Map<String, dynamic>> _stateTTSVoices = [];
  String _stateSelectedVoiceGenderRadio = "male";
  Map<String, dynamic>? _stateSelectedVoice;
  final _controllerName = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _pageInit();
    });
  }

  _pageInit() async {
    final pageProviderModel = ProviderLib.get<PageProviderModel>(context);
    pageProviderModel.setTitle("Add New Language");

    var voices = await VoicesLib.getVoices(await VoicesLib.getFlutterTts());

    setState(() {
      _stateTTSVoices = voices;
      _stateSelectedVoice = voices[0];
    });

    pageProviderModel.setIsLoading(false);
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
                    languageName: _controllerName.text.trim(),
                    languageTTSArtist:
                        _stateSelectedVoice![TTSVoiceKeys.keyName],
                    languageTTSGender: _stateSelectedVoiceGenderRadio));
                if (result > 0) {
                  final pageProviderModel = ProviderLib.get<PageProviderModel>(
                      context,
                      listen: false);
                  pageProviderModel.setLeadingArgs(true);
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
    final pageProviderModel =
        ProviderLib.get<PageProviderModel>(context, listen: true);

    return pageProviderModel.isLoading
        ? Container()
        : Center(
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
          ));
  }
}
