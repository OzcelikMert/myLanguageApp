import 'package:flutter/material.dart';
import 'package:my_language_app/components/elements/search.dart';
import 'package:my_language_app/constants/theme.const.dart';
import 'package:my_language_app/models/components/elements/dataTable/dataCell.dart';
import 'package:my_language_app/models/components/elements/dataTable/dataColumn.dart';

class ComponentDataTable<T> extends StatefulWidget {
  final String? title;
  final List<T> data;
  final List<ComponentDataColumnModule> columns;
  final List<ComponentDataCellModule<T>> cells;
  final bool? isSearchable;
  final List<String>? searchableKeys;

  const ComponentDataTable(
      {Key? key,
      this.title,
      required this.data,
      required this.columns,
      required this.cells, 
        this.isSearchable, 
        this.searchableKeys
      })
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ComponentDataTableState<T>();
}

class _ComponentDataTableState<T> extends State<ComponentDataTable<T>> {
  late int _stateRowsPerPage = 15;
  late int _stateSortColumnIndex = 0;
  late bool _stateSortAscending = true;
  late List<T> _stateFilteredRows = [];
  late String _stateSearchText = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      _stateFilteredRows = List<T>.from(widget.data);
    });
  }

  @override
  void didUpdateWidget(ComponentDataTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data) {
      setState(() {
        _stateFilteredRows = List<T>.from(widget.data);
      });
      search(_stateSearchText);
    }
  }

  void _sort<P>(
      Comparable<P> Function(T d) getField, int columnIndex, bool ascending, bool isDate) {
    _stateFilteredRows.sort((a, b) {
      dynamic aValue = getField(a);
      dynamic bValue = getField(b);

      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    setState(() {
      _stateSortColumnIndex = columnIndex;
      _stateSortAscending = ascending;
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
                  _sort<dynamic>((dynamic d) => d[column.sortKeyName],
                      columnIndex, ascending, column.isDate);
                }
              : null));
    }
    return dataColumns;
  }

  void search(String query) {
    setState(() {
      _stateSearchText = query;
      if (query.isNotEmpty) {
        _stateFilteredRows = widget.data.where((dynamic row) {
          bool isContain = false;
          if(widget.searchableKeys != null){
            for(var key in widget.searchableKeys!) {
              isContain = row[key].toString().toLowerCase().contains(query.toLowerCase());
              if(isContain == true) break;
            }
          }
          return isContain;
        }).toList();
      } else {
        _stateFilteredRows = widget.data;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          widget.isSearchable == true ? ComponentSearchTextField(
            onTextChanged: (query) {
              search(query);
            },
          ) : Container(),
          PaginatedDataTable(
              columnSpacing: 35,
              dataRowHeight: 70,
              showFirstLastButtons: true,
              header: widget.title != null
                  ? Center(child: Text(widget.title.toString()))
                  : null,
              rowsPerPage: _stateRowsPerPage,
              source: _DataSource<T>(
                  context: context, data: _stateFilteredRows, cells: widget.cells),
              sortColumnIndex: _stateSortColumnIndex,
              sortAscending: _stateSortAscending,
              columns: _getColumns())
        ],
      ),
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
