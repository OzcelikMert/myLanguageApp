import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_language_app/components/elements/dataTable/index.dart';
import 'package:my_language_app/components/elements/pageScaffold.dart';
import 'package:my_language_app/lib/element.lib.dart';
import 'package:my_language_app/lib/route.lib.dart';
import 'package:my_language_app/models/components/elements/dataTable/dataCell.dart';
import 'package:my_language_app/models/components/elements/dataTable/dataColumn.dart';

import '../components/elements/button.dart';

class PageHome extends StatefulWidget {
  const PageHome({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  List<Map<String, dynamic>> _data = [
    {'id': '123', 'name': 'Akıllı Telefon'},
    {'id': '444', 'name': 'QWEQWE'},
  ];

  void onClickSelect() {
    RouteLib(context).change(target: '/study/plan');
  }

  void onClickMonthly() {
    RouteLib(context).change(target: '/language/add', safeHistory: true);
  }

  @override
  Widget build(BuildContext context) {
    return ComponentPageScaffold(
      title: "Select Language",
      hideSidebar: true,
      withScroll: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsets.all(16)),
            ComponentButton(
              onPressed: () => onClickMonthly(),
              text: "Add New",
            ),
            const Padding(padding: EdgeInsets.all(16)),
            ComponentDataTable<Map<String, dynamic>>(
              title: "Select a language",
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
                    onPressed: onClickSelect,
                    icon: Icons.check,
                    buttonSize: ComponentButtonSize.sm,
                  ),
                ),
                ComponentDataCellModule(
                  child: (row) => ComponentButton(
                    text: "Delete",
                    bgColor: Colors.pink,
                    onPressed: () {
                      log(row["id"].toString());
                    },
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