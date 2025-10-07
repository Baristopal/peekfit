import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';
import 'api_exception.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  final http.Client _client = http.Client();
  String? _authToken;
  String _currentLanguage = 'en'; // Default language

  // Initialize token and language from storage
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString(ApiConfig.tokenKey);
    _currentLanguage = prefs.getString('languageCode') ?? 'en';
  }

  // Set language
  void setLanguage(String languageCode) {
    _currentLanguage = languageCode;
  }

  // Set and save auth token
  Future<void> setAuthToken(String token) async {
    _authToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ApiConfig.tokenKey, token);
  }

  // Clear auth token
  Future<void> clearAuthToken() async {
    _authToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(ApiConfig.tokenKey);
    await prefs.remove(ApiConfig.refreshTokenKey);
    await prefs.remove(ApiConfig.userIdKey);
  }

  // Get auth token
  String? get authToken => _authToken;

  // Check if authenticated
  bool get isAuthenticated => _authToken != null;

  // Get headers with language and auth
  Map<String, String> _getHeaders({bool includeAuth = true}) {
    final headers = Map<String, String>.from(ApiConfig.defaultHeaders);
    
    // Add UTF-8 charset for proper encoding
    headers['Content-Type'] = 'application/json; charset=utf-8';
    
    // Add language header
    headers['Accept-Language'] = _currentLanguage;
    
    // Add auth token if available and required
    if (includeAuth && _authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    
    return headers;
  }

  // GET request
  Future<dynamic> get(String endpoint, {bool requiresAuth = true}) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      
      final response = await _client
          .get(url, headers: _getHeaders(includeAuth: requiresAuth))
          .timeout(ApiConfig.receiveTimeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // POST request
  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      
      print('🌐 API POST: $url');
      print('📤 Headers: ${_getHeaders(includeAuth: requiresAuth)}');
      print('📤 Body: ${body != null ? jsonEncode(body) : 'null'}');
      
      // Encode body with UTF-8
      final encodedBody = body != null ? utf8.encode(jsonEncode(body)) : null;
      
      final response = await _client
          .post(
            url,
            headers: _getHeaders(includeAuth: requiresAuth),
            body: encodedBody,
          )
          .timeout(ApiConfig.receiveTimeout);

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      print('❌ API POST Error: $e');
      throw _handleError(e);
    }
  }

  // PUT request
  Future<dynamic> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      
      // Encode body with UTF-8
      final encodedBody = body != null ? utf8.encode(jsonEncode(body)) : null;
      
      final response = await _client
          .put(
            url,
            headers: _getHeaders(includeAuth: requiresAuth),
            body: encodedBody,
          )
          .timeout(ApiConfig.receiveTimeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE request
  Future<dynamic> delete(String endpoint, {bool requiresAuth = true}) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      
      final response = await _client
          .delete(url, headers: _getHeaders(includeAuth: requiresAuth))
          .timeout(ApiConfig.receiveTimeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Multipart request (for file uploads)
  Future<dynamic> multipart(
    String endpoint,
    String method, {
    Map<String, String>? fields,
    Map<String, String>? files,
    bool requiresAuth = true,
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final request = http.MultipartRequest(method, url);

      print('🌐 API MULTIPART: $url');
      print('📤 Method: $method');

      // Add headers
      request.headers.addAll(_getHeaders(includeAuth: requiresAuth));
      print('📤 Headers: ${request.headers}');

      // Add fields
      if (fields != null) {
        request.fields.addAll(fields);
        print('📤 Fields: $fields');
      }

      // Add files
      if (files != null) {
        for (var entry in files.entries) {
          final file = await http.MultipartFile.fromPath(
            entry.key,
            entry.value,
          );
          request.files.add(file);
          print('📤 File: ${entry.key} = ${entry.value} (${file.length} bytes)');
        }
      }

      print('🚀 Sending multipart request...');
      final streamedResponse = await request.send().timeout(ApiConfig.receiveTimeout);
      final response = await http.Response.fromStream(streamedResponse);

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      print('❌ API MULTIPART Error: $e');
      throw _handleError(e);
    }
  }

  // Handle response
  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    
    if (statusCode >= 200 && statusCode < 300) {
      // Success
      if (response.body.isEmpty) {
        return null;
      }
      return jsonDecode(response.body);
    } else if (statusCode == 401) {
      // Unauthorized - clear token
      clearAuthToken();
      throw UnauthorizedException('Session expired. Please login again.');
    } else if (statusCode == 403) {
      throw ForbiddenException('Access denied.');
    } else if (statusCode == 404) {
      throw NotFoundException('Resource not found.');
    } else if (statusCode >= 500) {
      throw ServerException('Server error. Please try again later.');
    } else {
      // Try to parse error message from response
      try {
        final errorData = jsonDecode(response.body);
        final message = errorData['message'] ?? errorData['error'] ?? 'Request failed';
        throw ApiException(message, statusCode);
      } catch (e) {
        throw ApiException('Request failed with status: $statusCode', statusCode);
      }
    }
  }

  // Handle errors
  Exception _handleError(dynamic error) {
    if (error is ApiException) {
      return error;
    } else if (error is http.ClientException) {
      return NetworkException('Network error. Please check your connection.');
    } else {
      return ApiException('An unexpected error occurred: ${error.toString}');
    }
  }

  // Dispose
  void dispose() {
    _client.close();
  }
}
