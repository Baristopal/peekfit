import 'clothing_item.dart';

class TryOnHistory {
  final String id;
  final ClothingItem item;
  final DateTime triedOnDate;
  final String? notes;
  final bool addedToWardrobe;
  
  TryOnHistory({
    required this.id,
    required this.item,
    required this.triedOnDate,
    this.notes,
    this.addedToWardrobe = false,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item': item.toJson(),
      'triedOnDate': triedOnDate.toIso8601String(),
      'notes': notes,
      'addedToWardrobe': addedToWardrobe,
    };
  }
  
  factory TryOnHistory.fromJson(Map<String, dynamic> json) {
    return TryOnHistory(
      id: json['id'] ?? '',
      item: ClothingItem.fromJson(json['item']),
      triedOnDate: DateTime.parse(json['triedOnDate']),
      notes: json['notes'],
      addedToWardrobe: json['addedToWardrobe'] ?? false,
    );
  }
}
