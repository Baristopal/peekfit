import '../../config/env_config.dart';

class ApiConfig {
  // Base URL from config
  static String get localBaseUrl => EnvConfig.apiLocalUrl;
  static String get productionBaseUrl => EnvConfig.apiBaseUrl;
  static bool get useLocalApi => EnvConfig.useLocalApi;
  
  static String get baseUrl => useLocalApi ? localBaseUrl : productionBaseUrl;
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 60);
  static const Duration receiveTimeout = Duration(seconds: 120); // Try-on can take longer
  
  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  }; 
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
}
