import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static SharedPreferences? _prefs;
  static bool _initialized = false;

  // Keys
  static const String keyLanguage = 'language';
  static const String keyDarkMode = 'dark_mode';
  static const String keyNotifications = 'notifications';
  static const String keyBiometric = 'biometric';

  // Initialize
  static Future<void> init() async {
    if (_initialized) return;
    try {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
    } catch (e) {
      debugPrint('StorageService init error: $e');
    }
  }

  // Ensure initialized before any operation
  static Future<void> _ensureInitialized() async {
    if (!_initialized || _prefs == null) {
      await init();
    }
  }

  // Language
  static String getLanguage() {
    try {
      return _prefs?.getString(keyLanguage) ?? 'en_US';
    } catch (e) {
      return 'en_US';
    }
  }

  static Future<void> setLanguage(String value) async {
    await _ensureInitialized();
    try {
      await _prefs?.setString(keyLanguage, value);
    } catch (e) {
      debugPrint('setLanguage error: $e');
    }
  }

  // Dark Mode
  static bool getDarkMode() {
    try {
      return _prefs?.getBool(keyDarkMode) ?? false;
    } catch (e) {
      return false;
    }
  }

  static Future<void> setDarkMode(bool value) async {
    await _ensureInitialized();
    try {
      await _prefs?.setBool(keyDarkMode, value);
    } catch (e) {
      debugPrint('setDarkMode error: $e');
    }
  }

  // Notifications
  static bool getNotifications() {
    try {
      return _prefs?.getBool(keyNotifications) ?? true;
    } catch (e) {
      return true;
    }
  }

  static Future<void> setNotifications(bool value) async {
    await _ensureInitialized();
    try {
      await _prefs?.setBool(keyNotifications, value);
    } catch (e) {
      debugPrint('setNotifications error: $e');
    }
  }

  // Biometric
  static bool getBiometric() {
    try {
      return _prefs?.getBool(keyBiometric) ?? false;
    } catch (e) {
      return false;
    }
  }

  static Future<void> setBiometric(bool value) async {
    await _ensureInitialized();
    try {
      await _prefs?.setBool(keyBiometric, value);
    } catch (e) {
      debugPrint('setBiometric error: $e');
    }
  }
}
