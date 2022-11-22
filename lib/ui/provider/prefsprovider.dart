import 'dart:ui';
import 'package:vlad_diplome/data/model/preferences.dart';
import 'package:vlad_diplome/data/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceProvider extends ChangeNotifier {
  SharedPreferences? sp;

  String? currentTheme;

  PreferenceProvider() {
    _loadFromPrefs();
  }

  _initPrefs() async {
    sp ??= await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    if (sp!.getString(keyThemeMode) == null) await sp!.setString(keyThemeMode, "light");
    currentTheme = sp!.getString(keyThemeMode);
    notifyListeners();
  }

  savePreference(String key, value) async {
    await _initPrefs();
    switch (key) {
      case keyThemeMode:
        sp!.setString(key, value);
        currentTheme = sp!.getString(keyThemeMode);
        break;
    }
    notifyListeners();
  }
}
