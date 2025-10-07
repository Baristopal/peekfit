class ClothingItem {
  final String id;
  final String name;
  final String? imageUrl;
  final String? imagePath;
  final String category;
  final String? brand;
  final String? productUrl;
  final String? clothingUrl; // Original clothing URL
  final double? price;
  final bool? inStock;
  final DateTime addedDate;
  final DateTime? lastChecked;
  
  ClothingItem({
    required this.id,
    required this.name,
    this.imageUrl,
    this.imagePath,
    required this.category,
    this.brand,
    this.productUrl,
    this.clothingUrl,
    this.price,
    this.inStock,
    required this.addedDate,
    this.lastChecked,
  });
  
  bool get hasProductLink => productUrl != null && productUrl!.isNotEmpty;
  
  bool get needsProductLink => !hasProductLink;
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl, // Try-on result image
      'imagePath': imagePath,
      'category': category,
      'brand': brand ?? '', 
      'productUrl': productUrl,
      'clothingUrl': clothingUrl,
      'price': price,
      'inStock': inStock,
      'addedDate': addedDate.toUtc().toIso8601String(), // UTC format
      'lastChecked': lastChecked?.toUtc().toIso8601String(),
      // Backend specific fields
      'Name': name, // Backend: Item name
      'ImageUrl': imageUrl ?? '', // Backend: Try-on result image
      'ClothingUrl': clothingUrl ?? '', // Backend: Original clothing URL
      'ClothingType': category, // Backend requires ClothingType
      'AddedAt': addedDate.toUtc().toIso8601String(), // Backend field name
    };
  }
  
  factory ClothingItem.fromJson(Map<String, dynamic> json) {
    return ClothingItem(
      id: json['id'] ?? '',
      name: json['name'] ?? json['Name'] ?? json['clothingType'] ?? 'Item',
      imageUrl: json['imageUrl'] ?? json['ImageUrl'],
      imagePath: json['imagePath'],
      category: json['category'] ?? json['clothingType'] ?? 'other',
      brand: json['brand'] ?? json['Brand'] ?? '',
      productUrl: json['productUrl'] ?? json['ProductUrl'],
      clothingUrl: json['clothingUrl'] ?? json['ClothingUrl'],
      price: json['price']?.toDouble(),
      inStock: json['inStock'],
      addedDate: json['addedAt'] != null 
          ? DateTime.parse(json['addedAt'])
          : (json['addedDate'] != null 
              ? DateTime.parse(json['addedDate'])
              : DateTime.now()),
      lastChecked: json['lastChecked'] != null 
          ? DateTime.parse(json['lastChecked']) 
          : null,
    );
  }
  
  ClothingItem copyWith({
    String? id,
    String? name,
    String? imageUrl,
    String? imagePath,
    String? category,
    String? brand,
    String? productUrl,
    String? clothingUrl,
    double? price,
    bool? inStock,
    DateTime? addedDate,
    DateTime? lastChecked,
  }) {
    return ClothingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      imagePath: imagePath ?? this.imagePath,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      productUrl: productUrl ?? this.productUrl,
      clothingUrl: clothingUrl ?? this.clothingUrl,
      price: price ?? this.price,
      inStock: inStock ?? this.inStock,
      addedDate: addedDate ?? this.addedDate,
      lastChecked: lastChecked ?? this.lastChecked,
    );
  }
}

class ClothingCategory {
  // Language-independent keys
  static const String tshirt = 'tshirt';
  static const String shirt = 'shirt';
  static const String pants = 'pants';
  static const String dress = 'dress';
  static const String jacket = 'jacket';
  static const String shoes = 'shoes';
  static const String accessories = 'accessories';
  static const String other = 'other';
  
  static List<String> get all => [
    tshirt,
    shirt,
    pants,
    dress,
    jacket,
    shoes,
    accessories,
    other,
  ];
  
  // Get translated name
  static String getTranslatedName(String category, String Function(String) translate) {
    switch (category) {
      case tshirt:
        return translate('categoryTShirt');
      case shirt:
        return translate('categoryShirt');
      case pants:
        return translate('categoryPants');
      case dress:
        return translate('categoryDress');
      case jacket:
        return translate('categoryJacket');
      case shoes:
        return translate('categoryShoe');
      case accessories:
        return translate('categoryAccessory');
      case other:
        return translate('categoryOther');
      default:
        return category;
    }
  }
}
