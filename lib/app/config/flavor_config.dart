import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

enum Environment { dev, staging, prod }

class AppFlavorConfig {
  static Future<void> setupDev() async {
    await dotenv.load(fileName: ".env.dev");
    _setupFlavor(
      name: "DEV",
      color: Colors.red,
      environment: Environment.dev,
    );
  }

  static Future<void> setupStaging() async {
    await dotenv.load(fileName: ".env.staging");
    _setupFlavor(
      name: "STAGING",
      color: Colors.orange,
      environment: Environment.staging,
    );
  }

  static Future<void> setupProd() async {
    await dotenv.load(fileName: ".env.prod");
    _setupFlavor(
      name: "",
      color: Colors.green,
      environment: Environment.prod,
    );
  }

  static void _setupFlavor({
    required String name,
    required Color color,
    required Environment environment,
  }) {
    FlavorConfig(
      name: name,
      color: color,
      location: BannerLocation.topStart,
      variables: {
        "appName": dotenv.env['APP_NAME'] ?? 'Employee App',
        "baseUrl": dotenv.env['BASE_URL'] ?? '',
        "environment": environment,
      },
    );
  }

  static String get appName => FlavorConfig.instance.variables["appName"];
  static String get baseUrl => FlavorConfig.instance.variables["baseUrl"];
  static Environment get environment =>
      FlavorConfig.instance.variables["environment"];
  static bool get isDev => environment == Environment.dev;
  static bool get isStaging => environment == Environment.staging;
  static bool get isProd => environment == Environment.prod;
}
