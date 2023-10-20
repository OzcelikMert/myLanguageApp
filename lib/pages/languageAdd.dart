import 'package:flutter/material.dart';
import 'package:my_language_app/components/elements/dropdown.dart';
import 'package:my_language_app/components/elements/form.dart';
import 'package:my_language_app/components/elements/radio.dart';
import 'package:my_language_app/constants/theme.const.dart';
import 'package:my_language_app/lib/dialog.lib.dart';
import 'package:my_language_app/lib/provider.lib.dart';
import 'package:my_language_app/models/components/elements/dialog/options.model.dart';
import 'package:my_language_app/models/lib/voices.lib.model.dart';
import 'package:my_language_app/models/providers/page.provider.model.dart';
import 'package:my_language_app/models/providers/tts.provider.model.dart';
import 'package:my_language_app/models/services/language.model.dart';
import 'package:my_language_app/services/language.service.dart';

class PageLanguageAdd extends StatefulWidget {
  final BuildContext context;

  const PageLanguageAdd({Key? key, required this.context}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageLanguageAddState();
}

class _PageLanguageAddState extends State<PageLanguageAdd> {
  VoicesLibGetVoicesResultModel? _stateSelectedVoice;
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

    final ttsProviderModel = ProviderLib.get<TTSProviderModel>(context);

    setState(() {
      _stateSelectedVoice = ttsProviderModel.voices[0];
    });

    pageProviderModel.setIsLoading(false);
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
                    languageTTSArtist: _stateSelectedVoice!.name));
                if (result > 0) {
                  final ttsProviderModel = ProviderLib.get<TTSProviderModel>(context);
                  final pageProviderModel = ProviderLib.get<PageProviderModel>(context);
                  pageProviderModel.setLeadingArgs(true);
                  DialogLib.show(
                      context,
                      ComponentDialogOptions(
                          content:
                              "'${_controllerName.text}' has successfully added!",
                          icon: ComponentDialogIcon.success));
                  _controllerName.text = "";
                  _stateSelectedVoice = ttsProviderModel.voices[0];
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
    final ttsProviderModel = ProviderLib.get<TTSProviderModel>(context, listen: true);

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
            ],
          ));
  }
}
