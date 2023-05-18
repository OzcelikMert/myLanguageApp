import 'package:my_language_app/models/dependencies/tts/voice.model.dart';

class VoicesLibGetVoicesResultModel {
  final String name;
  final String locale;
  final String displayName;
  final String gender;
  final String rate;
  final String pitch;
  final String volume;

  VoicesLibGetVoicesResultModel(
      {required this.name,
      required this.locale,
      required this.displayName,
      required this.gender,
      required this.rate,
      required this.pitch,
      required this.volume});

  Map<String, dynamic> toJson() {
    return {
      TTSVoiceKeys.keyName: name,
      TTSVoiceKeys.keyLocale: locale,
      TTSVoiceKeys.keyDisplayName: displayName,
      TTSVoiceKeys.keyGender: gender,
      TTSVoiceKeys.keyRate: rate,
      TTSVoiceKeys.keyPitch: pitch,
      TTSVoiceKeys.keyVolume: volume,
    };
  }

  static VoicesLibGetVoicesResultModel fromJson(Map<String, dynamic> json) {
    return VoicesLibGetVoicesResultModel(
      name: json[TTSVoiceKeys.keyName],
      locale: json[TTSVoiceKeys.keyLocale],
      displayName: json[TTSVoiceKeys.keyDisplayName],
      gender: json[TTSVoiceKeys.keyGender] ?? "",
      rate: json[TTSVoiceKeys.keyRate] ?? "",
      pitch: json[TTSVoiceKeys.keyPitch] ?? "",
      volume: json[TTSVoiceKeys.keyVolume] ?? "",
    );
  }
}

class VoicesLibSetVoiceParamModel {
  final String name;
  final String locale;
  final String gender;

  VoicesLibSetVoiceParamModel({
    required this.name,
    required this.locale,
    required this.gender,});
}
