import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_client.dart';
import '../../models/clothing_item.dart';

class WardrobeApiService {
  final ApiClient _apiClient = ApiClient();

  // Get user ID from storage
  Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user_data');
    if (userJson != null) {
      final userData = jsonDecode(userJson);
      return userData['id'];
    }
    return null;
  }

  // Get all wardrobe items
  Future<List<ClothingItem>> getAll() async {
    try {
      print('🔵 WardrobeAPI: Fetching all items...');
      
      final response = await _apiClient.get('/Wardrobe');
      
      print('✅ WardrobeAPI: Items fetched successfully');
      print('📦 Response: $response');
      
      // Parse response to list of ClothingItem
      final List<dynamic> itemsJson = response is List ? response : (response['items'] ?? []);
      final items = itemsJson.map((json) => ClothingItem.fromJson(json)).toList();
      
      print('📦 WardrobeAPI: ${items.length} items loaded');
      return items;
    } catch (e) {
      print('❌ WardrobeAPI: Failed to fetch items - $e');
      rethrow;
    }
  }

  // Get single item by ID
  Future<ClothingItem> get(String id) async {
    try {
      print('🔵 WardrobeAPI: Fetching item $id...');
      
      final response = await _apiClient.get('/Wardrobe/$id');
      
      print('✅ WardrobeAPI: Item fetched successfully');
      return ClothingItem.fromJson(response);
    } catch (e) {
      print('❌ WardrobeAPI: Failed to fetch item - $e');
      rethrow;
    }
  }

  // Add new item
  Future<ClothingItem> add(ClothingItem item) async {
    try {
      print('🔵 WardrobeAPI: Adding new item...');
      print('📤 Item: ${item.name}');
      
      // Get user ID
      final userId = await _getUserId();
      if (userId == null) {
        throw Exception('User not logged in');
      }
      print('👤 User ID: $userId');
      
      // Add userId to item JSON
      final itemJson = item.toJson();
      itemJson['UserId'] = userId;
      
      final response = await _apiClient.post(
        '/Wardrobe',
        body: itemJson,
      );
      
      print('✅ WardrobeAPI: Item added successfully');
      return ClothingItem.fromJson(response);
    } catch (e) {
      print('❌ WardrobeAPI: Failed to add item - $e');
      rethrow;
    }
  }

  // Update item
  Future<ClothingItem> update(String id, ClothingItem item) async {
    try {
      print('🔵 WardrobeAPI: Updating item $id...');
      
      // Get user ID
      final userId = await _getUserId();
      if (userId == null) {
        throw Exception('User not logged in');
      }
      
      // Backend only accepts these fields for update
      final body = {
        'Id': id,
        'Name': item.name,
        'UserId': userId,
        'ClothingUrl': item.clothingUrl ?? '',
        'ImageUrl': item.imageUrl ?? '',
        'ClothingType': item.category,
        'Brand': item.brand ?? '',
        'Price': item.price,
        'ProductUrl': item.productUrl ?? '',
        'AddedAt': item.addedDate.toUtc().toIso8601String(),
      };
      
      print('📤 Update body: $body');
      
      final response = await _apiClient.put(
        '/Wardrobe/$id',
        body: body,
      );
      
      print('✅ WardrobeAPI: Item updated successfully');
      return ClothingItem.fromJson(response);
    } catch (e) {
      print('❌ WardrobeAPI: Failed to update item - $e');
      rethrow;
    }
  }

  // Delete item
  Future<void> delete(String id) async {
    try {
      print('🔵 WardrobeAPI: Deleting item $id...');
      
      await _apiClient.delete('/Wardrobe/$id');
      
      print('✅ WardrobeAPI: Item deleted successfully');
    } catch (e) {
      print('❌ WardrobeAPI: Failed to delete item - $e');
      rethrow;
    }
  }

  // Search items
  Future<List<ClothingItem>> search(String query) async {
    try {
      print('🔵 WardrobeAPI: Searching items: $query');
      
      final response = await _apiClient.get('/Wardrobe/search?q=$query');
      
      final List<dynamic> itemsJson = response is List ? response : (response['items'] ?? []);
      final items = itemsJson.map((json) => ClothingItem.fromJson(json)).toList();
      
      print('✅ WardrobeAPI: ${items.length} items found');
      return items;
    } catch (e) {
      print('❌ WardrobeAPI: Failed to search items - $e');
      rethrow;
    }
  }
}
