import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/clothing_item.dart';
import '../models/try_on_history.dart';
import '../models/user_model.dart';
import '../services/api/wardrobe_api_service.dart';
import '../services/api/try_on_api_service.dart';

class WardrobeProvider extends ChangeNotifier {
  List<ClothingItem> _wardrobeItems = [];
  List<TryOnHistory> _history = [];
  final WardrobeApiService _apiService = WardrobeApiService();
  final TryOnApiService _tryOnApiService = TryOnApiService();
  bool _isLoading = false;
  int _historyTotalCount = 0;
  int _historyCurrentPage = 1;
  
  List<ClothingItem> get wardrobeItems => _wardrobeItems;
  List<TryOnHistory> get history => _history;
  bool get isLoading => _isLoading;
  int get historyTotalCount => _historyTotalCount;
  
  List<ClothingItem> get itemsNeedingLink => 
      _wardrobeItems.where((item) => item.needsProductLink).toList();
  
  int get itemsNeedingLinkCount => itemsNeedingLink.length;
  
  WardrobeProvider() {
    loadWardrobe();
  }
  
  // Load wardrobe from API
  Future<void> loadWardrobe() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      print('🔵 WardrobeProvider: Loading wardrobe from API...');
      _wardrobeItems = await _apiService.getAll();
      
      print('✅ WardrobeProvider: ${_wardrobeItems.length} items loaded');
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('❌ WardrobeProvider: Failed to load wardrobe - $e');
      _isLoading = false;
      _wardrobeItems = []; // Empty list on error
      notifyListeners();
    }
  }
  
  Future<void> addToWardrobe(ClothingItem item) async {
    try {
      print('🔵 WardrobeProvider: Adding item to wardrobe...');
      
      final addedItem = await _apiService.add(item);
      
      _wardrobeItems.add(addedItem);
      
      print('✅ WardrobeProvider: Item added to wardrobe');
      notifyListeners();
    } catch (e) {
      print('❌ WardrobeProvider: Failed to add item - $e');
      rethrow;
    }
  }
  
  Future<void> removeFromWardrobe(String itemId) async {
    try {
      print('🔵 WardrobeProvider: Deleting item $itemId...');
      
      await _apiService.delete(itemId);
      
      _wardrobeItems.removeWhere((item) => item.id == itemId);
      
      print('✅ WardrobeProvider: Item deleted');
      notifyListeners();
    } catch (e) {
      print('❌ WardrobeProvider: Failed to delete item - $e');
      rethrow;
    }
  }
  
  Future<void> updateItem(ClothingItem item) async {
    try {
      print('🔵 WardrobeProvider: Updating item ${item.id}...');
      
      final updatedItem = await _apiService.update(item.id, item);
      
      final index = _wardrobeItems.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        _wardrobeItems[index] = updatedItem;
        
        print('✅ WardrobeProvider: Item updated');
        notifyListeners();
      }
    } catch (e) {
      print('❌ WardrobeProvider: Failed to update item - $e');
      rethrow;
    }
  }
  
  // Load history from API (first page)
  Future<void> loadHistory() async {
    try {
      print('🔵 WardrobeProvider: Loading history from API...');
      
      _historyCurrentPage = 1;
      final result = await _tryOnApiService.getHistory(page: 1, limit: 50);
      
      _historyTotalCount = result['totalCount'] ?? 0;
      final items = result['items'] as List;
      
      // Convert to TryOnHistory objects
      _history = _convertHistoryItems(items);
      
      print('✅ WardrobeProvider: ${_history.length} history items loaded (Total: $_historyTotalCount)');
      notifyListeners();
    } catch (e) {
      print('❌ WardrobeProvider: Failed to load history - $e');
      _history = [];
      _historyTotalCount = 0;
      notifyListeners();
    }
  }

  // Load more history (next page)
  Future<void> loadMoreHistory() async {
    try {
      print('🔵 WardrobeProvider: Loading more history...');
      
      _historyCurrentPage++;
      final result = await _tryOnApiService.getHistory(page: _historyCurrentPage, limit: 50);
      
      final items = result['items'] as List;
      final newItems = _convertHistoryItems(items);
      
      _history.addAll(newItems);
      
      print('✅ WardrobeProvider: ${newItems.length} more items loaded (Total: ${_history.length}/$_historyTotalCount)');
      notifyListeners();
    } catch (e) {
      print('❌ WardrobeProvider: Failed to load more history - $e');
      _historyCurrentPage--; // Revert page increment
    }
  }

  // Helper method to convert API items to TryOnHistory
  List<TryOnHistory> _convertHistoryItems(List items) {
    return items.map((item) {
      // Map clothingType to proper category
      String category = 'other';
      String name = 'Try-On';
      
      final clothingType = item['clothingType']?.toString().toLowerCase() ?? '';
      if (clothingType.contains('shirt') || clothingType.contains('tshirt')) {
        category = 'tshirt';
        name = 'T-Shirt';
      } else if (clothingType.contains('dress')) {
        category = 'dress';
        name = 'Dress';
      } else if (clothingType.contains('pants') || clothingType.contains('jean')) {
        category = 'pants';
        name = 'Pants';
      } else if (clothingType.contains('jacket')) {
        category = 'jacket';
        name = 'Jacket';
      }
      
      final clothingItem = ClothingItem(
        id: item['id'] ?? '',
        name: name,
        imageUrl: item['generatedImageUrl'] ?? item['resultImageUrl'], // Result image for history
        category: category,
        clothingUrl: item['clothingImageUrl'] ?? item['clothingUrl'], // Original clothing
        addedDate: DateTime.parse(item['createdAt'] ?? DateTime.now().toIso8601String()),
      );
      
      return TryOnHistory(
        id: item['id'] ?? '',
        item: clothingItem,
        triedOnDate: DateTime.parse(item['createdAt'] ?? DateTime.now().toIso8601String()),
        addedToWardrobe: false,
      );
    }).toList();
  }
  
  Future<void> addToHistory(TryOnHistory historyItem) async {
    _history.insert(0, historyItem);
    _historyTotalCount++;
    
    // Save history to local storage
    final prefs = await SharedPreferences.getInstance();
    final historyJson = jsonEncode(_history.map((item) => item.toJson()).toList());
    await prefs.setString('try_on_history', historyJson);
    
    notifyListeners();
  }
  
  Future<void> clearHistory() async {
    // TODO: Call API to clear history
    _history.clear();
    _historyTotalCount = 0;
    
    // Clear from local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('try_on_history');
    
    notifyListeners();
  }
  
  ClothingItem? getItemById(String id) {
    try {
      return _wardrobeItems.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }
  
  List<ClothingItem> getItemsByCategory(String category) {
    return _wardrobeItems.where((item) => item.category == category).toList();
  }
}
