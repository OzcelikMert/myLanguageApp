import 'dart:collection';
import 'dart:convert';

enum SortType { asc, desc }

class MyLibArray {
  static _convertQueryData(dynamic data) {
    return jsonEncode({"d": data is int ? data.toString() : data});
  }

  static T? findSingle<T>({required List<T> array, required String key, required dynamic value, bool isTypeClass = true}) {
    var finds = array.where((dynamic data) {
      bool query = false;
      if (value != null) {
        dynamic _data;
        if(isTypeClass){
          try {
            _data = data.toJson();
          } catch (ex) {
            return false;
          }
        }else {
          _data = data;
        }

        if (key.length > 0) {
          for (var subKey in key.split(".")) {
            try {
              if (_data[subKey] != null) {
                _data = _data[subKey];
              }
            } catch (ex) {
              return false;
            }
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
      bool isLike = true,
      bool isTypeClass = true}) {
    return array.where((dynamic data) {
      bool query = false;

      if (value != null) {
        dynamic _data;
        if(isTypeClass){
          try {
            _data = data.toJson();
          } catch (ex) {
            return false;
          }
        }else {
          _data = data;
        }

        if (key.length > 0) {
          for (var subKey in key.split(".")) {
            try {
              if (_data[subKey] != null) {
                _data = _data[subKey];
              }
            } catch (ex) {
              return false;
            }
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

  static List<T> sort<T>(
      {required List<T> array,
      required String key,
      required SortType? sortType,
      bool isTypeClass = true}) {
    sortType = sortType ?? SortType.asc;

    List<T> sortedList = List<T>.from(array);
    sortedList.sort((dynamic a, dynamic b) {
      dynamic _a;
      dynamic _b;
      if(isTypeClass){
        try {
          _a = a.toJson();
          _b = b.toJson();
        } catch (ex) {
          return 0;
        }
      }else {
        _a = a;
        _b = b;
      }


      var varA = _a[key] ?? _a;
      var varB = _b[key] ?? _b;

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
