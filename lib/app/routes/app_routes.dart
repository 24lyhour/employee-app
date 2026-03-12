part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const LOGIN = _Paths.LOGIN;
  static const REGISTER = _Paths.REGISTER;
  static const MAIN = _Paths.MAIN;
  static const HOME = _Paths.HOME;
  static const ATTENDANCE = _Paths.ATTENDANCE;
  static const HISTORY = _Paths.HISTORY;
  static const PROFILE = _Paths.PROFILE;
  static const SCANNER = _Paths.SCANNER;
}

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const MAIN = '/main';
  static const HOME = '/home';
  static const ATTENDANCE = '/attendance';
  static const HISTORY = '/history';
  static const PROFILE = '/profile';
  static const SCANNER = '/scanner';
}
