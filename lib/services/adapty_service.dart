import 'package:adapty_flutter/adapty_flutter.dart';
import '../config/env_config.dart';

class AdaptyService {
  static final AdaptyService _instance = AdaptyService._internal();
  factory AdaptyService() => _instance;
  AdaptyService._internal();

  // Adapty Public Key from config
  static String get _publicKey => EnvConfig.adaptyPublicKey;

  bool _isInitialized = false;

  /// Initialize Adapty SDK
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      print('🔵 Adapty: Initializing...');
      
      await Adapty().activate(
        configuration: AdaptyConfiguration(apiKey: _publicKey)
          ..withLogLevel(AdaptyLogLevel.verbose)
          ..withObserverMode(false)
          ..withCustomerUserId(null),
      );

      _isInitialized = true;
      print('✅ Adapty: Initialized successfully');
    } catch (e) {
      print('❌ Adapty: Initialization failed - $e');
      rethrow;
    }
  }

  /// Identify user
  Future<void> identifyUser(String userId) async {
    try {
      print('🔵 Adapty: Identifying user $userId...');
      
      await Adapty().identify(userId);
      
      print('✅ Adapty: User identified');
    } catch (e) {
      print('❌ Adapty: Failed to identify user - $e');
    }
  }

  /// Get paywalls
  Future<AdaptyPaywall?> getPaywall(String placementId) async {
    try {
      print('🔵 Adapty: Fetching paywall $placementId...');
      
      final paywall = await Adapty().getPaywall(placementId: placementId);
      
      print('✅ Adapty: Paywall fetched');
      return paywall;
    } catch (e) {
      print('❌ Adapty: Failed to fetch paywall - $e');
      return null;
    }
  }

  /// Get products
  Future<List<AdaptyPaywallProduct>> getProducts(AdaptyPaywall paywall) async {
    try {
      print('🔵 Adapty: Fetching products...');
      
      final products = await Adapty().getPaywallProducts(paywall: paywall);
      
      print('✅ Adapty: ${products.length} products fetched');
      return products;
    } catch (e) {
      print('❌ Adapty: Failed to fetch products - $e');
      return [];
    }
  }

  /// Make purchase
  Future<bool> makePurchase(AdaptyPaywallProduct product) async {
    try {
      print('🔵 Adapty: Making purchase...');
      
      final result = await Adapty().makePurchase(product: product);
      
      print('✅ Adapty: Purchase successful');
      print('📦 Result: $result');
      return true;
    } catch (e) {
      print('❌ Adapty: Purchase failed - $e');
      return false;
    }
  }

  /// Restore purchases
  Future<AdaptyProfile?> restorePurchases() async {
    try {
      print('🔵 Adapty: Restoring purchases...');
      
      final profile = await Adapty().restorePurchases();
      
      print('✅ Adapty: Purchases restored');
      return profile;
    } catch (e) {
      print('❌ Adapty: Failed to restore purchases - $e');
      return null;
    }
  }

  /// Get profile
  Future<AdaptyProfile?> getProfile() async {
    try {
      print('🔵 Adapty: Fetching profile...');
      
      final profile = await Adapty().getProfile();
      
      print('✅ Adapty: Profile fetched');
      return profile;
    } catch (e) {
      print('❌ Adapty: Failed to fetch profile - $e');
      return null;
    }
  }

  /// Check if user has active subscription
  Future<bool> hasActiveSubscription(String accessLevelId) async {
    try {
      final profile = await getProfile();
      
      if (profile == null) return false;
      
      final accessLevel = profile.accessLevels[accessLevelId];
      
      return accessLevel?.isActive ?? false;
    } catch (e) {
      print('❌ Adapty: Failed to check subscription - $e');
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      print('🔵 Adapty: Logging out...');
      
      await Adapty().logout();
      
      print('✅ Adapty: Logged out');
    } catch (e) {
      print('❌ Adapty: Logout failed - $e');
    }
  }
}
