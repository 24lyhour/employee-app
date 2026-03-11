import 'package:app/app/config/flavor_config.dart';
import 'package:app/main.dart' as app;

void main() {
  AppFlavorConfig.setupProd();
  app.main();
}
