import 'dart:io';

import 'package:my_language_app/models/dependencies/tts/voice.model.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:my_language_app/myLib/variable/array.dart';

class VoicesLib {
  static FlutterTts? _flutterTts;

  static Future<FlutterTts> get flutterTts async {
    if(_flutterTts != null) return _flutterTts as FlutterTts;
    _flutterTts = FlutterTts();

    if (Platform.isIOS) {
      await _flutterTts?.setSharedInstance(true);
      await _flutterTts?.setIosAudioCategory(IosTextToSpeechAudioCategory.playAndRecord, [IosTextToSpeechAudioCategoryOptions.defaultToSpeaker]);
    }else {
      await _flutterTts?.setEngine('com.google.android.tts');
    }

    return _flutterTts as FlutterTts;
  }

  static Future<List<Map<String, dynamic>>> getVoices() async {
    List<Map<String, dynamic>> voices = [];
    List<dynamic> availableVoices = await (await flutterTts).getVoices;
    if (availableVoices != null) {
      for (var voice in availableVoices) {
        String displayName = voice["name"];
        if (voice["locale"] != null) {
          displayName += " (${voice["locale"]})";
        }
        voices.add({
          TTSVoiceKeys.keyName: voice["name"],
          TTSVoiceKeys.keyDisplayName: displayName,
          TTSVoiceKeys.keyLocale: voice["locale"],
          TTSVoiceKeys.keyGender: voice["gender"],
          TTSVoiceKeys.keyRate: voice["rate"],
          TTSVoiceKeys.keyPitch: voice["pitch"],
          TTSVoiceKeys.keyVolume: voice["volume"],
        });
      }
    }
    return MyLibArray.sort(array: voices, key: TTSVoiceKeys.keyDisplayName, sortType: SortType.asc);
  }
}