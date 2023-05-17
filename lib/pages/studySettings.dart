import 'package:flutter/material.dart';
import 'package:my_language_app/components/elements/form.dart';
import 'package:my_language_app/components/elements/radio.dart';
import 'package:my_language_app/constants/displayedLanguage.const.dart';
import 'package:my_language_app/constants/theme.const.dart';
import 'package:my_language_app/lib/dialog.lib.dart';
import 'package:my_language_app/lib/provider.lib.dart';
import 'package:my_language_app/models/components/elements/dialog/options.dart';
import 'package:my_language_app/models/providers/language.provider.dart';
import 'package:my_language_app/models/providers/page.provider.dart';
import 'package:my_language_app/models/services/language.model.dart';
import 'package:my_language_app/services/language.service.dart';

class PageStudySettings extends StatefulWidget {
  final BuildContext context;

  PageStudySettings({Key? key, required this.context}) : super(key: key) {}

  @override
  State<StatefulWidget> createState() => _PageStudySettingsState();
}

class _PageStudySettingsState extends State<PageStudySettings> {
  int _stateSelectedDisplayedLanguage = 1;
  int _stateSelectedIsAutoVoice = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _pageInit();
    });
  }

  _pageInit() async {
    final pageProviderModel =
   ProviderLib.get<PageProviderModel>(context);
    pageProviderModel.setTitle("Study Settings");
    final languageProviderModel =
   ProviderLib.get<LanguageProviderModel>(context);

    setState(() {
      _stateSelectedDisplayedLanguage = languageProviderModel.selectedLanguage.languageDisplayedLanguage;
      _stateSelectedIsAutoVoice = languageProviderModel.selectedLanguage.languageIsAutoVoice;
    });

    pageProviderModel.setIsLoading(false);
  }

  void onClickSave() {
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
                final pageProviderModel =
               ProviderLib.get<PageProviderModel>(context);

                await DialogLib.show(
                    context,
                    ComponentDialogOptions(
                        content: "Saving...",
                        icon: ComponentDialogIcon.loading));
                var updateLanguage = await LanguageService.update(LanguageUpdateParamModel(
                    whereLanguageId: languageProviderModel.selectedLanguage.languageId,
                    languageDisplayedLanguage: _stateSelectedDisplayedLanguage,
                    languageIsAutoVoice: _stateSelectedIsAutoVoice
                ), context);
                if (updateLanguage > 0) {
                  pageProviderModel.setLeadingArgs(true);
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

  void onChangeIsAutoVoice(int? value) {
    if (value != null) {
      setState(() {
        _stateSelectedIsAutoVoice = value;
      });
    }
  }

  void onChangeDisplayedLanguage(int? value) {
    if (value != null) {
      setState(() {
        _stateSelectedDisplayedLanguage = value;
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
    final pageProviderModel =
   ProviderLib.get<PageProviderModel>(context, listen: true);
    final languageProviderModel =
   ProviderLib.get<LanguageProviderModel>(context, listen: true);

    return pageProviderModel.isLoading ? Container() : Column(
      children: <Widget>[
        ComponentForm(
          formKey: _formKey,
          onSubmit: onClickSave,
          submitButtonText: "Save",
          children: <Widget>[
            const Text("Displayed Language"),
            ComponentRadio<int>(
              title: languageProviderModel.selectedLanguage.languageName,
              value: DisplayedLanguageConst.target,
              groupValue: _stateSelectedDisplayedLanguage,
              onChanged: onChangeDisplayedLanguage,
            ),
            ComponentRadio<int>(
              title: 'Native',
              value: DisplayedLanguageConst.native,
              groupValue: _stateSelectedDisplayedLanguage,
              onChanged: onChangeDisplayedLanguage,
            ),
            ComponentRadio<int>(
              title: 'Random',
              value: DisplayedLanguageConst.random,
              groupValue: _stateSelectedDisplayedLanguage,
              onChanged: onChangeDisplayedLanguage,
            ),
            ComponentRadio<int>(
              title: 'Only Voice (${languageProviderModel.selectedLanguage.languageName})',
              value: DisplayedLanguageConst.onlyVoiceTarget,
              groupValue: _stateSelectedDisplayedLanguage,
              onChanged: onChangeDisplayedLanguage,
            ),
            Padding(padding: EdgeInsets.all(ThemeConst.paddings.md)),
            const Text("Auto Voice"),
            ComponentRadio<int>(
              title: "Yes",
              value: 1,
              groupValue: _stateSelectedIsAutoVoice,
              onChanged: onChangeIsAutoVoice,
            ),
            ComponentRadio<int>(
              title: 'No',
              value: 0,
              groupValue: _stateSelectedIsAutoVoice,
              onChanged: onChangeIsAutoVoice,
            )
          ],
        ),
      ],
    );
  }
}
