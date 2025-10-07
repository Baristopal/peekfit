import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api/api_client.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('en'); // Default English
  final ApiClient _apiClient = ApiClient();

  Locale get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('languageCode') ?? 'en';
    _locale = Locale(languageCode);
    
    // Set language in API client
    _apiClient.setLanguage(languageCode);
    
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    
    _locale = locale;
    
    // Update API client language
    _apiClient.setLanguage(locale.languageCode);
    
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);
  }

  void toggleLocale() {
    if (_locale.languageCode == 'tr') {
      setLocale(const Locale('en'));
    } else {
      setLocale(const Locale('tr'));
    }
  }
}
