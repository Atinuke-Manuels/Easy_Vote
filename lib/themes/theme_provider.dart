// import 'package:chat_with_me/themes/dark_mode.dart';
// import 'package:chat_with_me/themes/light_mode.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
//
//
// class ThemeProvider extends ChangeNotifier {
//   ThemeData _themeData = lightMode;
//
//   ThemeData get themeData => _themeData;
//
//   bool get isDarkMode => _themeData == darkMode;
//
//   set themeData(ThemeData themeData) {
//     _themeData = themeData;
//     notifyListeners();
//   }
//
//   void toggleTheme(){
//     if(_themeData == lightMode){
//       themeData = darkMode;
//     }else{
//       themeData = lightMode;
//     }
//   }
//
// }

import 'package:flutter/material.dart';

import 'dark_mode.dart';
import 'light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeData _themeData;

  ThemeProvider() {
    // Check the system theme and set the initial theme accordingly
    final brightness = WidgetsBinding.instance.window.platformBrightness;
    _themeData = brightness == Brightness.dark ? darkMode : lightMode;
  }

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }

  // Optional: Add a method to sync with the system theme dynamically
  void updateSystemTheme() {
    final brightness = WidgetsBinding.instance.window.platformBrightness;
    themeData = brightness == Brightness.dark ? darkMode : lightMode;
  }


  // app logo
  String get logoAsset {
    return isDarkMode ? 'assets/logo_white.png' : 'assets/logo_white.png';
  }

}


