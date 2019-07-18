import 'package:shared_preferences/shared_preferences.dart' as storage;
import 'data.dart';

class Preferences {

  static Future<bool> hasTokenStatic(EcoSystem type)async{
    Preferences preferences = Preferences(type);
    return preferences.hasToken();
  }

  final EcoSystem type;
  storage.SharedPreferences _preferences;
  Preferences(this.type){
//    initStorage();
  }

  void initStorage()async{
    _preferences = await storage.SharedPreferences.getInstance();
  }

  void saveToken(String token)async{
    await _preferences.setString(getKey(), token);
  }

  Future<bool> hasToken() async {
    return Future.value(false);
  }

  String getToken(){
    return _preferences.getString(getKey());
  }

  String getKey(){
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