import 'dart:collection';
import 'dart:convert';

enum SortType { asc, desc }

class MyLibArray {
  static _convertQueryData(dynamic data) {
    return jsonEncode({"d": data is int ? data.toString() : data});
  }

  static T? findSingle<T>({required List<T> array, required String key, required dynamic value}) {
    var finds = array.where((data) {
      bool query = false;
      if (value != null) {
        dynamic _data = data as Map<String, dynamic>;
        if (key.length > 0) {
          for (var subKey in key.split(".")) {
            try {
              if (_data[subKey] != null) {
                _data = _data[subKey];
              }
            } catch (ex) {}
          }
        }
        query = _convertQueryData(_data) == _convertQueryData(value);
      }
      return query;
    }).toList();

    return finds.isNotEmpty ? finds[0] : null;
  }

  static List<T> findMulti<T>(
      {required List<T> array,
      required String key,
      required dynamic value,
      bool isLike = true}) {
    return array.where((data) {
      bool query = false;

      if (value != null) {
        dynamic _data = data as Map<String, dynamic>;
        if (key.length > 0) {
          for (var subKey in key.split(".")) {
            try {
              if (_data[subKey] != null) {
                _data = _data[subKey];
              }
            } catch (ex) {}
          }
        }
        if (value is List) {
          query = value
              .map((v) => _convertQueryData(v))
              .contains(_convertQueryData(_data));
        } else {
          query = _convertQueryData(_data) == _convertQueryData(value);
        }
      }
      return query == isLike;
    }).toList();
  }

  static List<Map<String, dynamic>> sort(
      {required List array,
      required String key,
      required SortType? sortType}) {
    sortType = sortType ?? SortType.asc;

    List<Map<String, dynamic>> sortedList =
        List<Map<String, dynamic>>.from(array);
    sortedList.sort((a, b) {
      var varA = a[key] ?? a;
      var varB = b[key] ?? b;

      if (sortType == SortType.asc) {
        return varA.compareTo(varB);
      } else {
        return varB.compareTo(varA);
      }
    });

    return sortedList;
  }

  static Map<String, String> convertLinkedHashMapToMap(
      LinkedHashMap linkedHashMap) {
    Map<String, String> result = {};
    linkedHashMap.forEach((key, value) {
      result[key.toString()] = value.toString();
    });
    return result;
  }
}
