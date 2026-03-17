import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

enum Environment { dev, staging, prod }

class AppFlavorConfig {
  static void setupDev() {
    FlavorConfig(
      name: "DEV",
      color: Colors.red,
      location: BannerLocation.topStart,
      variables: {
        "appName": "Employee App (Dev)",
        "baseUrl": "http://universe.test", // Local development
        "environment": Environment.dev,
      },
    );
  }

  static void setupStaging() {
    FlavorConfig(
      name: "STAGING",
      color: Colors.orange,
      location: BannerLocation.topStart,
      variables: {
        "appName": "Employee App (Staging)",
        "baseUrl": "https://staging.uninversal-global.online",
        "environment": Environment.staging,
      },
    );
  }

  static void setupProd() {
    FlavorConfig(
      name: "",
      color: Colors.green,
      location: BannerLocation.topStart,
      variables: {
        "appName": "Employee App",
        "baseUrl": "https://uninversal-global.online",
        "environment": Environment.prod,
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
