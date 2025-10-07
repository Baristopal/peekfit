import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // App
      'appName': 'PeekFit',
      
      // Navigation
      'navHome': 'Home',
      'navWardrobe': 'Wardrobe',
      'navHistory': 'History',
      'navProfile': 'Profile',
      
      // Home
      'homeTitle': 'PeekFit',
      'homeWarningTitle': 'Add Product Links',
      'homeWarningDesc': 'items in your wardrobe need product links',
      'homeWarningButton': 'Add Now',
      'homeRecentTitle': 'Recent Try-Ons',
      'homeViewAll': 'View All',
      'homeNoHistory': 'No try-on history yet',
      'homeNoHistoryDesc': 'Start trying on clothes to see your history here',
      'homeTryNow': 'Try Now',
      'homeRecommendedTitle': 'You Can Try These',
      'homeViewAllButton': 'All',
      'homePreviousTitle': 'Previously Tried',
      'homeNoTryOnYet': 'You haven\'t tried any clothes yet',
      'homeNoTryOnDesc': 'Click the button above to start',
      
      // Try-On
      'tryOnTitle': 'Virtual Try-On',
      'tryOnUpload': 'Upload Your Photo',
      'tryOnCamera': 'Take Photo',
      'tryOnGallery': 'Choose from Gallery',
      'tryOnResult': 'Try-On Result',
      'tryOnSuccess': 'Try-On Successful!',
      'tryOnSuccessDesc': 'See how it looks on you',
      'tryOnAgain': 'Try Again',
      'shareText': 'Check out my virtual try-on with PeekFit! 👗✨',
      'tryOnYourPhoto': 'Your Photo',
      'tryOnClothingImage': 'Clothing Image',
      'tryOnTapToSelect': 'Tap to select',
      'tryOnCategory': 'Clothing Category',
      'tryOnUpperBody': 'Upper Body',
      'tryOnLowerBody': 'Lower Body',
      'tryOnFullBody': 'Full Body',
      'tryOnStartButton': 'Start Try-On',
      'tryOnProcessing': 'Processing...',
      'tryOnPhotoSelect': 'Select Photo',
      'tryOnErrorNoPhoto': 'Please upload a photo',
      'tryOnErrorNoClothing': 'Please add clothing image',
      'tryOnCamera': 'Camera',
      'tryOnCameraDesc': 'Take a photo',
      'tryOnGallery': 'Gallery',
      'tryOnGalleryDesc': 'Choose from gallery',
      'tryOnUrlPlaceholder': 'Paste clothing URL here...',
      
      // Wardrobe
      'wardrobeTitle': 'My Wardrobe',
      'wardrobeSearch': 'Search product...',
      'wardrobeAll': 'All',
      'wardrobeEmpty': 'Your wardrobe is empty',
      'wardrobeEmptyDesc': 'Add clothes to start organizing',
      'wardrobeAddItem': 'Add Item',
      
      // Categories
      'categoryUpperBody': 'Upper Body',
      'categoryLowerBody': 'Lower Body',
      'categoryDresses': 'Dresses',
      'categoryOuterwear': 'Outerwear',
      'categoryShoes': 'Shoes',
      'categoryAccessories': 'Accessories',
      'categoryTShirt': 'T-Shirt',
      'categoryShirt': 'Shirt',
      'categoryPants': 'Pants',
      'categoryDress': 'Dress',
      'categoryJacket': 'Jacket',
      'categoryShoe': 'Shoe',
      'categoryAccessory': 'Accessory',
      'categoryOther': 'Other',
      
      // Add to Wardrobe Dialog
      'addToWardrobeTitle': 'Add to Wardrobe',
      'addToWardrobeProductName': 'Product Name',
      'addToWardrobeBrand': 'Brand',
      'addToWardrobePrice': 'Price',
      'addToWardrobeProductLink': 'Product Link',
      'addToWardrobeCategory': 'Category',
      'addToWardrobeCancel': 'Cancel',
      'addToWardrobeSave': 'Save',
      'addToWardrobeNameHint': 'e.g. White T-Shirt',
      'addToWardrobeBrandHint': 'e.g. Nike',
      'addToWardrobePriceHint': 'e.g. ₺299',
      'addToWardrobeLinkHint': 'https://...',
      
      // Profile
      'profileTitle': 'Profile',
      'profileSettings': 'Settings',
      'profileMeasurements': 'My Measurements',
      'profileMeasurementsDesc': 'Recommended size:',
      'profileMeasurementsMissing': 'Add your measurements',
      'profileMissingLabel': 'Missing',
      'profileDarkMode': 'Dark Theme',
      'profileDarkModeOn': 'On',
      'profileDarkModeOff': 'Off',
      'profileNotifications': 'Notifications',
      'profileNotificationsDesc': 'Manage notification preferences',
      'profileLanguage': 'Language',
      'profileAbout': 'About',
      'profileAboutApp': 'About App',
      'profileVersion': 'Version 1.0.0',
      'profilePrivacy': 'Privacy Policy',
      'profileTerms': 'Terms of Service',
      'profileLogout': 'Logout',
      'privacyContent': 'PeekFit Privacy Policy\n\nWe value your privacy. This app collects minimal personal data necessary for providing virtual try-on services.\n\n• Photos are processed securely and not stored permanently\n• User data is encrypted and protected\n• We do not share your data with third parties\n• You can delete your account and data anytime\n\nFor more information, contact us at privacy@peekfit.com',
      'termsContent': 'PeekFit Terms of Service\n\nBy using this app, you agree to:\n\n• Use the service for personal, non-commercial purposes\n• Not misuse or abuse the virtual try-on feature\n• Respect intellectual property rights\n• Accept that AI-generated results may vary\n\nWe reserve the right to:\n• Modify or discontinue services\n• Update pricing and subscription plans\n• Terminate accounts that violate terms\n\nLast updated: January 2025',
      
      // Subscription
      'subTitle': 'Choose Your Plan',
      'subHeader': 'For Unlimited Try-Ons',
      'subDesc': 'Choose your plan and start trying on clothes with AI',
      'subStarter': 'Starter',
      'subPro': 'Pro',
      'subBusiness': 'Business',
      'subPopular': 'MOST POPULAR',
      'subCreditsPerMonth': 'credits/month',
      'subContinue': 'Continue',
      'subPlanActive': 'Active',
      'subRenewal': 'Renewal:',
      'subDaysLater': 'days later',
      'subAddCredit': 'Add Credit',
      'subChangePlan': 'Change Plan',
      'subPerMonth': '/month',
      'subSelected': 'selected',
      
      // Credit Purchase
      'creditPurchaseTitle': 'Buy Additional Credits',
      'creditCurrentTitle': 'Your Current Credits',
      'creditCurrentAmount': 'Credits',
      'creditPackagesTitle': 'Credit Packages',
      'creditPackagesDesc': 'Special discounted prices for Pro subscribers',
      'creditDiscount10': '10% Discount',
      'creditDiscount20': '20% Discount',
      'creditPerCredit': '/credit',
      'creditInfoText': 'Purchased credits never expire and will be added to your current balance.',
      'creditBuyButton': 'Buy',
      
      // Credit History
      'creditHistoryTitle': 'Credit History',
      'creditHistoryTotal': 'Total Credits',
      'creditHistoryThisMonth': 'This Month',
      'creditHistoryUsed': 'Used',
      
      // History Screen
      'historyClearTitle': 'Clear History',
      'historyClearConfirm': 'Are you sure you want to delete all your try-on history?',
      'historyClearButton': 'Clear',
      'historyCleared': 'History cleared',
      'historyToday': 'Today',
      'historyYesterday': 'Yesterday',
      
      // Wardrobe Detail
      'wardrobeChangesSaved': 'Changes saved',
      'wardrobeDeleteTitle': 'Delete Item',
      'wardrobeDeleteConfirm': 'Are you sure you want to remove this item from your wardrobe?',
      'wardrobeDeleteButton': 'Delete',
      'wardrobeItemDeleted': 'Item deleted',
      'wardrobeSaveButton': 'Save',
      'wardrobeProductLink': 'Product Link',
      
      // Try-On Errors
      'tryOnPhotoError': 'Photo selection failed',
      'tryOnFailed': 'Try-on failed',
      'error': 'Error',
      
      // Auth
      'authAcceptTerms': 'Please accept the terms of use',
      'authRegisterFailed': 'Registration failed',
      'authLoginFailed': 'Login failed',
      'authRegisterButton': 'Register',
      'authLoginButton': 'Login',
      'authCreateAccount': 'Create Account',
      
      // Welcome & Onboarding
      'welcomeTagline': 'Virtual Try-On Experience',
      'onboardingSkip': 'Skip',
      'onboardingNext': 'Next',
      'onboardingGetStarted': 'Get Started',
      'onboarding1Title': 'Virtual Try-On',
      'onboarding1Desc': 'Try on clothes virtually and see how they look. Real-time try-on experience.',
      'onboarding2Title': 'Your Digital Wardrobe',
      'onboarding2Desc': 'Add the clothes you try on to your wardrobe and manage them easily.',
      'onboarding3Title': 'Price & Stock Tracking',
      'onboarding3Desc': 'Add product links, track price changes and stock status.',
      'onboarding4Title': 'Size Recommendations',
      'onboarding4Desc': 'Enter your measurements, find your perfect size. Personalized recommendations.',
      'creditHistoryMonthlyReload': 'Monthly credit reload',
      'creditHistoryTryOn': 'Virtual Try-On',
      'creditHistoryPurchase': 'Additional credit purchase',
      'creditHistoryReferral': 'Referral bonus',
      
      // Upsell Dialog
      'upsellTitleEmpty': 'Out of Credits!',
      'upsellTitleLow': 'Running Low on Credits!',
      'upsellDescEmpty': 'Buy credits or upgrade your plan to continue using virtual try-on.',
      'upsellDescLow': 'You only have {count} credits left. Add more credits for more try-ons.',
      'upsellAddCredit': 'Add Credits',
      'upsellAddCreditDesc': 'Starting from ₺80 for 10 credits',
      'upsellUpgrade': 'Upgrade Plan',
      'upsellUpgradeDesc': 'More credits, better price',
      'upsellLater': 'Later',
      
      // Free Plan
      'freePlanTitle': 'No Subscription',
      'freePlanNoCredit': 'You have no credits',
      'freePlanWarning': 'Choose a plan for unlimited try-ons',
      
      // Subscription Status
      'subExpired': 'Expired',
      'freePlanSelectButton': 'Select Plan',
      'freePlanFeaturesTitle': 'Available Features',
      'freePlanFeature1': 'Unlimited wardrobe',
      'freePlanFeature2': 'Try-on history',
      'freePlanFeature3': 'Price tracking',
      
      // Language Selection
      'languageTitle': 'Language',
      'languageTurkish': 'Türkçe',
      'languageEnglish': 'English',
      
      // Measurements
      'measurementsInfo': 'Enter your measurements to find your perfect size',
      'measurementsHeight': 'Height (cm)',
      'measurementsHeightError': 'Please enter your height',
      'measurementsHeightInvalid': 'Enter a valid height (100-250 cm)',
      'measurementsWeight': 'Weight (kg)',
      'measurementsWeightError': 'Please enter your weight',
      'measurementsWeightInvalid': 'Enter a valid weight (30-200 kg)',
      'measurementsChest': 'Chest (cm)',
      'measurementsChestError': 'Please enter your chest measurement',
      'measurementsChestInvalid': 'Enter a valid measurement (60-150 cm)',
      'measurementsWaist': 'Waist (cm)',
      'measurementsWaistError': 'Please enter your waist measurement',
      'measurementsWaistInvalid': 'Enter a valid measurement (50-150 cm)',
      'measurementsHips': 'Hips (cm)',
      'measurementsHipsError': 'Please enter your hips measurement',
      'measurementsHipsInvalid': 'Enter a valid measurement (60-150 cm)',
      'measurementsCalculate': 'Calculate Size',
      'measurementsRecommended': 'Your Recommended Size',
      'measurementsCalculatedInfo': 'This size is calculated based on your measurements',
      'measurementsSaved': 'Measurements saved',
      
      // Common
      'cancel': 'Cancel',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'done': 'Done',
      'ok': 'OK',
      'yes': 'Yes',
      'no': 'No',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      
      // Credit Dialogs
      'creditUseTitle': 'Use Credit',
      'creditUseMessage': 'Do you want to use 1 credit for virtual try-on?\n\nYour current credits: {credits}',
      'insufficientCredit': 'Insufficient Credit',
      'insufficientCreditSubscription': 'You don\'t have enough credits for virtual try-on. Choose a monthly plan for unlimited try-ons!',
      'selectPlan': 'Select Plan',
      'later': 'Later',
      
      // Credit Warnings
      'creditLowTitle': 'Low Credits!',
      'creditLowMessage': 'You only have {credits} credits left. Get more credits to continue trying on clothes!',
      'creditEmptyTitle': 'No Credits Left!',
      'creditEmptyMessage': 'You\'ve run out of credits. Choose a plan to continue using virtual try-on!',
      
      // Notification Settings
      'notifCreditAlert': 'Credit Alerts',
      'notifCreditAlertDesc': 'Get notified when credits are low',
      'notifPriceDrop': 'Price Drop Alerts',
      'notifPriceDropDesc': 'Get notified when prices drop',
      'notifStockAlert': 'Stock Alerts',
      'notifStockAlertDesc': 'Get notified when items are back in stock',
      'notifNewFeatures': 'New Features',
      'notifNewFeaturesDesc': 'Get notified about new features and updates',
      'notifSettingsSaved': 'Notification settings saved',
      
      // Onboarding
      'onboardingWelcomeTitle': 'Welcome to PeekFit',
      'onboardingWelcomeSubtitle': 'AI-powered virtual try-on for your wardrobe',
      'onboardingFeature1Title': 'AI-Powered Try-On',
      'onboardingFeature1Desc': 'See how clothes look on you with AI',
      'onboardingFeature2Title': 'Real-time Preview',
      'onboardingFeature2Desc': 'Instant results with smooth animations',
      'onboardingFeature3Title': 'Wardrobe Management',
      'onboardingFeature3Desc': 'Organize and track your clothes',
      'onboardingPermissionsTitle': 'Permissions Required',
      'onboardingPermissionsSubtitle': 'We need these permissions to provide the best experience',
      'onboardingPermissionCamera': 'Camera Access',
      'onboardingPermissionCameraDesc': 'Take photos for try-on',
      'onboardingPermissionPhotos': 'Photo Library',
      'onboardingPermissionPhotosDesc': 'Choose photos from gallery',
      'onboardingPermissionNotifications': 'Notifications',
      'onboardingPermissionNotificationsDesc': 'Get alerts about prices and stock',
      'onboardingAllowAll': 'Allow All Permissions',
      'onboardingPaywallTitle': 'Transform Your Style',
      'onboardingPaywallSubtitle': 'See yourself in any outfit with AI magic',
      'onboardingPurchase': 'Purchase',
      'onboardingTermsHint': 'Auto-renewable. Cancel anytime',
      'continue': 'Continue',
      
      // Auth
      'authWelcome': 'Welcome Back',
      'authLoginSubtitle': 'Sign in to your account',
      'authEmail': 'Email',
      'authEmailHint': 'example@email.com',
      'authEmailRequired': 'Please enter your email',
      'authEmailInvalid': 'Please enter a valid email',
      'authPassword': 'Password',
      'authPasswordRequired': 'Please enter your password',
      'authPasswordMinLength': 'Password must be at least 6 characters',
      'authForgotPassword': 'Forgot Password',
      'authLoginButton': 'Login',
      'authLoginFailed': 'Login failed',
      'authOr': 'or',
      'authCreateAccount': 'Create Account',
      'authRegisterSubtitle': 'Create a new account',
      'authName': 'Full Name',
      'authNameHint': 'Your Name',
      'authNameRequired': 'Please enter your name',
      'authConfirmPassword': 'Confirm Password',
      'authConfirmPasswordRequired': 'Please confirm your password',
      'authPasswordMismatch': 'Passwords do not match',
      'authTermsAccept': 'I accept the terms and privacy policy',
      'authAcceptTerms': 'Please accept the terms',
      'authRegisterButton': 'Register',
      'authRegisterFailed': 'Registration failed',
      'authAlreadyHaveAccount': 'Already have an account? ',
    },
    'tr': {
      // App
      'appName': 'PeekFit',
      
      // Navigation
      'navHome': 'Ana Sayfa',
      'navWardrobe': 'Gardırop',
      'navHistory': 'Geçmiş',
      'navProfile': 'Profil',
      
      // Home
      'homeTitle': 'PeekFit',
      'homeWarningTitle': 'Ürün Linki Ekle',
      'homeWarningDesc': 'gardırobundaki ürünün linki eksik',
      'homeWarningButton': 'Şimdi Ekle',
      'homeRecentTitle': 'Son Denemeler',
      'homeViewAll': 'Tümünü Gör',
      'homeNoHistory': 'Henüz deneme geçmişiniz yok',
      'homeNoHistoryDesc': 'Kıyafet denemeye başlayın, geçmişiniz burada görünsün',
      'homeTryNow': 'Şimdi Dene',
      'homeRecommendedTitle': 'Bunları Deneyebilirsiniz',
      'homeViewAllButton': 'Tümü',
      'homePreviousTitle': 'Daha Önce Bunları Denediniz',
      'homeNoTryOnYet': 'Henüz kıyafet denemediniz',
      'homeNoTryOnDesc': 'Yukarıdaki butona tıklayarak başlayın',
      
      // Try-On
      'tryOnTitle': 'Sanal Deneme',
      'tryOnResult': 'Deneme Sonucu',
      'tryOnSuccess': 'Deneme Başarılı!',
      'tryOnSuccessDesc': 'Üzerinde nasıl durduğunu gör',
      'tryOnAgain': 'Tekrar Dene',
      'shareText': 'PeekFit ile sanal denememe göz at! 👗✨',
      'tryOnYourPhoto': 'Senin Fotoğrafın',
      'tryOnClothingImage': 'Kıyafet Görseli',
      'tryOnTapToSelect': 'Seçmek için dokun',
      'tryOnCategory': 'Kıyafet Kategorisi',
      'tryOnUpperBody': 'Üst Giyim',
      'tryOnLowerBody': 'Alt Giyim',
      'tryOnFullBody': 'Tam Giyim',
      'tryOnStartButton': 'Denemeyi Başlat',
      'tryOnProcessing': 'İşleniyor...',
      'tryOnPhotoSelect': 'Fotoğraf Seç',
      'tryOnErrorNoPhoto': 'Lütfen bir fotoğraf yükleyin',
      'tryOnErrorNoClothing': 'Lütfen kıyafet resmi ekleyin',
      'tryOnCamera': 'Kamera',
      'tryOnCameraDesc': 'Fotoğraf çek',
      'tryOnGallery': 'Galeri',
      'tryOnGalleryDesc': 'Galeriden seç',
      'tryOnUrlPlaceholder': 'Kıyafet URL\'sini buraya yapıştır...',
      
      // Wardrobe
      'wardrobeTitle': 'Gardırobum',
      'wardrobeSearch': 'Ürün ara...',
      'wardrobeAll': 'Tümü',
      'wardrobeEmpty': 'Gardırobunuz boş',
      'wardrobeEmptyDesc': 'Kıyafet ekleyerek düzenlemeye başlayın',
      'wardrobeAddItem': 'Ürün Ekle',
      
      // Categories
      'categoryUpperBody': 'Üst Giyim',
      'categoryLowerBody': 'Alt Giyim',
      'categoryDresses': 'Elbiseler',
      'categoryOuterwear': 'Dış Giyim',
      'categoryShoes': 'Ayakkabılar',
      'categoryAccessories': 'Aksesuarlar',
      'categoryTShirt': 'Tişört',
      'categoryShirt': 'Gömlek',
      'categoryPants': 'Pantolon',
      'categoryDress': 'Elbise',
      'categoryJacket': 'Ceket',
      'categoryShoe': 'Ayakkabı',
      'categoryAccessory': 'Aksesuar',
      'categoryOther': 'Diğer',
      
      // Add to Wardrobe Dialog
      'addToWardrobeTitle': 'Gardıroba Ekle',
      'addToWardrobeProductName': 'Ürün Adı',
      'addToWardrobeBrand': 'Marka',
      'addToWardrobePrice': 'Fiyat',
      'addToWardrobeProductLink': 'Ürün Linki',
      'addToWardrobeCategory': 'Kategori',
      'addToWardrobeCancel': 'İptal',
      'addToWardrobeSave': 'Kaydet',
      'addToWardrobeNameHint': 'örn. Beyaz Tişört',
      'addToWardrobeBrandHint': 'örn. Nike',
      'addToWardrobePriceHint': 'örn. ₺299',
      'addToWardrobeLinkHint': 'https://...',
      
      // Profile
      'profileTitle': 'Profil',
      'profileSettings': 'Ayarlar',
      'profileMeasurements': 'Beden Ölçülerim',
      'profileMeasurementsDesc': 'Önerilen Beden:',
      'profileMeasurementsMissing': 'Ölçülerinizi ekleyin',
      'profileMissingLabel': 'Eksik',
      'profileDarkMode': 'Karanlık Tema',
      'profileDarkModeOn': 'Açık',
      'profileDarkModeOff': 'Kapalı',
      'profileNotifications': 'Bildirimler',
      'profileNotificationsDesc': 'Fiyat ve stok bildirimleri',
      'profileLanguage': 'Dil',
      'profileLanguageDesc': 'Uygulama dili',
      'profileTestButtons': 'Test Butonları',
      'profileTestCredit': 'Kredi Azalıyor Bildirimi',
      'profileTestCreditDesc': 'Test notification göster',
      'profileTestFree': 'Free Plan Görünümü',
      'profileTestFreeDesc': 'Abonelik olmadan nasıl görünür',
      'profileAbout': 'Hakkında',
      'profileAboutApp': 'Uygulama Hakkında',
      'profileVersion': 'Versiyon 1.0.0',
      'profilePrivacy': 'Gizlilik Politikası',
      'profileTerms': 'Kullanım Koşulları',
      'profileLogout': 'Çıkış Yap',
      'privacyContent': 'PeekFit Gizlilik Politikası\n\nGizliliğinize değer veriyoruz. Bu uygulama, sanal deneme hizmetleri sunmak için gerekli minimum kişisel veriyi toplar.\n\n• Fotoğraflar güvenli şekilde işlenir ve kalıcı olarak saklanmaz\n• Kullanıcı verileri şifrelenir ve korunur\n• Verilerinizi üçüncü taraflarla paylaşmayız\n• Hesabınızı ve verilerinizi istediğiniz zaman silebilirsiniz\n\nDaha fazla bilgi için privacy@peekfit.com adresinden bize ulaşın',
      'termsContent': 'PeekFit Kullanım Şartları\n\nBu uygulamayı kullanarak şunları kabul edersiniz:\n\n• Hizmeti kişisel, ticari olmayan amaçlarla kullanmak\n• Sanal deneme özelliğini kötüye kullanmamak\n• Fikri mülkiyet haklarına saygı göstermek\n• AI tarafından üretilen sonuçların değişebileceğini kabul etmek\n\nŞu haklara sahibiz:\n• Hizmetleri değiştirme veya durdurma\n• Fiyatlandırma ve abonelik planlarını güncelleme\n• Şartları ihlal eden hesapları sonlandırma\n\nSon güncelleme: Ocak 2025',
      
      // Subscription
      'subTitle': 'Planını Seç',
      'subHeader': 'Sınırsız Deneme İçin',
      'subDesc': 'Planını seç ve AI ile kıyafet denemeye başla',
      'subStarter': 'Starter',
      'subPro': 'Pro',
      'subBusiness': 'Business',
      'subPopular': 'EN POPÜLER',
      'subCreditsPerMonth': 'kredi/ay',
      'subContinue': 'Devam Et',
      'subPlanActive': 'Aktif',
      'subRenewal': 'Yenileme:',
      'subDaysLater': 'gün sonra',
      'subAddCredit': 'Ek Kredi',
      'subChangePlan': 'Paketi Değiştir',
      'subPerMonth': '/ay',
      'subSelected': 'seçildi',
      
      // Credit Purchase
      'creditPurchaseTitle': 'Ek Kredi Satın Al',
      'creditCurrentTitle': 'Mevcut Krediniz',
      'creditCurrentAmount': 'Kredi',
      'creditPackagesTitle': 'Kredi Paketleri',
      'creditPackagesDesc': 'Pro aboneler için özel indirimli fiyatlar',
      'creditDiscount10': '%10 İndirim',
      'creditDiscount20': '%20 İndirim',
      'creditPerCredit': '/kredi',
      'creditInfoText': 'Satın aldığınız krediler hiç bitmez ve mevcut kredinize eklenir.',
      'creditBuyButton': 'Satın Al',
      
      // Credit History
      'creditHistoryTitle': 'Kredi Geçmişi',
      'creditHistoryTotal': 'Toplam Kredi',
      'creditHistoryThisMonth': 'Bu Ay',
      'creditHistoryUsed': 'Kullanılan',
      
      // History Screen
      'historyClearTitle': 'Geçmişi Temizle',
      'historyClearConfirm': 'Tüm deneme geçmişinizi silmek istediğinizden emin misiniz?',
      'historyClearButton': 'Temizle',
      'historyCleared': 'Geçmiş temizlendi',
      'historyToday': 'Bugün',
      'historyYesterday': 'Dün',
      
      // Wardrobe Detail
      'wardrobeChangesSaved': 'Değişiklikler kaydedildi',
      'wardrobeDeleteTitle': 'Ürünü Sil',
      'wardrobeDeleteConfirm': 'Bu ürünü gardırobunuzdan silmek istediğinizden emin misiniz?',
      'wardrobeDeleteButton': 'Sil',
      'wardrobeItemDeleted': 'Ürün silindi',
      'wardrobeSaveButton': 'Kaydet',
      'wardrobeProductLink': 'Ürün Linki',
      
      // Try-On Errors
      'tryOnPhotoError': 'Fotoğraf seçilemedi',
      'tryOnFailed': 'Try-on başarısız',
      'error': 'Hata',
      
      // Auth
      'authAcceptTerms': 'Lütfen kullanım koşullarını kabul edin',
      'authRegisterFailed': 'Kayıt başarısız',
      'authLoginFailed': 'Giriş başarısız',
      'authRegisterButton': 'Kayıt Ol',
      'authLoginButton': 'Giriş Yap',
      'authCreateAccount': 'Hesap Oluştur',
      
      // Welcome & Onboarding
      'welcomeTagline': 'Sanal Kıyafet Deneme Deneyimi',
      'onboardingSkip': 'Atla',
      'onboardingNext': 'Devam',
      'onboardingGetStarted': 'Başlayalım',
      'onboarding1Title': 'Sanal Kıyafet Deneme',
      'onboarding1Desc': 'Kıyafetleri sanal olarak deneyin ve nasıl göründüğünü görün. Gerçek zamanlı deneme deneyimi.',
      'onboarding2Title': 'Dijital Gardırobunuz',
      'onboarding2Desc': 'Denediğiniz kıyafetleri gardırobunuza ekleyin ve kolaylıkla yönetin.',
      'onboarding3Title': 'Fiyat & Stok Takibi',
      'onboarding3Desc': 'Ürün linklerini ekleyin, fiyat değişimlerini ve stok durumunu takip edin.',
      'onboarding4Title': 'Beden Önerileri',
      'onboarding4Desc': 'Ölçülerinizi girin, size en uygun bedeni öğrenin. Kişiselleştirilmiş öneriler.',
      'creditHistoryMonthlyReload': 'Aylık kredi yüklemesi',
      'creditHistoryTryOn': 'Virtual Try-On',
      'creditHistoryPurchase': 'Ek kredi satın alımı',
      'creditHistoryReferral': 'Referral bonusu',
      
      'upsellTitleEmpty': 'Krediniz Bitti!',
      'upsellTitleLow': 'Krediniz Azalıyor!',
      'upsellDescEmpty': 'Virtual try-on özelliğini kullanmaya devam etmek için kredi satın alın veya planınızı yükseltin.',
      'upsellDescLow': 'Sadece {count} krediniz kaldı. Daha fazla deneme yapmak için kredi ekleyin.',
      'upsellAddCredit': 'Ek Kredi Al',
      'upsellAddCreditDesc': '10 kredi - ₺80\'den başlayan fiyatlarla',
      'upsellUpgrade': 'Planı Yükselt',
      'upsellUpgradeDesc': 'Daha fazla kredi, daha iyi fiyat',
      'upsellLater': 'Daha Sonra',
      
      // Free Plan
      'freePlanTitle': 'Abonelik Yok',
      'freePlanNoCredit': 'Krediniz bulunmuyor',
      'freePlanWarning': 'Sınırsız deneme için bir plan seçin',
      
      // Subscription Status
      'subExpired': 'Süresi Doldu',
      'freePlanSelectButton': 'Plan Seç',
      'freePlanFeaturesTitle': 'Kullanabileceğiniz Özellikler',
      'freePlanFeature1': 'Sınırsız gardırop',
      'freePlanFeature2': 'Deneme geçmişi',
      'freePlanFeature3': 'Fiyat takibi',
      
      // Language Selection
      'languageTitle': 'Dil',
      'languageTurkish': 'Türkçe',
      'languageEnglish': 'English',
      
      // Measurements
      'measurementsInfo': 'Ölçülerinizi girerek size en uygun bedeni öğrenebilirsiniz',
      'measurementsHeight': 'Boy (cm)',
      'measurementsHeightError': 'Lütfen boyunuzu girin',
      'measurementsHeightInvalid': 'Geçerli bir boy girin (100-250 cm)',
      'measurementsWeight': 'Kilo (kg)',
      'measurementsWeightError': 'Lütfen kilonuzu girin',
      'measurementsWeightInvalid': 'Geçerli bir kilo girin (30-200 kg)',
      'measurementsChest': 'Göğüs Çevresi (cm)',
      'measurementsChestError': 'Lütfen göğüs çevrenizi girin',
      'measurementsChestInvalid': 'Geçerli bir ölçü girin (60-150 cm)',
      'measurementsWaist': 'Bel Çevresi (cm)',
      'measurementsWaistError': 'Lütfen bel çevrenizi girin',
      'measurementsWaistInvalid': 'Geçerli bir ölçü girin (50-150 cm)',
      'measurementsHips': 'Kalça Çevresi (cm)',
      'measurementsHipsError': 'Lütfen kalça çevrenizi girin',
      'measurementsHipsInvalid': 'Geçerli bir ölçü girin (60-150 cm)',
      'measurementsCalculate': 'Beden Hesapla',
      'measurementsRecommended': 'Önerilen Bedeniniz',
      'measurementsCalculatedInfo': 'Bu beden ölçülerinize göre hesaplanmıştır',
      'measurementsSaved': 'Ölçüleriniz kaydedildi',
      
      // Common
      'cancel': 'İptal',
      'save': 'Kaydet',
      'delete': 'Sil',
      'edit': 'Düzenle',
      'done': 'Tamam',
      'ok': 'Tamam',
      'yes': 'Evet',
      'no': 'Hayır',
      'loading': 'Yükleniyor...',
      'error': 'Hata',
      'success': 'Başarılı',
      
      // Credit Dialogs
      'creditUseTitle': 'Kredi Kullan',
      'creditUseMessage': '1 kredi kullanarak sanal deneme yapmak istiyor musunuz?\n\nMevcut krediniz: {credits}',
      'insufficientCredit': 'Yetersiz Kredi',
      'insufficientCreditSubscription': 'Sanal deneme yapmak için krediniz bulunmuyor. Sınırsız deneme için aylık plan seçin!',
      'selectPlan': 'Plan Seç',
      'later': 'Daha Sonra',
      
      // Credit Warnings
      'creditLowTitle': 'Krediniz Azalıyor!',
      'creditLowMessage': 'Sadece {credits} krediniz kaldı. Daha fazla deneme yapmak için kredi edinin!',
      'creditEmptyTitle': 'Krediniz Bitti!',
      'creditEmptyMessage': 'Krediniz tükendi. Sanal denemeye devam etmek için bir plan seçin!',
      
      // Notification Settings
      'notifCreditAlert': 'Kredi Bildirimleri',
      'notifCreditAlertDesc': 'Kredi azaldığında bildirim al',
      'notifPriceDrop': 'Fiyat Düşüşü Bildirimleri',
      'notifPriceDropDesc': 'Fiyat düştüğünde bildirim al',
      'notifStockAlert': 'Stok Bildirimleri',
      'notifStockAlertDesc': 'Ürün stoğa girdiğinde bildirim al',
      'notifNewFeatures': 'Yeni Özellikler',
      'notifNewFeaturesDesc': 'Yeni özellikler ve güncellemeler hakkında bildirim al',
      'notifSettingsSaved': 'Bildirim ayarları kaydedildi',
      
      // Onboarding
      'onboardingWelcomeTitle': 'PeekFit\'e Hoş Geldiniz',
      'onboardingWelcomeSubtitle': 'Gardırobunuz için AI destekli sanal deneme',
      'onboardingFeature1Title': 'AI Destekli Deneme',
      'onboardingFeature1Desc': 'Kıyafetlerin üzerinizde nasıl durduğunu AI ile görün',
      'onboardingFeature2Title': 'Anlık Önizleme',
      'onboardingFeature2Desc': 'Akıcı animasyonlarla anında sonuç',
      'onboardingFeature3Title': 'Gardırop Yönetimi',
      'onboardingFeature3Desc': 'Kıyafetlerinizi düzenleyin ve takip edin',
      'onboardingPermissionsTitle': 'İzinler Gerekli',
      'onboardingPermissionsSubtitle': 'En iyi deneyimi sunmak için bu izinlere ihtiyacımız var',
      'onboardingPermissionCamera': 'Kamera Erişimi',
      'onboardingPermissionCameraDesc': 'Deneme için fotoğraf çekin',
      'onboardingPermissionPhotos': 'Fotoğraf Galerisi',
      'onboardingPermissionPhotosDesc': 'Galeriden fotoğraf seçin',
      'onboardingPermissionNotifications': 'Bildirimler',
      'onboardingPermissionNotificationsDesc': 'Fiyat ve stok hakkında bildirim alın',
      'onboardingAllowAll': 'Tüm İzinleri Ver',
      'onboardingPaywallTitle': 'Stilinizi Dönüştürün',
      'onboardingPaywallSubtitle': 'AI sihriyle kendinizi her kıyafette görün',
      'onboardingPurchase': 'Satın Al',
      'onboardingTermsHint': 'Otomatik yenilenebilir. İstediğiniz zaman iptal edin',
      'continue': 'Devam Et',
      
      // Auth
      'authWelcome': 'Hoş Geldiniz',
      'authLoginSubtitle': 'Hesabınıza giriş yapın',
      'authEmail': 'E-posta',
      'authEmailHint': 'ornek@email.com',
      'authEmailRequired': 'Lütfen e-posta adresinizi girin',
      'authEmailInvalid': 'Geçerli bir e-posta adresi girin',
      'authPassword': 'Şifre',
      'authPasswordRequired': 'Lütfen şifrenizi girin',
      'authPasswordMinLength': 'Şifre en az 6 karakter olmalıdır',
      'authForgotPassword': 'Şifremi Unuttum',
      'authLoginButton': 'Giriş Yap',
      'authLoginFailed': 'Giriş başarısız',
      'authOr': 'veya',
      'authCreateAccount': 'Hesap Oluştur',
      'authRegisterSubtitle': 'Yeni bir hesap oluşturun',
      'authName': 'Ad Soyad',
      'authNameHint': 'Adınız Soyadınız',
      'authNameRequired': 'Lütfen adınızı girin',
      'authConfirmPassword': 'Şifre Tekrar',
      'authConfirmPasswordRequired': 'Lütfen şifrenizi tekrar girin',
      'authPasswordMismatch': 'Şifreler eşleşmiyor',
      'authTermsAccept': 'Kullanım koşullarını ve gizlilik politikasını kabul ediyorum',
      'authAcceptTerms': 'Lütfen kullanım koşullarını kabul edin',
      'authRegisterButton': 'Kayıt Ol',
      'authRegisterFailed': 'Kayıt başarısız',
      'authAlreadyHaveAccount': 'Zaten hesabınız var mı? ',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  // Getters for easy access
  String get appName => translate('appName');
  
  // Navigation
  String get navHome => translate('navHome');
  String get navWardrobe => translate('navWardrobe');
  String get navHistory => translate('navHistory');
  String get navProfile => translate('navProfile');
  
  // Add more getters as needed...
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'tr'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
