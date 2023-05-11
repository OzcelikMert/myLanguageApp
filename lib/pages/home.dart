import 'package:flutter/material.dart';
import 'package:my_language_app/components/elements/dataTable/index.dart';
import 'package:my_language_app/config/db/tables/languages.dart';
import 'package:my_language_app/constants/page.const.dart';
import 'package:my_language_app/constants/theme.const.dart';
import 'package:my_language_app/lib/dialog.lib.dart';
import 'package:my_language_app/lib/provider.lib.dart';
import 'package:my_language_app/lib/route.lib.dart';
import 'package:my_language_app/lib/voices.lib.dart';
import 'package:my_language_app/models/components/elements/dataTable/dataCell.dart';
import 'package:my_language_app/models/components/elements/dataTable/dataColumn.dart';
import 'package:my_language_app/models/components/elements/dialog/options.dart';
import 'package:my_language_app/models/dependencies/tts/voice.model.dart';
import 'package:my_language_app/models/providers/language.provider.dart';
import 'package:my_language_app/models/providers/page.provider.dart';
import 'package:my_language_app/models/providers/tts.provider.dart';
import 'package:my_language_app/models/services/language.model.dart';
import 'package:my_language_app/models/services/word.model.dart';
import 'package:my_language_app/myLib/variable/array.dart';
import 'package:my_language_app/services/language.service.dart';
import 'package:my_language_app/services/word.service.dart';

import '../components/elements/button.dart';

class PageHome extends StatefulWidget {
  final BuildContext context;

  const PageHome({Key? key, required this.context}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  late List<Map<String, dynamic>> _stateLanguages = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _pageInit();
    });
  }

  _pageInit() async {
    final pageProviderModel = ProviderLib.get<PageProviderModel>(context);
    pageProviderModel.setTitle("Select Language");

    final ttsProviderModel = ProviderLib.get<TTSProviderModel>(context);
    ttsProviderModel.setFlutterTts(await VoicesLib.getFlutterTts());
    if(ttsProviderModel.voices.isEmpty){
      ttsProviderModel.setVoices(await VoicesLib.getVoices(ttsProviderModel.flutterTts));
    }

    var languages = await LanguageService.get(LanguageGetParamModel());

    var findLanguage = MyLibArray.findSingle(array: languages, key: DBTableLanguages.columnIsSelected, value: 1);
    if (findLanguage != null) {
      onClickSelect(findLanguage);
      return;
    }

    setState(() {
      _stateLanguages = languages;
    });

    pageProviderModel.setIsLoading(false);
  }

  void onClickAdd() async {
    var isAdded = await RouteLib.change(context: context, target: PageConst.routeNames.languageAdd, safeHistory: true);
    if (isAdded == true) {
      await DialogLib.show(
          context,
          ComponentDialogOptions(icon: ComponentDialogIcon.loading));
      await _pageInit();
      DialogLib.hide(context);
    }
  }

  void onClickSelect(Map<String, dynamic> row) async {
    final pageProviderModel =
   ProviderLib.get<PageProviderModel>(context);
    final languageProviderModel =
   ProviderLib.get<LanguageProviderModel>(context);

    int updateWord = 1;

    if(!pageProviderModel.isLoading){
      await DialogLib.show(context, ComponentDialogOptions(icon: ComponentDialogIcon.loading));
      updateWord = await LanguageService.update(LanguageUpdateParamModel(
          whereLanguageId: row[DBTableLanguages.columnId], languageIsSelected: 1));
    }

    if (updateWord > 0) {
      languageProviderModel.setSelectedLanguage(row);

      final ttsProviderModel =
     ProviderLib.get<TTSProviderModel>(context);

      var flutterTts = await VoicesLib.getFlutterTts();
      var voice = MyLibArray.findSingle(
          array: ttsProviderModel.voices,
          key: TTSVoiceKeys.keyName,
          value: languageProviderModel.selectedLanguage[DBTableLanguages.columnTTSArtist]);
      if (voice != null) {
        await flutterTts.setVoice({
          "name": voice[TTSVoiceKeys.keyName],
          "locale": voice[TTSVoiceKeys.keyLocale],
          "gender": languageProviderModel.selectedLanguage[DBTableLanguages.columnTTSGender]
        });
        await flutterTts.setSpeechRate(0.5);
        await flutterTts.setVolume(1.0);
        ttsProviderModel.setFlutterTts(flutterTts);
      }
      await RouteLib.change(context: context, target: '/study/plan');
    }
  }

  void onClickDelete(Map<String, dynamic> row) async {
    DialogLib.show(
        context,
        ComponentDialogOptions(
            title: "Are you sure?",
            content:
                "Are you sure want to delete '${row[DBTableLanguages.columnName]}'?",
            icon: ComponentDialogIcon.confirm,
            showCancelButton: true,
            onPressed: (bool isConfirm) async {
              if (isConfirm) {
                await DialogLib.show(
                    context,
                    ComponentDialogOptions(
                        content: "Deleting...",
                        icon: ComponentDialogIcon.loading));
                var result = await LanguageService.delete(
                    LanguageDeleteParamModel(
                        languageId: row[DBTableLanguages.columnId]));
                if (result > 0) {
                  await WordService.delete(WordDeleteParamModel(
                      wordLanguageId: row[DBTableLanguages.columnId]));
                  setState(() {
                    _stateLanguages = _stateLanguages
                        .where((element) =>
                            element[DBTableLanguages.columnId] !=
                            row[DBTableLanguages.columnId])
                        .toList();
                  });
                  DialogLib.show(
                      context,
                      ComponentDialogOptions(
                          content:
                              "Success! You've deleted '${row[DBTableLanguages.columnName]}'",
                          icon: ComponentDialogIcon.success));
                } else {
                  DialogLib.show(
                      context,
                      ComponentDialogOptions(
                          content: "It couldn't delete!",
                          icon: ComponentDialogIcon.error));
                }
                return false;
              }
            }));
  }

  @override
  Widget build(BuildContext context) {
    final pageProviderModel =
   ProviderLib.get<PageProviderModel>(context, listen: true);

    return pageProviderModel.isLoading ? Container() : Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ComponentButton(
            onPressed: () => onClickAdd(),
            text: "Add New",
          ),
          Padding(padding: EdgeInsets.all(ThemeConst.paddings.md)),
          ComponentDataTable<Map<String, dynamic>>(
            data: _stateLanguages,
            columns: const [
              ComponentDataColumnModule(
                title: "Name",
                sortKeyName: DBTableLanguages.columnName,
                sortable: true,
              ),
              ComponentDataColumnModule(
                title: "Select",
              ),
              ComponentDataColumnModule(
                title: "Delete",
              )
            ],
            cells: [
              ComponentDataCellModule(
                child: (row) =>
                    Text(row[DBTableLanguages.columnName].toString()),
              ),
              ComponentDataCellModule(
                child: (row) => ComponentButton(
                  text: "Select",
                  onPressed: () => onClickSelect(row),
                  icon: Icons.check,
                  buttonSize: ComponentButtonSize.sm,
                ),
              ),
              ComponentDataCellModule(
                child: (row) => ComponentButton(
                  text: "Delete",
                  bgColor: ThemeConst.colors.danger,
                  onPressed: () => onClickDelete(row),
                  icon: Icons.delete_forever,
                  buttonSize: ComponentButtonSize.sm,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
