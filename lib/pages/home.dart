import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_language_app/components/elements/dataTable/index.dart';
import 'package:my_language_app/components/tools/pageScaffold.dart';
import 'package:my_language_app/config/db/conn.dart';
import 'package:my_language_app/config/db/tables/languages.dart';
import 'package:my_language_app/lib/dialog.lib.dart';
import 'package:my_language_app/lib/route.lib.dart';
import 'package:my_language_app/models/components/elements/dataTable/dataCell.dart';
import 'package:my_language_app/models/components/elements/dataTable/dataColumn.dart';
import 'package:my_language_app/models/services/language.model.dart';
import 'package:my_language_app/services/language.service.dart';

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
    var languages = await LanguageService.get();

    setState(() {
      _stateLanguages = languages;
      _statePageIsLoading = false;
    });
  }

  void onClickSelect() {
     RouteLib(context).change(target: '/study/plan');
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
                    onPressed: onClickSelect,
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