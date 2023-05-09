import 'package:flutter/material.dart';
import 'package:my_language_app/components/elements/form.dart';
import 'package:my_language_app/components/tools/pageScaffold.dart';
import 'package:my_language_app/components/elements/radio.dart';
import 'package:my_language_app/config/db/tables/languages.dart';
import 'package:my_language_app/config/values.dart';
import 'package:my_language_app/constants/theme.const.dart';
import 'package:my_language_app/lib/dialog.lib.dart';
import 'package:my_language_app/models/components/elements/dialog/options.dart';
import 'package:my_language_app/models/services/language.model.dart';
import 'package:my_language_app/services/language.service.dart';

class PageStudySettings extends StatefulWidget {
  final BuildContext context;

  PageStudySettings({Key? key, required this.context}) : super(key: key) {}

  @override
  State<StatefulWidget> createState() => _PageStudySettingsState();
}

class _PageStudySettingsState extends State<PageStudySettings> {
  late bool _stateIsUpdated = false;
  late bool _statePageIsLoading = true;
  int _stateSelectedDisplayedLanguage = 1;
  int _stateSelectedIsAutoVoice = 0;
  late Map<String, dynamic> _stateLanguage;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _pageInit();
  }

  _pageInit() async {
    var languages = await LanguageService.get(LanguageGetParamModel(
      languageId: Values.getLanguageId
    ));

    setState(() {
      _stateLanguage = languages[0];
      _stateSelectedDisplayedLanguage = _stateLanguage[DBTableLanguages.columnDisplayedLanguage];
      _stateSelectedIsAutoVoice = _stateLanguage[DBTableLanguages.columnIsAutoVoice];
      _statePageIsLoading = false;
    });
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
                await DialogLib.show(
                    context,
                    ComponentDialogOptions(
                        content: "Saving...",
                        icon: ComponentDialogIcon.loading));
                var updateLanguage = await LanguageService.update(LanguageUpdateParamModel(
                    whereLanguageId: Values.getLanguageId,
                    languageDisplayedLanguage: _stateSelectedDisplayedLanguage,
                    languageIsAutoVoice: _stateSelectedIsAutoVoice
                ));
                if (updateLanguage > 0) {
                  setState(() {
                    _stateIsUpdated = true;
                  });
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
    return ComponentPageScaffold(
        isLoading: _statePageIsLoading,
        title: "Study Settings",
        leadingArgs: _stateIsUpdated,
        hideSidebar: true,
        withScroll: true,
        body: _statePageIsLoading ? Container() : Column(
          children: <Widget>[
            ComponentForm(
              formKey: _formKey,
              onSubmit: onClickSave,
              submitButtonText: "Save",
              children: <Widget>[
                const Text("Displayed Language"),
                ComponentRadio<int>(
                  title: Values.getLanguageName,
                  value: 1,
                  groupValue: _stateSelectedDisplayedLanguage,
                  onChanged: onChangeDisplayedLanguage,
                ),
                ComponentRadio<int>(
                  title: 'Native',
                  value: 0,
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
        ));
  }
}
