import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  // Menyimpan & Mengambil Username
  static Future<void> saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  // Menyimpan & Mengambil Status Login
  static Future<void> saveLoginStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', status);
  }

  static Future<bool> getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  // Cache API Dasar (Menyimpan JSON Response)
  static Future<void> saveCachedPosts(String jsonString) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cached_posts', jsonString);
  }

  static Future<String?> getCachedPosts() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('cached_posts');
  }

  // Fitur Logout (Menghapus data)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
