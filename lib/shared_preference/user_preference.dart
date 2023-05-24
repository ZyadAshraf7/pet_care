


import 'package:pet_care/shared_preference/shared_preference.dart';

class UserPreferences {
  static final sharedPreferences = SharedPrefs.instance;

  static bool getLoginState() => sharedPreferences.getBool("loginState") ?? false;
  static bool getFirstTimeState() => sharedPreferences.getBool("firstTime") ?? true;

  static Future<void> keepUserLoggedIn() => sharedPreferences.setBool("loginState", true);
  static Future<void> logUserOut() => sharedPreferences.setBool("loginState", false);
  static Future<void> setFirstTimeTrue() => sharedPreferences.setBool("firstTime", true);
  static Future<void> setFirstTimeFalse() => sharedPreferences.setBool("firstTime", false);
}
