import 'api_client.dart';

class AuthApiService {
  final ApiClient _apiClient = ApiClient();

  // Login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        '/auth/login',
        body: {
          'email': email,
          'password': password,
        },
        requiresAuth: false, // No auth needed for login
      );

      // Save token
      if (response['token'] != null) {
        await _apiClient.setAuthToken(response['token']);
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Register
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await _apiClient.post(
        '/auth/register',
        body: {
          'email': email,
          'password': password,
          'name': name,
        },
        requiresAuth: false, // No auth needed for register
      );

      // Save token
      if (response['token'] != null) {
        await _apiClient.setAuthToken(response['token']);
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Refresh Token
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      final response = await _apiClient.post(
        '/auth/refresh-token',
        body: {
          'refreshToken': refreshToken,
        },
        requiresAuth: false,
      );

      // Update token
      if (response['token'] != null) {
        await _apiClient.setAuthToken(response['token']);
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _apiClient.post('/auth/logout');
      await _apiClient.clearAuthToken();
    } catch (e) {
      // Clear token even if request fails
      await _apiClient.clearAuthToken();
      rethrow;
    }
  }

  // Check if user is authenticated
  bool isAuthenticated() {
    return _apiClient.isAuthenticated;
  }

  // Get current auth token
  String? getAuthToken() {
    return _apiClient.authToken;
  }
  
  // Get user credit
  Future<int> getCredit() async {
    try {
      print('🔵 AuthAPI: Fetching user credit...');
      
      final response = await _apiClient.get('/Auth/credit');
      
      final credit = response['credit'] ?? 0;
      print('✅ AuthAPI: Credit fetched - $credit');
      
      return credit;
    } catch (e) {
      print('❌ AuthAPI: Failed to fetch credit - $e');
      return 0;
    }
  }
  
  // Get user subscription
  Future<Map<String, dynamic>> getSubscription() async {
    try {
      print('🔵 AuthAPI: Fetching user subscription...');
      
      final response = await _apiClient.get('/Auth/subscription');
      
      print('✅ AuthAPI: Subscription fetched - ${response['status']}');
      
      return response;
    } catch (e) {
      print('❌ AuthAPI: Failed to fetch subscription - $e');
      return {
        'status': 'None',
        'plan': null,
        'monthlyCredits': 0,
        'usedCredits': 0,
        'remainingCredits': 0,
        'daysRemaining': 0,
      };
    }
  }
  
  // Update measurements
  Future<String> updateMeasurements({
    required int height,
    required int weight,
    required int chest,
    required int waist,
    required int hips,
    required int shoulderWidth,
  }) async {
    try {
      print('🔵 AuthAPI: Updating measurements...');
      
      final response = await _apiClient.post('/Auth/measurements', body: {
        'height': height,
        'weight': weight,
        'chest': chest,
        'waist': waist,
        'hips': hips,
        'shoulderWidth': shoulderWidth,
      });
      
      final recommendedSize = response['recommendedSize'] ?? 'M';
      print('✅ AuthAPI: Measurements updated - Size: $recommendedSize');
      
      return recommendedSize;
    } catch (e) {
      print('❌ AuthAPI: Failed to update measurements - $e');
      return 'M'; // Default size
    }
  }
  
  // Get notification settings
  Future<Map<String, dynamic>> getNotificationSettings() async {
    try {
      print('🔵 AuthAPI: Fetching notification settings...');
      
      final response = await _apiClient.get('/Auth/notifications/settings');
      
      print('✅ AuthAPI: Notification settings fetched');
      
      return response;
    } catch (e) {
      print('❌ AuthAPI: Failed to fetch notification settings - $e');
      return {
        'creditAlert': true,
        'priceDrop': true,
        'stockAlert': true,
        'newFeatures': true,
      };
    }
  }
  
  // Update notification settings
  Future<bool> updateNotificationSettings({
    required bool creditAlert,
    required bool priceDrop,
    required bool stockAlert,
    required bool newFeatures,
  }) async {
    try {
      print('🔵 AuthAPI: Updating notification settings...');
      
      await _apiClient.post('/Auth/notifications/settings', body: {
        'creditAlert': creditAlert,
        'priceDrop': priceDrop,
        'stockAlert': stockAlert,
        'newFeatures': newFeatures,
      });
      
      print('✅ AuthAPI: Notification settings updated');
      
      return true;
    } catch (e) {
      print('❌ AuthAPI: Failed to update notification settings - $e');
      return false;
    }
  }
}
