class SubscriptionModel {
  final String status;          // 'None', 'Active', 'Expired'
  final String? plan;           // 'Starter', 'Pro', 'Business'
  final int monthlyCredits;     // 50
  final int usedCredits;        // 18
  final int remainingCredits;   // 32
  final DateTime? startDate;
  final DateTime? endDate;
  final int daysRemaining;      // 12
  
  SubscriptionModel({
    required this.status,
    this.plan,
    required this.monthlyCredits,
    required this.usedCredits,
    required this.remainingCredits,
    this.startDate,
    this.endDate,
    required this.daysRemaining,
  });
  
  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      status: json['status'] ?? 'None',
      plan: json['plan'],
      monthlyCredits: json['monthlyCredits'] ?? 0,
      usedCredits: json['usedCredits'] ?? 0,
      remainingCredits: json['remainingCredits'] ?? 0,
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      daysRemaining: json['daysRemaining'] ?? 0,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'plan': plan,
      'monthlyCredits': monthlyCredits,
      'usedCredits': usedCredits,
      'remainingCredits': remainingCredits,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'daysRemaining': daysRemaining,
    };
  }
  
  // Helper getters
  bool get isActive => status == 'Active';
  bool get isExpired => status == 'Expired';
  bool get hasSubscription => status != 'None';
  
  // Progress percentage (0.0 to 1.0)
  double get progressPercentage {
    if (monthlyCredits == 0) return 0.0;
    return remainingCredits / monthlyCredits;
  }
}
