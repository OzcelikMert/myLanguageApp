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
      'kategori': 'Elektronik',
      'ürün': 'Akıllı Telefon',
      'marka': 'Samsung',
      'renk': 'Siyah',
      'fiyat': 3000,
      'stokDurumu': 'Stokta',
    },
    {
      'kategori': 'Giyim',
      'ürün': 'Gömlek',
      'marka': 'Zara',
      'renk': 'Beyaz',
      'fiyat': 200,
      'stokDurumu': 'Stokta',
    },
    {
      'kategori': 'Kozmetik',
      'ürün': 'Ruj',
      'marka': 'MAC',
      'renk': 'Kırmızı',
      'fiyat': 150,
      'stokDurumu': 'Tükendi',
    },
    {
      'kategori': 'Kitap',
      'ürün': 'Roman',
      'marka': 'Can Yayınları',
      'renk': '-',
      'fiyat': 30,
      'stokDurumu': 'Stokta',
    },
    {
      'kategori': 'Yiyecek',
      'ürün': 'Çikolata',
      'marka': 'Nestle',
      'renk': 'Bitter',
      'fiyat': 10,
      'stokDurumu': 'Stokta',
    },
    {
      'kategori': 'Elektronik',
      'ürün': 'Laptop',
      'marka': 'Dell',
      'renk': 'Gümüş',
      'fiyat': 5000,
      'stokDurumu': 'Tükendi',
    },
    {
      'kategori': 'Yiyecek',
      'ürün': 'Çikolata',
      'marka': 'Nestle',
      'renk': 'Bitter',
      'fiyat': 10,
      'stokDurumu': 'Stokta',
    },
    {
      'kategori': 'Elektronik',
      'ürün': 'Laptop',
      'marka': 'Dell',
      'renk': 'Gümüş',
      'fiyat': 5000,
      'stokDurumu': 'Tükendi',
    },
    {
      'kategori': 'Yiyecek',
      'ürün': 'Çikolata',
      'marka': 'Nestle',
      'renk': 'Bitter',
      'fiyat': 10,
      'stokDurumu': 'Stokta',
    },
    {
      'kategori': 'Elektronik',
      'ürün': 'Laptop',
      'marka': 'Dell',
      'renk': 'Gümüş',
      'fiyat': 5000,
      'stokDurumu': 'Tükendi',
    },
    {
      'kategori': 'Yiyecek',
      'ürün': 'Çikolata',
      'marka': 'Nestle',
      'renk': 'Bitter',
      'fiyat': 10,
      'stokDurumu': 'Stokta',
    },
    {
      'kategori': 'Elektronik',
      'ürün': 'Laptop',
      'marka': 'Dell',
      'renk': 'Gümüş',
      'fiyat': 5000,
      'stokDurumu': 'Tükendi',
    },
    {
      'kategori': 'Yiyecek',
      'ürün': 'Çikolata',
      'marka': 'Nestle',
      'renk': 'Bitter',
      'fiyat': 10,
      'stokDurumu': 'Stokta',
    },
    {
      'kategori': 'Elektronik',
      'ürün': 'Laptop',
      'marka': 'Dell',
      'renk': 'Gümüş',
      'fiyat': 5000,
      'stokDurumu': 'Tükendi',
    },
    {
      'kategori': 'Elektronik',
      'ürün': 'Laptop',
      'marka': 'Dell',
      'renk': 'Gümüş',
      'fiyat': 5000,
      'stokDurumu': 'Tükendi',
    },
    {
      'kategori': 'Yiyecek',
      'ürün': 'Çikolata',
      'marka': 'Nestle',
      'renk': 'Bitter',
      'fiyat': 10,
      'stokDurumu': 'Stokta',
    },
    {
      'kategori': 'Elektronik',
      'ürün': 'Laptop',
      'marka': 'Dell',
      'renk': 'Gümüş',
      'fiyat': 5000,
      'stokDurumu': 'Tükendi',
    },
    {
      'kategori': 'Yiyecek',
      'ürün': 'Çikolata',
      'marka': 'Nestle',
      'renk': 'Bitter',
      'fiyat': 10,
      'stokDurumu': 'Stokta',
    },
    {
      'kategori': 'Elektronik',
      'ürün': 'Laptop',
      'marka': 'Dell',
      'renk': 'Gümüş',
      'fiyat': 5000,
      'stokDurumu': 'Tükendi',
    }
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
            PaginatedDataTable(
              header: const Text('List'),
              rowsPerPage: _rowsPerPage,
              source: _DataSource(context, _data),
              sortColumnIndex: _sortColumnIndex,
              sortAscending: _sortAscending,
              columns: [
                DataColumn(
                  label: const Text('ID'),
                  onSort: (columnIndex, ascending) {
                    _sort<String>((d) => d['kategori'], columnIndex, ascending);
                  },
                ),
                DataColumn(
                  label: const Text('Language'),
                  onSort: (columnIndex, ascending) {
                    _sort<String>((d) => d['ürün'], columnIndex, ascending);
                  },
                ),
                DataColumn(
                  label: const Text('Select'),
                ),
                DataColumn(
                  label: const Text('Delete'),
                ),
              ],
            ),
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
        DataCell(Text(row['kategori'])),
        DataCell(Text(row['ürün'])),
        DataCell(Text(row['marka'])),
        DataCell(Text(row['renk'])),
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
