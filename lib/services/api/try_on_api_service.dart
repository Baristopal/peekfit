import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_client.dart';

enum TargetArea {
  upperBody(1),
  lowerBody(2),
  fullBody(3);

  final int value;
  const TargetArea(this.value);
}

class TryOnApiService {
  final ApiClient _apiClient = ApiClient();

  // Get user ID from storage
  Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user_data');
    if (userJson != null) {
      final userData = Map<String, dynamic>.from(jsonDecode(userJson));
      return userData['id'];
    }
    return null;
  }

  /// Try on clothing
  /// 
  /// [userImagePath] - Path to user's photo (required)
  /// [targetArea] - Which body area (UpperBody, LowerBody, FullBody) (required)
  /// [clothingUrl] - URL of the clothing (optional, use this OR clothingImagePath)
  /// [clothingImageUrl] - Image URL of the clothing (optional)
  /// [clothingImagePath] - Local path to clothing image (optional, use this OR clothingUrl)
  Future<Map<String, dynamic>> tryOn({
    required String userImagePath,
    required TargetArea targetArea,
    String? clothingUrl,
    String? clothingImageUrl,
    String? clothingImagePath,
  }) async {
    try {
      print('🔵 TryOnAPI: Starting virtual try-on...');
      print('📸 User Image: $userImagePath');
      print('🎯 Target Area: ${targetArea.name} (${targetArea.value})');

      // Get user ID
      final userId = await _getUserId();
      if (userId == null) {
        throw Exception('User not logged in');
      }
      print('👤 User ID: $userId');

      // Prepare files
      final files = <String, String>{
        'UserImage': userImagePath,
      };

      // Add clothing image if provided
      if (clothingImagePath != null) {
        files['TargetClothingImage'] = clothingImagePath;
        print('👕 Clothing Image (Local): $clothingImagePath');
      }

      // Prepare fields
      final fields = <String, String>{
        'UserId': userId,
        'TargetArea': targetArea.value.toString(),
      };

      // Add clothing URL if provided (optional)
      if (clothingUrl != null && clothingUrl.isNotEmpty) {
        fields['TargetClothingUrl'] = clothingUrl;
        print('👕 Clothing URL: $clothingUrl');
      }

      // Add clothing image URL if provided (optional)
      if (clothingImageUrl != null && clothingImageUrl.isNotEmpty) {
        fields['TargetClothingImageUrl'] = clothingImageUrl;
        print('👕 Clothing Image URL: $clothingImageUrl');
      }

      final response = await _apiClient.multipart(
        '/VirtualTryOn/try-on',
        'POST',
        files: files,
        fields: fields,
      );

      print('✅ TryOnAPI: Try-on completed successfully');
      print('📦 Response: $response');

      return response;
    } catch (e) {
      print('❌ TryOnAPI: Try-on failed - $e');
      rethrow;
    }
  }

  /// Get try-on history
  /// [page] - Page number (default: 1)
  /// [limit] - Items per page (default: 50)
  Future<Map<String, dynamic>> getHistory({int page = 1, int limit = 50}) async {
    try {
      print('🔵 TryOnAPI: Fetching try-on history...');
      print('📄 Page: $page, Limit: $limit');

      final response = await _apiClient.get('/VirtualTryOn/history?page=$page&limit=$limit');

      print('✅ TryOnAPI: History fetched successfully');

      // Backend response format:
      // {
      //   "items": [...],
      //   "totalCount": 50,
      //   "page": 1,
      //   "pageSize": 20,
      //   "totalPages": 3
      // }
      
      final items = response['items'] ?? response;
      final totalCount = response['totalCount'] ?? (items is List ? items.length : 0);
      
      print('📦 TryOnAPI: ${items is List ? items.length : 0} items in history (Total: $totalCount)');

      return {
        'items': items is List ? items : [items],
        'totalCount': totalCount,
        'page': response['page'] ?? page,
        'pageSize': response['pageSize'] ?? limit,
        'totalPages': response['totalPages'] ?? 1,
      };
    } catch (e) {
      print('❌ TryOnAPI: Failed to fetch history - $e');
      rethrow;
    }
  }

  /// Delete try-on from history
  Future<void> deleteHistory(String id) async {
    try {
      print('🔵 TryOnAPI: Deleting history item $id...');

      await _apiClient.delete('/VirtualTryOn/history/$id');

      print('✅ TryOnAPI: History item deleted');
    } catch (e) {
      print('❌ TryOnAPI: Failed to delete history - $e');
      rethrow;
    }
  }
}
