import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'FilePicker.dart';

class StorageFilePicker extends FilePicker {
  @override
  Future<Directory> fetchDirectory(String path) {
    return null;
  }

  @override
  Future<File> fetchFile(String path) {
    return null;
  }

  @override
  Future<Directory> fetchRoot() async {
    var files;
    if(Platform.isAndroid){
      files = await getExternalStorageDirectory() == null ? getApplicationDocumentsDirectory() : getExternalStorageDirectory();
    } else{
      files = await getApplicationDocumentsDirectory();
    }
    return files;
  }
}
