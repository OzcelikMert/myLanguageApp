import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_language_app/components/elements/dataTable/index.dart';
import 'package:my_language_app/components/elements/iconButton.dart';
import 'package:my_language_app/config/db/tables/words.dart';
import 'package:my_language_app/constants/page.const.dart';
import 'package:my_language_app/constants/studyType.const.dart';
import 'package:my_language_app/constants/theme.const.dart';
import 'package:my_language_app/lib/dialog.lib.dart';
import 'package:my_language_app/lib/provider.lib.dart';
import 'package:my_language_app/lib/route.lib.dart';
import 'package:my_language_app/lib/voices.lib.dart';
import 'package:my_language_app/models/components/elements/dataTable/dataCell.model.dart';
import 'package:my_language_app/models/components/elements/dataTable/dataColumn.model.dart';
import 'package:my_language_app/models/components/elements/dialog/options.model.dart';
import 'package:my_language_app/models/providers/language.provider.model.dart';
import 'package:my_language_app/models/providers/page.provider.model.dart';
import 'package:my_language_app/models/services/word.model.dart';
import 'package:my_language_app/myLib/variable/array.dart';
import 'package:my_language_app/services/word.service.dart';
import 'package:permission_handler/permission_handler.dart';

import '../components/elements/button.dart';

class PageWordList extends StatefulWidget {
  final BuildContext context;

  const PageWordList({Key? key, required this.context}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageWordListState();
}

class _PageWordListState extends State<PageWordList> {
  late List<WordGetResultModel> _stateWords = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _pageInit();
    });
  }

  _pageInit() async {
    final pageProviderModel = ProviderLib.get<PageProviderModel>(context);
    pageProviderModel.setTitle("List of Words");
    final languageProviderModel =
        ProviderLib.get<LanguageProviderModel>(context);

    await VoicesLib.setVoiceSaved(context);

    var words = await WordService.get(WordGetParamModel(
        wordLanguageId:
            languageProviderModel.selectedLanguage.languageId));

    setState(() {
      _stateWords = MyLibArray.sort(
          array: words,
          key: DBTableWords.columnCreatedAt,
          sortType: SortType.desc);
    });

    pageProviderModel.setIsLoading(false);
  }

  void onClickTTS(String text) async {
    if (await Permission.speech.request() != PermissionStatus.granted) {
      return;
    }
    await (await VoicesLib.flutterTts).speak(text);
  }

  void onClickEdit(WordGetResultModel row) async {
    var isUpdated = await RouteLib.change(
        context: context,
        target: PageConst.routeNames.wordEdit,
        arguments: {DBTableWords.columnId: row.wordId},
        safeHistory: true);
    if (isUpdated == true) {
      await DialogLib.show(
          context,
          ComponentDialogOptions(
              content: "Loading...", icon: ComponentDialogIcon.loading));
      await _pageInit();
      DialogLib.hide(context);
    }
  }

  void onClickDelete(WordGetResultModel row) {
    DialogLib.show(
        context,
        ComponentDialogOptions(
            title: "Are you sure?",
            content:
                "Are you sure want to delete '${row.wordTextNative}'?",
            icon: ComponentDialogIcon.confirm,
            showCancelButton: true,
            onPressed: (bool isConfirm) async {
              if (isConfirm) {
                await DialogLib.show(
                    context,
                    ComponentDialogOptions(
                        content: "Deleting...",
                        icon: ComponentDialogIcon.loading));
                var result = await WordService.delete(
                    WordDeleteParamModel(wordId: row.wordId));
                if (result > 0) {
                  setState(() {
                    _stateWords = MyLibArray.findMulti(array: _stateWords, key: DBTableWords.columnId, value: row.wordId, isLike: false);
                  });
                  DialogLib.show(
                      context,
                      ComponentDialogOptions(
                          content:
                              "'${row.wordTextNative}' has successfully deleted!",
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
    final languageProviderModel =
        ProviderLib.get<LanguageProviderModel>(context, listen: true);

    return pageProviderModel.isLoading
        ? Container()
        : ComponentDataTable<WordGetResultModel>(
            data: _stateWords,
            selectedColor: ThemeConst.colors.info,
            isSearchable: true,
            searchableKeys: [
              DBTableWords.columnTextTarget,
              DBTableWords.columnTextNative
            ],
            columns: [
              ComponentDataColumnModule(
                title: "",
              ),
              ComponentDataColumnModule(
                title:
                    "Target (${languageProviderModel.selectedLanguage.languageName})",
                sortKeyName: DBTableWords.columnTextTarget,
                sortable: true,
              ),
              const ComponentDataColumnModule(
                title: "Native",
                sortKeyName: DBTableWords.columnTextNative,
                sortable: true,
              ),
              const ComponentDataColumnModule(
                title: "Create Date",
                sortKeyName: DBTableWords.columnCreatedAt,
                sortable: true,
              ),
              const ComponentDataColumnModule(
                title: "Study Type",
                sortKeyName: DBTableWords.columnStudyType,
                sortable: true,
              ),
              const ComponentDataColumnModule(
                title: "Is Study",
                sortKeyName: DBTableWords.columnIsStudy,
                sortable: true,
              ),
              ComponentDataColumnModule(
                title: "",
              ),
              ComponentDataColumnModule(
                title: "",
              ),
            ],
            cells: [
              ComponentDataCellModule(
                child: (row) => ComponentIconButton(
                    onPressed: () => onClickTTS(
                        row.wordTextTarget),
                    color: ThemeConst.colors.primary,
                    icon: Icons.volume_up
                ),
              ),
              ComponentDataCellModule(
                child: (row) =>
                    Text(row.wordTextTarget),
              ),
              ComponentDataCellModule(
                child: (row) =>
                    Text(row.wordTextNative),
              ),
              ComponentDataCellModule(
                child: (row) => Text(DateFormat.yMd().add_Hm().format(
                    DateTime.parse(row.wordCreatedAt)
                        .toLocal())),
              ),
              ComponentDataCellModule(
                child: (row) => Text(StudyTypeConst.getTypeName(row.wordStudyType)),
              ),
              ComponentDataCellModule(
                child: (row) =>
                    Text(row.wordIsStudy == 1 ? "Yes" : "No"),
              ),
              ComponentDataCellModule(
                child: (row) => ComponentIconButton(
                  onPressed: () => onClickDelete(row),
                  icon: Icons.delete_forever,
                  color: ThemeConst.colors.danger,
                ),
              ),
              ComponentDataCellModule(
                child: (row) => ComponentIconButton(
                  onPressed: () => onClickEdit(row),
                  color: ThemeConst.colors.warning,
                  icon: Icons.edit,
                ),
              )
            ],
          );
  }
}
