import 'package:vlad_diplome/data/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class App {
  static const String appName = "БелСтройСервис";
  static String platform = defaultTargetPlatform.name;

  static const appPadding = EdgeInsets.only(
    right: 26, left: 26, top: 26
  );

  static setupBar(bool isLight) => SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarBrightness: isLight ? Brightness.light : Brightness.dark,
      statusBarIconBrightness: isLight ? Brightness.dark : Brightness.light,
      statusBarColor: isLight ? const Color(0x00000000) : Colors.transparent,
      systemNavigationBarColor: isLight ? colorLight : colorDark,
    ),
  );
}
