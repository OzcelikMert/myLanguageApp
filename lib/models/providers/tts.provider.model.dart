import 'package:flutter/material.dart';
import 'package:my_language_app/models/lib/voices.lib.model.dart';

class TTSProviderModel extends ChangeNotifier {
  List<VoicesLibGetVoicesResultModel> _voices = [];

  List<VoicesLibGetVoicesResultModel> get voices => _voices;

  Future<void> setVoices(List<VoicesLibGetVoicesResultModel> voices) async {
    _voices = voices;
    notifyListeners();
  }
}