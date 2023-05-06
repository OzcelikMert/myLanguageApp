import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class FileLib {
  static Future<File?> convertJsonStringToFile({required String fileName, required String jsonString}) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, fileName);
    return File(path).writeAsString(jsonString);
  }

  static Future<File> saveLocation(File file) async {
    final directory = await getExternalStorageDirectory();
    final savePath = '${directory!.path}/${file.path.split('/').last}';
    return await file.copy(savePath);
  }
}