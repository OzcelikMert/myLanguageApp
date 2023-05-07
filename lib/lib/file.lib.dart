import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileLib {
  static Directory? _applicationDocumentDirectory = null;
  static Future<Directory> get applicationDocumentDirectory  async {
    if(_applicationDocumentDirectory != null) return _applicationDocumentDirectory!;
    _applicationDocumentDirectory = await getApplicationDocumentsDirectory();
    return _applicationDocumentDirectory!;
  }

  static Directory? _downloadDirectory = null;
  static Future<Directory> get downloadDirectory  async {
    if(_downloadDirectory != null) return _downloadDirectory!;
    bool dirDownloadExists = true;

    if (Platform.isIOS) {
      _downloadDirectory = await getDownloadsDirectory();
    } else {

      dirDownloadExists = await Directory("/storage/emulated/0/Download/").exists();
      if(dirDownloadExists){
        _downloadDirectory =  Directory("/storage/emulated/0/Download/");
      }else{
        _downloadDirectory = Directory("/storage/emulated/0/Downloads/");
      }
    }
    return _downloadDirectory!;
  }

  static Future<File?> exportJsonFile({required String fileName, required String jsonString}) async {
    Directory? downloadsDirectory = await downloadDirectory;
    if(downloadsDirectory != null){
      final String downloadsPath = downloadsDirectory.path;
      final String localPath = '$downloadsPath/$fileName.json';
      return await File(localPath).writeAsString(jsonString);
    }
  }

  static Future<PermissionStatus> checkPermission() async {
    PermissionStatus status;
    if (Platform.isAndroid) {
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      final AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
      if ((info.version.sdkInt) >= 33) {
        status = await Permission.manageExternalStorage.request();
      } else {
        status = await Permission.storage.request();
      }
    } else {
      status = await Permission.storage.request();
    }

    return status;
  }

  static Future<List<Map<String, dynamic>>?> importJsonFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['json'], initialDirectory: (await downloadDirectory).path);
    if(result != null && result.files.isNotEmpty){
      try {
        File file = File(result.files.single.path!);
        String contents = await file.readAsString();
        dynamic jsonData = jsonDecode(contents).cast<Map<String, dynamic>>();
        await file.delete();
        return jsonData;
      } catch (e) {
        print(e);
      }
    }
  }
}