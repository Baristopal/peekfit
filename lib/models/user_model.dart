class UserModel {
  final String id;
  final String name;
  final String email;
  final int credits;
  final UserMeasurements? measurements;
  
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.credits = 0,
    this.measurements,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'credits': credits,
      'measurements': measurements?.toJson(),
    };
  }
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      credits: json['credits'] ?? json['credit'] ?? 0,
      measurements: json['measurements'] != null 
          ? UserMeasurements.fromJson(json['measurements']) 
          : null,
    );
  }
  
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    int? credits,
    UserMeasurements? measurements,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      credits: credits ?? this.credits,
      measurements: measurements ?? this.measurements,
    );
  }
}

class UserMeasurements {
  final double height; // cm
  final double weight; // kg
  final double chest; // cm
  final double waist; // cm
  final double hips; // cm
  final String recommendedSize;
  
  UserMeasurements({
    required this.height,
    required this.weight,
    required this.chest,
    required this.waist,
    required this.hips,
    required this.recommendedSize,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'height': height,
      'weight': weight,
      'chest': chest,
      'waist': waist,
      'hips': hips,
      'recommendedSize': recommendedSize,
    };
  }
  
  factory UserMeasurements.fromJson(Map<String, dynamic> json) {
    return UserMeasurements(
      height: (json['height'] ?? 0).toDouble(),
      weight: (json['weight'] ?? 0).toDouble(),
      chest: (json['chest'] ?? 0).toDouble(),
      waist: (json['waist'] ?? 0).toDouble(),
      hips: (json['hips'] ?? 0).toDouble(),
      recommendedSize: json['recommendedSize'] ?? 'M',
    );
  }
  
  // Calculate recommended size based on measurements
  static String calculateSize(double height, double weight, double chest, double waist) {
    // Simple size calculation logic
    double bmi = weight / ((height / 100) * (height / 100));
    
    if (chest < 85 && waist < 70) return 'XS';
    if (chest < 95 && waist < 80) return 'S';
    if (chest < 105 && waist < 90) return 'M';
    if (chest < 115 && waist < 100) return 'L';
    if (chest < 125 && waist < 110) return 'XL';
    return 'XXL';
  }
}
