import 'dart:collection';

class MyLibraryArray {
  static Map<String, String> convertLinkedHashMapToMap(LinkedHashMap linkedHashMap) {
    Map<String, String> result = {};
    linkedHashMap.forEach((key, value) {
      result[key.toString()] = value.toString();
    });
    return result;
  }
}