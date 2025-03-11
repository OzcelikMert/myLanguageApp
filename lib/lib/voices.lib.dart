import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:my_language_app/lib/provider.lib.dart';
import 'package:my_language_app/models/dependencies/tts/voice.model.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:my_language_app/models/lib/voices.lib.model.dart';
import 'package:my_language_app/models/providers/language.provider.model.dart';
import 'package:my_language_app/models/providers/tts.provider.model.dart';
import 'package:my_language_app/myLib/variable/array.dart';

class VoicesLib {
  static FlutterTts? _flutterTts;

  static Future<FlutterTts> get flutterTts async {
    try {
      if(_flutterTts == null){
        print("VoicesLib get flutterTts _flutterTts = FlutterTts()");
        _flutterTts = FlutterTts();

        if (Platform.isIOS) {
          await _flutterTts?.setSharedInstance(true);
          await _flutterTts?.setIosAudioCategory(
              IosTextToSpeechAudioCategory.playAndRecord,
              [IosTextToSpeechAudioCategoryOptions.defaultToSpeaker]);
        } else {
          await _flutterTts?.setEngine('com.google.android.tts');
        }
      }
    }catch(e) {
      print("VoicesLib get flutterTts $e");
    }

    return _flutterTts!;
  }

  static Future<void> _setVoice(Map<String, String> voice) async {
    final tts = await flutterTts;
    await (tts).setVoice(voice);
    await (tts).setSpeechRate(0.5);
    await (tts).setVolume(1.0);
  }

  static Future<void> setVoiceSaved(BuildContext context,
      {VoicesLibSetVoiceParamModel? params}) async {
    final languageProviderModel =
        ProviderLib.get<LanguageProviderModel>(context);
    final ttsProviderModel = ProviderLib.get<TTSProviderModel>(context);
    var voice = MyLibArray.findSingle(
        array: ttsProviderModel.voices,
        key: TTSVoiceKeys.keyName,
        value: languageProviderModel.selectedLanguage.languageTTSArtist);
    if (voice != null) {
      await VoicesLib._setVoice({
        TTSVoiceKeys.keyName: params != null ? params.name : voice.name,
        TTSVoiceKeys.keyLocale: params != null ? params.locale : voice.locale
      });
    }
  }

  static Future<List<VoicesLibGetVoicesResultModel>> getVoices() async {
    try {
      final tts = await flutterTts;
      List<VoicesLibGetVoicesResultModel> voices = [];
      List<dynamic> availableVoices = await tts.getVoices;
      if (availableVoices != null) {
        for (var voice in availableVoices) {
          String displayName = voice["name"];
          if (voice["locale"] != null) {
            displayName += " (${voice["locale"]})";
          }
          voices.add(VoicesLibGetVoicesResultModel.fromJson(
              {...voice, TTSVoiceKeys.keyDisplayName: displayName}));
        }
      }
      return MyLibArray.sort(
          array: voices,
          key: TTSVoiceKeys.keyDisplayName,
          sortType: SortType.asc);
    }catch(e) {
      return [];
    }
  }
}
