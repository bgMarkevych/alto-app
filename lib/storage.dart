import 'data.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {

  final FlutterSecureStorage storage = FlutterSecureStorage();
  final EcoSystem type;
  Storage(this.type);

  Future<void> saveToken(String token)async{
    if(await hasToken()){
      await storage.delete(key: _getKey());
    }
    return storage.write(key: _getKey(), value: token);
  }

  Future<bool> hasToken() async {
    return Future.value(await getToken() != null);
  }

  Future<String> getToken()async{
    return storage.read(key: _getKey());
  }

  String _getKey(){
    String title = "";
    if (type == EcoSystem.GOOGLE) {
      title = "Google Drive";
    } else if (type == EcoSystem.ONEDRIVE) {
      title = "One Drive";
    } else if (type == EcoSystem.DROPBOX) {
      title = "Dropbox";
    }
    return title;
  }

}