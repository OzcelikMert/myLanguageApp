import 'package:flutter/material.dart';
import 'package:my_language_app/components/elements/dataTable/index.dart';
import 'package:my_language_app/components/tools/pageScaffold.dart';
import 'package:my_language_app/config/db/tables/languages.dart';
import 'package:my_language_app/config/values.dart';
import 'package:my_language_app/constants/theme.const.dart';
import 'package:my_language_app/lib/dialog.lib.dart';
import 'package:my_language_app/lib/route.lib.dart';
import 'package:my_language_app/models/components/elements/dataTable/dataCell.dart';
import 'package:my_language_app/models/components/elements/dataTable/dataColumn.dart';
import 'package:my_language_app/models/components/elements/dialog/options.dart';
import 'package:my_language_app/models/services/language.model.dart';
import 'package:my_language_app/models/services/word.model.dart';
import 'package:my_language_app/myLib/variable/array.dart';
import 'package:my_language_app/services/language.service.dart';
import 'package:my_language_app/services/word.service.dart';

import '../components/elements/button.dart';

class PageHome extends StatefulWidget {
  const PageHome({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  late bool _statePageIsLoading = true;
  late List<Map<String, dynamic>> _stateLanguages = [];

  @override
  void initState() {
    super.initState();
    _pageInit();
  }

  _pageInit() async {
    var languages = await LanguageService.get(LanguageGetParamModel());

    if (languages.length > 0) {
      var findLanguage = MyLibArray.findSingle(
          array: languages, key: DBTableLanguages.columnIsSelected, value: 1);
      if (findLanguage != null) {
        Values.setLanguageId = findLanguage[DBTableLanguages.columnId];
        Values.setLanguageName = findLanguage[DBTableLanguages.columnName];
        await RouteLib(context).change(target: '/study/plan');
        return;
      }
    }

    setState(() {
      _stateLanguages = languages;
      _statePageIsLoading = false;
    });
  }

  void onClickAdd() async {
    var isAdded = await RouteLib(context)
        .change(target: '/language/add', safeHistory: true);
    if (isAdded) {
      DialogLib.show(
          context,
          ComponentDialogOptions(
              content: "Loading...",
              icon: ComponentDialogIcon.loading));
      await _pageInit();
      DialogLib.hide(context);
    }
  }

  void onClickSelect(Map<String, dynamic> row) async {
    DialogLib.show(context, ComponentDialogOptions(icon: ComponentDialogIcon.loading));
    var result = await LanguageService.update(LanguageUpdateParamModel(
        whereLanguageId: row[DBTableLanguages.columnId], languageIsSelected: 1));
    if (result > 0) {
      Values.setLanguageId = row[DBTableLanguages.columnId];
      Values.setLanguageName = row[DBTableLanguages.columnName];
      Values.setLanguageDisplayedLanguage = row[DBTableLanguages.columnDisplayedLanguage];
      await RouteLib(context).change(target: '/study/plan');
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
                DialogLib.show(
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
    return ComponentPageScaffold(
      isLoading: _statePageIsLoading,
      title: "Select Language",
      hideSidebar: true,
      withScroll: true,
      hideBackButton: true,
      body: _statePageIsLoading ? Container() : Center(
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
      ),
    );
  }
}
