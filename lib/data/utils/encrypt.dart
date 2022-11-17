import 'dart:math';

class Encryption{
  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890_-';
  static final Random _rnd = Random();

  static String generateHash(String val){
    return "${getRandomString(150)}?$val?${getRandomString(20)}";
  }

  static String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}