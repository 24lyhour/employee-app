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
        "baseUrl": "https://dev-api.example.com",
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
        "baseUrl": "https://staging-api.example.com",
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
        "baseUrl": "https://api.example.com",
        "environment": Environment.prod,
      },
    );
  }

  static String get appName => FlavorConfig.instance.variables["appName"];
  static String get baseUrl => FlavorConfig.instance.variables["baseUrl"];
  static Environment get environment => FlavorConfig.instance.variables["environment"];
  static bool get isDev => environment == Environment.dev;
  static bool get isStaging => environment == Environment.staging;
  static bool get isProd => environment == Environment.prod;
}
