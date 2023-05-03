import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_language_app/components/elements/dataTable/index.dart';
import 'package:my_language_app/components/tools/pageScaffold.dart';
import 'package:my_language_app/config/db/tables/words.dart';
import 'package:my_language_app/config/values.dart';
import 'package:my_language_app/constants/studyTypes.const.dart';
import 'package:my_language_app/lib/dialog.lib.dart';
import 'package:my_language_app/models/components/elements/dataTable/dataCell.dart';
import 'package:my_language_app/models/components/elements/dataTable/dataColumn.dart';
import 'package:my_language_app/models/services/word.model.dart';
import 'package:my_language_app/services/word.service.dart';

import '../components/elements/button.dart';

class PageWordList extends StatefulWidget {
  const PageWordList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageWordListState();
}

class _PageWordListState extends State<PageWordList> {
  late bool _statePageIsLoading = true;
  late List<Map<String, dynamic>> _stateWords = [];

  @override
  void initState() {
    super.initState();
    _pageInit();
  }

  _pageInit() async {
    var words = await WordService.get(
        WordGetParamModel(wordLanguageId: Values.getLanguageId));

    setState(() {
      _stateWords = words;
      _statePageIsLoading = false;
    });
  }

  void onClickEdit() {
    (DialogLib(context)).showMessage(
        title: "Are you sure?",
        content: "You have selected 'daily'. Are you sure about this?",
        onPressedOkay: () {
          Navigator.pushNamed(context, '/study/daily');
        });
  }

  void onClickDelete(Map<String, dynamic> row) {
    DialogLib(context).showMessage(
        title: "Are you sure?",
        content:
            "Are you sure want to delete '${row[DBTableWords.columnTextNative]}'?",
        onPressedOkay: () async {
          DialogLib(context).showLoader(func: () async {
            var result = await WordService.delete(
                WordDeleteParamModel(wordId: row[DBTableWords.columnId]));
            if (result > 0) {
              setState(() {
                _stateWords = _stateWords
                    .where((element) =>
                        element[DBTableWords.columnId] !=
                        row[DBTableWords.columnId])
                    .toList();
              });
              DialogLib(context).showSuccess(
                  content:
                      "'${row[DBTableWords.columnTextNative]}' successfully deleted!");
            } else {
              DialogLib(context).showError(content: "It couldn't delete!");
            }
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return ComponentPageScaffold(
        isLoading: _statePageIsLoading,
        title: "List of Words",
        withScroll: true,
        body: ComponentDataTable<Map<String, dynamic>>(
          data: _stateWords,
          columns: [
            ComponentDataColumnModule(
              title: "Native",
              sortKeyName: DBTableWords.columnTextNative,
              sortable: true,
            ),
            ComponentDataColumnModule(
              title: "Target (${Values.getLanguageName})",
              sortKeyName: DBTableWords.columnTextTarget,
              sortable: true,
            ),
            ComponentDataColumnModule(
              title: "Create Date",
              sortKeyName: DBTableWords.columnCreatedAt,
              sortable: true,
            ),
            ComponentDataColumnModule(
              title: "Study Type",
              sortKeyName: DBTableWords.columnStudyType,
              sortable: true,
            ),
            ComponentDataColumnModule(
              title: "Is Study",
              sortKeyName: DBTableWords.columnIsStudy,
              sortable: true,
            ),
            ComponentDataColumnModule(
              title: "Edit",
            ),
            ComponentDataColumnModule(
              title: "Delete",
            )
          ],
          cells: [
            ComponentDataCellModule(
              child: (row) =>
                  Text(row[DBTableWords.columnTextNative].toString()),
            ),
            ComponentDataCellModule(
              child: (row) =>
                  Text(row[DBTableWords.columnTextTarget].toString()),
            ),
            ComponentDataCellModule(
              child: (row) => Text(DateFormat.yMd().add_Hm().format(
                  DateTime.parse(row[DBTableWords.columnCreatedAt].toString())
                      .toLocal())),
            ),
            ComponentDataCellModule(
              child: (row) => Text(
                  StudyTypes.getTypeName(row[DBTableWords.columnStudyType])),
            ),
            ComponentDataCellModule(
              child: (row) =>
                  Text(row[DBTableWords.columnIsStudy] == 1 ? "Yes" : "No"),
            ),
            ComponentDataCellModule(
              child: (row) => ComponentButton(
                text: "Edit",
                onPressed: onClickEdit,
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
        ));
  }
}
