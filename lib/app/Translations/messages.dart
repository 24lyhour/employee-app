import 'package:get/get.dart';
import 'en.dart';
import 'km.dart';
import 'zh.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': en,
        'km_KH': km,
        'zh_CN': zh,
      };
}
