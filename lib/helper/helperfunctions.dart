import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions{

  //saving your data to prefs for future use

  static String sharedPreferenceUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPreferenceUserNameKey = "USERNAMEKEY";
  static String sharedPreferenceUserEmailKey = "USEREMAILKEY";

  static Future<bool> saveUserLoggedInSharedPref(bool isLoggedIn) async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    return  sharedPrefs.setBool(sharedPreferenceUserLoggedInKey, isLoggedIn);
  }

  static Future<bool> saveUserNameSharedPref(String userName) async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    return  sharedPrefs.setString(sharedPreferenceUserNameKey, userName);
  }

  static Future<bool> saveUserEmailSharedPref(String email) async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    return  sharedPrefs.setString(sharedPreferenceUserEmailKey, email);
  }

  // get data from shared prefs
  static Future<bool> getUserLoggedInSharedPref() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    return sharedPrefs.getBool(sharedPreferenceUserLoggedInKey);
    
  }

  static Future<String> getUserNameSharedPref() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    return sharedPrefs.getString(sharedPreferenceUserNameKey);
  }
  static Future<String> getUserEmailSharedPref() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    return sharedPrefs.getString(sharedPreferenceUserEmailKey);
  }

}