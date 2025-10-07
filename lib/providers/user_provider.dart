import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/subscription_model.dart';
import '../models/notification_settings.dart';
import '../services/api/auth_api_service.dart';
import '../services/api/api_client.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoggedIn = false;
  SubscriptionModel? _subscription;
  NotificationSettings? _notificationSettings;
  final AuthApiService _authService = AuthApiService();
  final ApiClient _apiClient = ApiClient();
  
  UserModel? get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  bool get hasMeasurements => _user?.measurements != null;
  int get credits => _user?.credits ?? 0;
  
  // Subscription getters
  SubscriptionModel? get subscription => _subscription;
  bool get hasActiveSubscription => _subscription?.isActive ?? false;
  bool get isSubscriptionExpired => _subscription?.isExpired ?? false;
  String get subscriptionStatus => _subscription?.status ?? 'None';
  
  // Notification getters
  NotificationSettings? get notificationSettings => _notificationSettings;
  bool get isCreditAlertEnabled => _notificationSettings?.creditAlert ?? true;
  
  UserProvider() {
    _init();
  }
  
  Future<void> _init() async {
    // Initialize API client first to load token
    await _apiClient.init();
    await _loadUser();
  }
  
  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user_data');
    
    // Check if user has valid token
    final hasToken = _apiClient.isAuthenticated;
    _isLoggedIn = hasToken && userJson != null;
    
    print('🔵 UserProvider: Loading user...');
    print('📦 User JSON exists: ${userJson != null}');
    print('🔑 Has token: $hasToken');
    print('✅ Is logged in: $_isLoggedIn');
    
    if (userJson != null && hasToken) {
      _user = UserModel.fromJson(jsonDecode(userJson));
      print('✅ User loaded: ${_user?.email}');
    } else {
      // Clear invalid session
      _isLoggedIn = false;
      _user = null;
      print('❌ Invalid session, clearing user');
    }
    
    notifyListeners();
  }
  
  Future<void> _saveUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (_user != null) {
      await prefs.setString('user_data', jsonEncode(_user!.toJson()));
    }
    await prefs.setBool('is_logged_in', _isLoggedIn);
  }
  
  // Load credit from API
  Future<void> loadCredit() async {
    try {
      print('🔵 UserProvider: Loading credit...');
      
      final credit = await _authService.getCredit();
      
      if (_user != null) {
        _user = _user!.copyWith(credits: credit);
        await _saveUser();
        notifyListeners();
        
        print('✅ UserProvider: Credit updated - $credit');
      }
    } catch (e) {
      print('❌ UserProvider: Failed to load credit - $e');
    }
  }
  
  // Update credit locally
  void updateCredit(int newCredit) {
    if (_user != null) {
      _user = _user!.copyWith(credits: newCredit);
      _saveUser();
      notifyListeners();
    }
  }
  
  // Load subscription from API
  Future<void> loadSubscription() async {
    try {
      print('🔵 UserProvider: Loading subscription...');
      
      final response = await _authService.getSubscription();
      _subscription = SubscriptionModel.fromJson(response);
      
      notifyListeners();
      
      print('✅ UserProvider: Subscription loaded - ${_subscription?.status}');
    } catch (e) {
      print('❌ UserProvider: Failed to load subscription - $e');
    }
  }
  
  Future<void> login(String email, String password) async {
    try {
      print('🔵 UserProvider: Calling login API...');
      
      // Call API
      final response = await _authService.login(
        email: email,
        password: password,
      );
      
      print('✅ UserProvider: Login API response received');
      
      // Save refresh token
      if (response['refreshToken'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('refresh_token', response['refreshToken']);
      }
      
      // Parse user data from response
      final userData = response['user'];
      _user = UserModel(
        id: userData['id'].toString(),
        name: userData['name'] ?? userData['email'].split('@')[0],
        email: userData['email'],
      );
      
      _isLoggedIn = true;
      await _saveUser();
      print('✅ UserProvider: Login successful, isLoggedIn: $_isLoggedIn');
      notifyListeners();
    } catch (e) {
      print('❌ UserProvider: Login failed - $e');
      _isLoggedIn = false;
      _user = null;
      rethrow; // Let UI handle the error
    }
  }
  
  Future<void> register(String name, String email, String password) async {
    try {
      print('🔵 UserProvider: Calling register API...');
      print('📧 Email: $email');
      print('👤 Name: $name');
      
      // Call API
      final response = await _authService.register(
        email: email,
        password: password,
        name: name,
      );
      
      print('✅ UserProvider: Register API response received');
      print('📦 Response: $response');
      
      // Save refresh token
      if (response['refreshToken'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('refresh_token', response['refreshToken']);
      }
      
      // Parse user data from response
      final userData = response['user'];
      _user = UserModel(
        id: userData['id'].toString(),
        name: userData['name'] ?? name,
        email: userData['email'],
      );
      
      _isLoggedIn = true;
      await _saveUser();
      print('✅ UserProvider: User saved, isLoggedIn: $_isLoggedIn');
      notifyListeners();
    } catch (e) {
      print('❌ UserProvider: Register failed - $e');
      _isLoggedIn = false;
      _user = null;
      rethrow; // Let UI handle the error
    }
  }
  
  Future<void> logout() async {
    try {
      await _authService.logout();
    } catch (e) {
      // Continue with logout even if API call fails
    }
    
    _user = null;
    _isLoggedIn = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
    await prefs.setBool('is_logged_in', false);
    notifyListeners();
  }
  
  Future<void> updateMeasurements(UserMeasurements measurements) async {
    if (_user != null) {
      _user = UserModel(
        id: _user!.id,
        name: _user!.name,
        email: _user!.email,
        measurements: measurements,
      );
      await _saveUser();
      notifyListeners();
    }
  }
  
  Future<void> updateProfile(String name) async {
    if (_user != null) {
      _user = UserModel(
        id: _user!.id,
        name: name,
        email: _user!.email,
        measurements: _user!.measurements,
      );
      await _saveUser();
      notifyListeners();
    }
  }
  
  // Save measurements to backend
  Future<String> saveMeasurements({
    required int height,
    required int weight,
    required int chest,
    required int waist,
    required int hips,
    required int shoulderWidth,
  }) async {
    try {
      print('🔵 UserProvider: Saving measurements...');
      
      final recommendedSize = await _authService.updateMeasurements(
        height: height,
        weight: weight,
        chest: chest,
        waist: waist,
        hips: hips,
        shoulderWidth: shoulderWidth,
      );
      
      // Update local user model
      final measurements = UserMeasurements(
        height: height.toDouble(),
        weight: weight.toDouble(),
        chest: chest.toDouble(),
        waist: waist.toDouble(),
        hips: hips.toDouble(),
        recommendedSize: recommendedSize,
      );
      
      await updateMeasurements(measurements);
      
      print('✅ UserProvider: Measurements saved - Size: $recommendedSize');
      return recommendedSize;
    } catch (e) {
      print('❌ UserProvider: Failed to save measurements - $e');
      return 'M'; // Default size
    }
  }
  
  // Load notification settings from backend
  Future<void> loadNotificationSettings() async {
    try {
      print('🔵 UserProvider: Loading notification settings...');
      
      final response = await _authService.getNotificationSettings();
      _notificationSettings = NotificationSettings.fromJson(response);
      
      notifyListeners();
      
      print('✅ UserProvider: Notification settings loaded');
    } catch (e) {
      print('❌ UserProvider: Failed to load notification settings - $e');
      // Set defaults
      _notificationSettings = NotificationSettings(
        creditAlert: true,
        priceDrop: true,
        stockAlert: true,
        newFeatures: true,
      );
    }
  }
  
  // Update notification settings
  Future<bool> updateNotificationSettings(NotificationSettings settings) async {
    try {
      print('🔵 UserProvider: Updating notification settings...');
      
      final success = await _authService.updateNotificationSettings(
        creditAlert: settings.creditAlert,
        priceDrop: settings.priceDrop,
        stockAlert: settings.stockAlert,
        newFeatures: settings.newFeatures,
      );
      
      if (success) {
        _notificationSettings = settings;
        notifyListeners();
        print('✅ UserProvider: Notification settings updated');
      }
      
      return success;
    } catch (e) {
      print('❌ UserProvider: Failed to update notification settings - $e');
      return false;
    }
  }
}
