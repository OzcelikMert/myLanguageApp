import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
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
    if(_flutterTts != null) return _flutterTts!;
    _flutterTts = FlutterTts();

    if (Platform.isIOS) {
      await _flutterTts?.setSharedInstance(true);
      await _flutterTts?.setIosAudioCategory(IosTextToSpeechAudioCategory.playAndRecord, [IosTextToSpeechAudioCategoryOptions.defaultToSpeaker]);
    }else {
      await _flutterTts?.setEngine('com.google.android.tts');
    }

    return _flutterTts!;
  }

  static Future<void> _setVoice(Map<String, String> voice) async {
    await (await flutterTts).setVoice(voice);
    await (await flutterTts).setSpeechRate(0.5);
    await (await flutterTts).setVolume(1.0);
  }

  static Future<void> setVoiceSaved(BuildContext context, {VoicesLibSetVoiceParamModel? params}) async {
    final languageProviderModel =
    ProviderLib.get<LanguageProviderModel>(context);
    final ttsProviderModel = ProviderLib.get<TTSProviderModel>(context);
    var voice = MyLibArray.findSingle(
        array: ttsProviderModel.voices,
        key: TTSVoiceKeys.keyName,
        value: languageProviderModel
            .selectedLanguage.languageTTSArtist);
    if (voice != null) {
      await VoicesLib._setVoice({
        TTSVoiceKeys.keyName: params != null ? params.name : voice.name,
        TTSVoiceKeys.keyLocale: params != null ? params.locale : voice.locale
      });
    }
  }

  static Future<List<VoicesLibGetVoicesResultModel>> getVoices() async {
    List<VoicesLibGetVoicesResultModel> voices = [];
    List<dynamic> availableVoices = await (await flutterTts).getVoices;
    if (availableVoices != null) {
      for (var voice in availableVoices) {
        String displayName = voice["name"];
        if (voice["locale"] != null) {
          displayName += " (${voice["locale"]})";
        }
        voices.add(VoicesLibGetVoicesResultModel.fromJson({...voice, TTSVoiceKeys.keyDisplayName: displayName}));
      }
    }
    return MyLibArray.sort(array: voices, key: TTSVoiceKeys.keyDisplayName, sortType: SortType.asc);
  }
}