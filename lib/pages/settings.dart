import 'package:flutter/material.dart';
import 'package:my_language_app/components/elements/dropdown.dart';
import 'package:my_language_app/components/elements/form.dart';
import 'package:my_language_app/components/elements/iconButton.dart';
import 'package:my_language_app/components/elements/radio.dart';
import 'package:my_language_app/constants/theme.const.dart';
import 'package:my_language_app/lib/dialog.lib.dart';
import 'package:my_language_app/lib/provider.lib.dart';
import 'package:my_language_app/lib/voices.lib.dart';
import 'package:my_language_app/models/components/elements/dialog/options.model.dart';
import 'package:my_language_app/models/dependencies/tts/voice.model.dart';
import 'package:my_language_app/models/lib/voices.lib.model.dart';
import 'package:my_language_app/models/providers/language.provider.model.dart';
import 'package:my_language_app/models/providers/page.provider.model.dart';
import 'package:my_language_app/models/providers/tts.provider.model.dart';
import 'package:my_language_app/models/services/language.model.dart';
import 'package:my_language_app/myLib/variable/array.dart';
import 'package:my_language_app/services/language.service.dart';
import 'package:permission_handler/permission_handler.dart';

class PageSettings extends StatefulWidget {
  final BuildContext context;

  const PageSettings({Key? key, required this.context}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageSettingsState();
}

class _PageSettingsState extends State<PageSettings> {
  String _stateSelectedVoiceGenderRadio = "male";
  VoicesLibGetVoicesResultModel? _stateSelectedVoice;
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
    pageProviderModel.setTitle("Settings");

    final ttsProviderModel = ProviderLib.get<TTSProviderModel>(context);

    final languageProviderModel =
        ProviderLib.get<LanguageProviderModel>(context);

    var findVoice = MyLibArray.findSingle(
        array: ttsProviderModel.voices,
        key: TTSVoiceKeys.keyName,
        value: languageProviderModel
            .selectedLanguage.languageTTSArtist);
    setState(() {
      _stateSelectedVoice = findVoice ?? ttsProviderModel.voices[0];
      _stateSelectedVoiceGenderRadio = languageProviderModel
          .selectedLanguage.languageTTSGender;
    });

    pageProviderModel.setIsLoading(false);
  }

  void onClickTTS() async {
    if (await Permission.speech.request() != PermissionStatus.granted) {
      return;
    }
    await DialogLib.show(
        context, ComponentDialogOptions(icon: ComponentDialogIcon.loading));

    await VoicesLib.setVoiceSaved(context, params: VoicesLibSetVoiceParamModel(
      locale: _stateSelectedVoice?.locale ?? "",
      name: _stateSelectedVoice?.name ?? "",
      gender: _stateSelectedVoiceGenderRadio
    ));
    await (await VoicesLib.flutterTts).speak("Text to speech");

    DialogLib.hide(context);
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
                final languageProviderModel =
                    ProviderLib.get<LanguageProviderModel>(context);
                await DialogLib.show(
                    context,
                    ComponentDialogOptions(
                        content: "Saving...",
                        icon: ComponentDialogIcon.loading));
                var result = await LanguageService.update(
                    LanguageUpdateParamModel(
                        whereLanguageId: languageProviderModel
                            .selectedLanguage.languageId,
                        languageTTSArtist:
                            _stateSelectedVoice!.name,
                        languageTTSGender: _stateSelectedVoiceGenderRadio), context);
                if (result > 0) {
                  DialogLib.show(
                      context,
                      ComponentDialogOptions(
                          content: "Settings has successfully saved!",
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
    final pageProviderModel =
        ProviderLib.get<PageProviderModel>(context, listen: true);
    final ttsProviderModel =
        ProviderLib.get<TTSProviderModel>(context, listen: true);

    return pageProviderModel.isLoading
        ? Container()
        : Center(
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
                ComponentDropdown<VoicesLibGetVoicesResultModel>(
                  selectedItem: _stateSelectedVoice,
                  items: ttsProviderModel.voices,
                  itemAsString: (VoicesLibGetVoicesResultModel u) =>
                      u.displayName,
                  onChanged: (VoicesLibGetVoicesResultModel? data) => setState(() {
                    _stateSelectedVoice = data;
                  }),
                  hintText: "ex: en-UK",
                ),
                Padding(padding: EdgeInsets.all(ThemeConst.paddings.md)),
                const Text("Gender"),
                Text(
                  "Sometimes the selected language code may not support the selected gender. In these cases, you can try other language codes.",
                  style: TextStyle(fontSize: ThemeConst.fontSizes.sm),
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
          );
  }
}
