import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:get/get.dart';

import 'app/core/services/storage_service.dart';
import 'app/core/theme/app_theme.dart';
import 'app/routes/app_pages.dart';
import 'app/Translations/messages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Locale _getSavedLocale() {
    final lang = StorageService.getLanguage();
    final parts = lang.split('_');
    return Locale(parts[0], parts.length > 1 ? parts[1] : '');
  }

  ThemeMode _getSavedThemeMode() {
    return StorageService.getDarkMode() ? ThemeMode.dark : ThemeMode.light;
  }

  @override
  Widget build(BuildContext context) {
    return FlavorBanner(
      child: GetMaterialApp(
        title: 'Employee App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: _getSavedThemeMode(),
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        translations: Messages(),
        locale: _getSavedLocale(),
        fallbackLocale: const Locale('en', 'US'),
      ),
    );
  }
}
