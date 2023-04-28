import 'package:flutter/material.dart';
import 'package:my_language_app/models/components/elements/dataTable/dataCell.dart';
import 'package:my_language_app/models/components/elements/dataTable/dataColumn.dart';

class ComponentDataTable<T> extends StatefulWidget {
  final String? title;
  final List<T> data;
  final List<ComponentDataColumnModule> columns;
  final List<ComponentDataCellModule<T>> cells;

  const ComponentDataTable(
      {Key? key,
      this.title,
      required this.data,
      required this.columns,
      required this.cells})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ComponentDataTableState<T>();
}

class _ComponentDataTableState<T> extends State<ComponentDataTable<T>> {
  int _rowsPerPage = 15;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  void _sort<P>(Comparable<P> Function(T d) getField,
      int columnIndex, bool ascending) {
    widget.data.sort((a, b) {
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

  List<DataColumn> _getColumns() {
    List<DataColumn> dataColumns = [];
    for (var column in widget.columns) {
      dataColumns.add(DataColumn(
          label: Text(column.title),
          numeric: column.numeric,
          onSort: column.sortable == true
              ? (columnIndex, ascending) {
                  _sort<String>(
                      (dynamic d) => d[column.sortKeyName], columnIndex, ascending);
                }
              : null));
    }
    return dataColumns;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: PaginatedDataTable(
          header: widget.title != null
              ? Center(child: Text(widget.title.toString()))
              : null,
          rowsPerPage: _rowsPerPage,
          source: _DataSource<T>(
              context: context, data: widget.data, cells: widget.cells),
          sortColumnIndex: _sortColumnIndex,
          sortAscending: _sortAscending,
          columns: _getColumns()),
    );
  }
}

class _DataSource<T> extends DataTableSource {
  final BuildContext context;
  final List<T> data;
  final List<ComponentDataCellModule<T>> cells;

  _DataSource({required this.context, required this.data, required this.cells});

  List<DataCell> _getCells(T row) {
    List<DataCell> dataCells = [];
    for (var cell in cells) {
      dataCells.add(DataCell(cell.child(row)));
    }
    return dataCells;
  }

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= data.length) {
      return null!;
    }
    final row = data[index];
    return DataRow.byIndex(index: index, cells: _getCells(row));
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
