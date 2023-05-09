import 'package:audioplayers/audioplayers.dart';

class AudioLib {
  static AudioPlayer? _audioPlayer;

  static Future<AudioPlayer> get audioCache async {
    if(_audioPlayer != null) return _audioPlayer!;
    _audioPlayer = AudioPlayer();
    return _audioPlayer!;
  }

  static Future<void> play(String soundName) async {
    await ((await audioCache).play(AssetSource("audios/$soundName")));
  }
}