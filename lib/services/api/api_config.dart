class ApiConfig {
  // Base URL
  // For Android Emulator: use 10.0.2.2 to access localhost
  // For iOS Simulator: use localhost or 127.0.0.1
  // For Production: use actual server URL
  
  static const bool useLocalApi = false; // Set to false for production
  
  static const String localBaseUrl = 'http://10.0.2.2:5001/api'; // Android Emulator (HTTP Port: 5001)
  static const String productionBaseUrl = 'https://peekfitbackend-production.up.railway.app/api';
  
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
