import 'package:shared_preferences/shared_preferences.dart';

class LockService {

  static Future<void> lockDevice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("is_locked", true);
  }

  static Future<void> unlockDevice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("is_locked", false);
  }

  static Future<bool> isLocked() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("is_locked") ?? false;
  }
}