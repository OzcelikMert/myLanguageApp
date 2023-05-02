import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_language_app/components/elements/dataTable/index.dart';
import 'package:my_language_app/components/tools/pageScaffold.dart';
import 'package:my_language_app/config/db/tables/languages.dart';
import 'package:my_language_app/config/index.dart';
import 'package:my_language_app/lib/dialog.lib.dart';
import 'package:my_language_app/lib/route.lib.dart';
import 'package:my_language_app/models/components/elements/dataTable/dataCell.dart';
import 'package:my_language_app/models/components/elements/dataTable/dataColumn.dart';
import 'package:my_language_app/models/components/provider/index.dart';
import 'package:my_language_app/models/services/language.model.dart';
import 'package:my_language_app/myLib/variable/array.dart';
import 'package:my_language_app/services/language.service.dart';
import 'package:provider/provider.dart';

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

    if(languages.length > 0){
      var findLanguage = MyLibArray.findSingle(languages, DBTableLanguages.columnIsSelected, 1);
      if(findLanguage != null){
        final providerModel = Provider.of<ProviderModel>(context, listen: false);
        providerModel.languageId = findLanguage[DBTableLanguages.columnId];
        providerModel.languageName = findLanguage[DBTableLanguages.columnName];
        RouteLib(context).change(target: '/study/plan');
        return;
      }
    }

    setState(() {
      _stateLanguages = languages;
      _statePageIsLoading = false;
    });
  }

  void onClickAdd() async {
    var isAdded = await RouteLib(context).change(target: '/language/add', safeHistory: true);
    if(isAdded){
      setState(() {
        _statePageIsLoading = true;
      });
      await _pageInit();
    }
  }

  void onClickSelect(Map<String, dynamic> row) async {
    DialogLib(context).showLoader();
    var result = await LanguageService.update(LanguageUpdateParamModel(
        languageId: row[DBTableLanguages.columnId],
        languageIsSelected: 1
    ));
    DialogLib(context).hide();
    if(result > 0){
      final providerModel = Provider.of<ProviderModel>(context, listen: false);
      providerModel.languageId = row[DBTableLanguages.columnId];
      providerModel.languageName = row[DBTableLanguages.columnName];
      RouteLib(context).change(target: '/study/plan');
    }
  }

  void onClickDelete(Map<String, dynamic> row) async {
    DialogLib(context).showMessage(
        title: "Are you sure?",
        content: "Are you sure want to delete '${row[DBTableLanguages.columnName]}'?",
        onPressedOkay: () async {
          DialogLib(context).showLoader();
          var result = await LanguageService.delete(LanguageDeleteParamModel(
            languageId: row[DBTableLanguages.columnId]
          ));
          DialogLib(context).hide();

          if(result > 0){
            setState(() {
              _stateLanguages = _stateLanguages.where((element) => element[DBTableLanguages.columnId] != row[DBTableLanguages.columnId]).toList();
            });
            DialogLib(context).showSuccess(content: "'${row[DBTableLanguages.columnName]}' successfully deleted!");
          }else {
            DialogLib(context).showError(content: "It couldn't delete!");
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return ComponentPageScaffold(
      isLoading: _statePageIsLoading,
      title: "Select Language",
      hideSidebar: true,
      withScroll: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsets.all(16)),
            ComponentButton(
              onPressed: () => onClickAdd(),
              text: "Add New",
            ),
            const Padding(padding: EdgeInsets.all(16)),
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
                  child: (row) => Text(row[DBTableLanguages.columnName].toString()),
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
                    bgColor: Colors.pink,
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