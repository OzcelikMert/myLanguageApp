import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TTSProviderModel extends ChangeNotifier {
  FlutterTts? _flutterTts;

  FlutterTts get flutterTts => _flutterTts!;

  Future<void> setFlutterTts(FlutterTts flutterTts) async {
    _flutterTts = flutterTts;
    notifyListeners();
  }

  List<Map<String, dynamic>> _voices = [];

  List<Map<String, dynamic>> get voices => _voices;

  Future<void> setVoices(List<Map<String, dynamic>> voices) async {
    _voices = voices;
    notifyListeners();
  }
}