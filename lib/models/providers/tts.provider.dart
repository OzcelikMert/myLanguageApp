import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TTSProviderModel extends ChangeNotifier {
  List<Map<String, dynamic>> _voices = [];

  List<Map<String, dynamic>> get voices => _voices;

  Future<void> setVoices(List<Map<String, dynamic>> voices) async {
    _voices = voices;
    notifyListeners();
  }
}