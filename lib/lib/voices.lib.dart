import 'package:my_language_app/models/dependencies/tts/voice.model.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:my_language_app/myLib/variable/array.dart';

class VoicesLib {
  static Future<List<Map<String, dynamic>>> getVoices() async {
    FlutterTts flutterTts = FlutterTts();
    List<Map<String, dynamic>> voices = [];
    List<dynamic> availableVoices = await flutterTts.getVoices;
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