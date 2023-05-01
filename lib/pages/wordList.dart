import 'package:flutter/material.dart';
import 'package:my_language_app/components/elements/dataTable/index.dart';
import 'package:my_language_app/components/tools/pageScaffold.dart';
import 'package:my_language_app/lib/dialog.lib.dart';
import 'package:my_language_app/models/components/elements/dataTable/dataCell.dart';
import 'package:my_language_app/models/components/elements/dataTable/dataColumn.dart';

import '../components/elements/button.dart';

class PageWordList extends StatefulWidget {
  const PageWordList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageWordListState();
}

class _PageWordListState extends State<PageWordList> {
  late bool _statePageIsLoading = true;

  @override
  void initState() {
    super.initState();
    _pageInit();
  }

  _pageInit() async {
    setState(() {
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

  void onClickDelete() {
    (DialogLib(context)).showMessage(
        title: "Are you sure?",
        content: "You have selected 'daily'. Are you sure about this?",
        onPressedOkay: () {
          Navigator.pushNamed(context, '/study/daily');
        });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> _data = [];
    for (var i = 0; i < 35; i++) {
      _data.add({"id": i, "name": "qwe - ${i}"});
    }

    return ComponentPageScaffold(
        isLoading: _statePageIsLoading,
        title: "Edit",
        withScroll: true,
        body: ComponentDataTable<Map<String, dynamic>>(
          title: "List of words",
          data: _data,
          columns: [
            ComponentDataColumnModule(
              title: "ID",
              sortKeyName: "id",
              sortable: true,
            ),
            ComponentDataColumnModule(
              title: "Name",
              sortKeyName: "name",
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
              child: (row) => Text(row["id"].toString()),
            ),
            ComponentDataCellModule(
              child: (row) => Text(row["name"].toString()),
            ),
            ComponentDataCellModule(
              child: (row) => ComponentButton(
                text: "Select",
                onPressed: onClickEdit,
                icon: Icons.check,
                buttonSize: ComponentButtonSize.sm,
              ),
            ),
            ComponentDataCellModule(
              child: (row) => ComponentButton(
                text: "Delete",
                bgColor: Colors.pink,
                onPressed: onClickDelete,
                icon: Icons.delete_forever,
                buttonSize: ComponentButtonSize.sm,
              ),
            )
          ],
        ));
  }
}
