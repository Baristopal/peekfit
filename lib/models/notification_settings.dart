class NotificationSettings {
  final bool creditAlert;
  final bool priceDrop;
  final bool stockAlert;
  final bool newFeatures;

  NotificationSettings({
    required this.creditAlert,
    required this.priceDrop,
    required this.stockAlert,
    required this.newFeatures,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      creditAlert: json['creditAlert'] ?? true,
      priceDrop: json['priceDrop'] ?? true,
      stockAlert: json['stockAlert'] ?? true,
      newFeatures: json['newFeatures'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'creditAlert': creditAlert,
      'priceDrop': priceDrop,
      'stockAlert': stockAlert,
      'newFeatures': newFeatures,
    };
  }

  NotificationSettings copyWith({
    bool? creditAlert,
    bool? priceDrop,
    bool? stockAlert,
    bool? newFeatures,
  }) {
    return NotificationSettings(
      creditAlert: creditAlert ?? this.creditAlert,
      priceDrop: priceDrop ?? this.priceDrop,
      stockAlert: stockAlert ?? this.stockAlert,
      newFeatures: newFeatures ?? this.newFeatures,
    );
  }
}
