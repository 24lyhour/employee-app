import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _prefs;
  static bool _initialized = false;

  // Singleton instance
  static StorageService get instance {
    _instance ??= StorageService._();
    return _instance!;
  }

  StorageService._();

  // Keys
  static const String keyLanguage = 'language';
  static const String keyDarkMode = 'dark_mode';
  static const String keyNotifications = 'notifications';
  static const String keyBiometric = 'biometric';
  static const String keyToken = 'auth_token';
  static const String keyEmployee = 'employee_data';

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
  Future<void> _ensureInitialized() async {
    if (!_initialized || _prefs == null) {
      await init();
    }
  }

  // ==================== Auth Token ====================

  static String? getToken() {
    try {
      return _prefs?.getString(keyToken);
    } catch (e) {
      return null;
    }
  }

  static Future<void> saveToken(String token) async {
    await instance._ensureInitialized();
    await _prefs?.setString(keyToken, token);
  }

  static Future<void> removeToken() async {
    await instance._ensureInitialized();
    try {
      await _prefs?.remove(keyToken);
    } catch (e) {
      debugPrint('removeToken error: $e');
    }
  }

  static bool isLoggedIn() {
    final token = getToken();
    return token != null && token.isNotEmpty;
  }

  // ==================== Employee Data ====================

  static Map<String, dynamic>? getEmployee() {
    try {
      final data = _prefs?.getString(keyEmployee);
      if (data != null) {
        return jsonDecode(data) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<void> saveEmployee(Map<String, dynamic> employee) async {
    await instance._ensureInitialized();
    try {
      await _prefs?.setString(keyEmployee, jsonEncode(employee));
    } catch (e) {
      debugPrint('saveEmployee error: $e');
    }
  }

  static Future<void> removeEmployee() async {
    await instance._ensureInitialized();
    try {
      await _prefs?.remove(keyEmployee);
    } catch (e) {
      debugPrint('removeEmployee error: $e');
    }
  }

  // ==================== Clear All Auth Data ====================

  static Future<void> clearAll() async {
    await instance._ensureInitialized();
    try {
      await _prefs?.remove(keyToken);
      await _prefs?.remove(keyEmployee);
    } catch (e) {
      debugPrint('clearAll error: $e');
    }
  }

  // ==================== Language ====================

  static String getLanguage() {
    try {
      return _prefs?.getString(keyLanguage) ?? 'en_US';
    } catch (e) {
      return 'en_US';
    }
  }

  static Future<void> setLanguage(String value) async {
    await instance._ensureInitialized();
    try {
      await _prefs?.setString(keyLanguage, value);
    } catch (e) {
      debugPrint('setLanguage error: $e');
    }
  }

  // ==================== Dark Mode ====================

  static bool getDarkMode() {
    try {
      return _prefs?.getBool(keyDarkMode) ?? false;
    } catch (e) {
      return false;
    }
  }

  static Future<void> setDarkMode(bool value) async {
    await instance._ensureInitialized();
    try {
      await _prefs?.setBool(keyDarkMode, value);
    } catch (e) {
      debugPrint('setDarkMode error: $e');
    }
  }

  // ==================== Notifications ====================

  static bool getNotifications() {
    try {
      return _prefs?.getBool(keyNotifications) ?? true;
    } catch (e) {
      return true;
    }
  }

  static Future<void> setNotifications(bool value) async {
    await instance._ensureInitialized();
    try {
      await _prefs?.setBool(keyNotifications, value);
    } catch (e) {
      debugPrint('setNotifications error: $e');
    }
  }

  // ==================== Biometric ====================

  static bool getBiometric() {
    try {
      return _prefs?.getBool(keyBiometric) ?? false;
    } catch (e) {
      return false;
    }
  }

  static Future<void> setBiometric(bool value) async {
    await instance._ensureInitialized();
    try {
      await _prefs?.setBool(keyBiometric, value);
    } catch (e) {
      debugPrint('setBiometric error: $e');
    }
  }
}
