import 'dart:io';
import 'package:path_provider/path_provider.dart';

class UserRepository {
  Future<void> splashDelay() async {
    await Future.delayed(
      Duration(seconds: 2),
    );
    return;
  }
}
