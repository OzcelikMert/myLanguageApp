import 'package:flutter/material.dart';

class PageProviderModel extends ChangeNotifier {
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  void setIsLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  String _title = "";

  String get title => _title;

  void setTitle(String title) {
    _title = title;
    notifyListeners();
  }

  dynamic _leadingArgs = null;

  dynamic get leadingArgs => _leadingArgs;

  void setLeadingArgs(dynamic leadingArgs) {
    _leadingArgs = leadingArgs;
    notifyListeners();
  }
}