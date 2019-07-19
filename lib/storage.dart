import 'data.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class Storage {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final EcoSystem type;

  Storage(this.type);

  Future<void> saveToken(String token) async {
    return storage.write(key: _getKey(), value: token);
  }

  Future<bool> hasToken() async {
    return Future.value(await getToken() != null);
  }

  Future<String> getToken() async {
    return storage.read(key: _getKey());
  }

  Future<void> logout(){
    return storage.delete(key: _getKey());
  }

  Future<void> saveUser(String email, String photoUrl) {
    if(photoUrl == null){
      photoUrl = "empty";
    }
    String userJson = "{\n \"email\" : \"" +
        email +
        "\", \n \"photoUrl\" : \"" +
        photoUrl +
        "\" \n}";
    print(userJson);
    return storage.write(key: _getUserJsonKey(), value: userJson);
  }

  Future<User> getUser() async {
    var json = await storage.read(key: _getUserJsonKey());
    var decodedJson = jsonDecode(json);
    print(decodedJson["photoUrl"]);
    var user = User(decodedJson["email"], decodedJson["photoUrl"]);
    return user;
  }

  String _getKey() {
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

  String _getUserJsonKey() {
    String title = "userId";
    if (type == EcoSystem.GOOGLE) {
      title += "Google Drive";
    } else if (type == EcoSystem.ONEDRIVE) {
      title += "One Drive";
    } else if (type == EcoSystem.DROPBOX) {
      title += "Dropbox";
    }
    return title;
  }
}
