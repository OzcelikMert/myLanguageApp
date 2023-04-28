import 'package:flutter/material.dart';
import 'package:my_language_app/components/elements/pageScaffold.dart';
import 'package:my_language_app/lib/element.lib.dart';
import 'package:my_language_app/lib/route.lib.dart';

import '../components/elements/button.dart';

class PageHome extends StatefulWidget {
  const PageHome({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  int _rowsPerPage = 15;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  List<Map<String, dynamic>> _data = [
    {
      'id': '123',
      'name': 'Akıllı Telefon',
    },
  ];

  void _sort<T>(Comparable<T> Function(Map<String, dynamic> d) getField,
      int columnIndex, bool ascending) {
    _data.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

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
            Container(
              width: double.infinity,
              child: PaginatedDataTable(
                header: const Center(child: Text('Select a language')),
                rowsPerPage: _rowsPerPage,
                source: _DataSource(context, _data),
                sortColumnIndex: _sortColumnIndex,
                sortAscending: _sortAscending,
                columns: [
                  DataColumn(
                    label: const Text('ID'),
                    onSort: (columnIndex, ascending) {
                      _sort<String>((d) => d['id'], columnIndex, ascending);
                    },
                  ),
                  DataColumn(
                    label: const Text('Language'),
                    onSort: (columnIndex, ascending) {
                      _sort<String>((d) => d['name'], columnIndex, ascending);
                    },
                  ),
                  DataColumn(
                    label: Text("Select"),
                  ),
                  DataColumn(
                    label: Text("Delete"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _DataSource extends DataTableSource {
  _DataSource(this.context, this.data);

  final BuildContext context;
  final List<Map<String, dynamic>> data;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= data.length) {
      return null!;
    }
    final row = data[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(row['id'])),
        DataCell(Text(row['name'])),
        DataCell(ComponentButton(
          text: "Select",
          onPressed: () {},
          icon: Icons.check,
          buttonSize: ComponentButtonSize.sm,
        )),
        DataCell(ComponentButton(
          text: "Delete",
          bgColor: Colors.pink,
          onPressed: () {},
          icon: Icons.delete_forever,
          buttonSize: ComponentButtonSize.sm,
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
