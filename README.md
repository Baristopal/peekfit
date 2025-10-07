# PeekFit - Sanal Kıyafet Deneme Uygulaması

PeekFit, kullanıcıların kıyafetleri sanal olarak deneyebileceği, gardıroplarını yönetebileceği ve ürün fiyat takibi yapabileceği modern bir mobil uygulamadır.

## 🌟 Özellikler

### 📸 Sanal Kıyafet Deneme
- Kendi fotoğrafınızı yükleyin
- Kıyafet resmini fotoğraf, galeri veya URL ile ekleyin
- Yapay zeka ile kıyafeti üzerinizde görün
- Denenen kıyafetleri gardıroba ekleme

### 👔 Dijital Gardırop
- Kıyafetlerinizi kategorilere göre organize edin
- Her ürün için detaylı bilgi saklayın
- Marka, kategori ve ürün linki ekleme

### 📊 Fiyat & Stok Takibi
- Ürün linklerini ekleyerek fiyat takibi yapın
- Stok durumunu kontrol edin
- Link eklenmemiş ürünler için uyarılar

### 📏 Beden Önerileri
- Boy, kilo ve vücut ölçülerinizi girin
- Otomatik beden hesaplama
- Kişiselleştirilmiş beden önerileri

### 📜 Deneme Geçmişi
- Tüm deneme aktivitelerinizi görüntüleyin
- Tarih bazlı filtreleme
- Geçmiş kayıtlarını yönetme

### 🌓 Dark Mode
- Tam dark mode desteği
- Siyah-beyaz minimal tasarım
- iOS standartlarında modern UI

## 🚀 Kurulum

### Gereksinimler
- Flutter SDK (3.9.2 veya üzeri)
- Dart SDK
- Android Studio / Xcode (platform bazlı)

### Bağımlılıkları Yükleme
```bash
flutter pub get
```

### Uygulamayı Çalıştırma
```bash
flutter run
```

## 📱 Desteklenen Platformlar
- ✅ iOS
- ✅ Android
- ✅ Web (sınırlı özellikler)

## 🏗️ Proje Yapısı
```
lib/
├── core/
│   └── theme/           # Tema ve renk tanımlamaları
├── models/              # Veri modelleri
├── providers/           # State management (Provider)
├── screens/             # Uygulama ekranları
│   ├── auth/           # Giriş ve kayıt
│   ├── home/           # Ana sayfa
│   ├── wardrobe/       # Gardırop yönetimi
│   ├── history/        # Geçmiş
│   ├── profile/        # Profil ve ayarlar
│   ├── try_on/         # Kıyafet deneme
│   ├── welcome/        # Karşılama ekranı
│   └── onboarding/     # Onboarding
└── main.dart           # Uygulama giriş noktası
```

## 🎨 Tasarım
- **Renk Paleti**: Siyah-Beyaz minimal tasarım
- **Font**: Inter (Google Fonts)
- **UI Framework**: Material Design 3
- **Stil**: iOS standartları, modern ve temiz

## 📦 Kullanılan Paketler
- `provider` - State management
- `google_fonts` - Özel fontlar
- `image_picker` - Kamera ve galeri erişimi
- `shared_preferences` - Yerel veri saklama
- `url_launcher` - URL açma
- `cached_network_image` - Resim önbellekleme
- `smooth_page_indicator` - Sayfa göstergeleri
- `intl` - Tarih formatlama

## 🔐 İzinler

### Android
- İnternet erişimi
- Kamera erişimi
- Depolama okuma/yazma

### iOS
- Kamera kullanımı
- Fotoğraf kütüphanesi erişimi

## 📄 Lisans
Bu proje özel bir projedir.

## 👨‍💻 Geliştirici
PeekFit Team

## 📞 İletişim
- App ID: `com.peekfit.app`
- Version: 1.0.0

---

**Not**: Bu uygulama 2025 tasarım trendlerine uygun olarak geliştirilmiştir.
