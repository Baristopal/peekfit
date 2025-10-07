import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CreditHistoryScreen extends StatelessWidget {
  const CreditHistoryScreen({super.key});

  // DEMO DATA
  final List<Map<String, dynamic>> _history = const [
    {
      'action': 'earned',
      'amount': 50,
      'description': 'Aylık kredi yüklemesi',
      'date': '1 Mart 2025',
    },
    {
      'action': 'spent',
      'amount': -1,
      'description': 'Virtual Try-On',
      'date': '28 Şubat 2025',
    },
    {
      'action': 'spent',
      'amount': -1,
      'description': 'Virtual Try-On',
      'date': '27 Şubat 2025',
    },
    {
      'action': 'purchased',
      'amount': 25,
      'description': 'Ek kredi satın alımı',
      'date': '25 Şubat 2025',
    },
    {
      'action': 'spent',
      'amount': -1,
      'description': 'Virtual Try-On',
      'date': '24 Şubat 2025',
    },
    {
      'action': 'earned',
      'amount': 5,
      'description': 'Referral bonusu',
      'date': '20 Şubat 2025',
    },
    {
      'action': 'spent',
      'amount': -1,
      'description': 'Virtual Try-On',
      'date': '18 Şubat 2025',
    },
    {
      'action': 'earned',
      'amount': 50,
      'description': 'Aylık kredi yüklemesi',
      'date': '1 Şubat 2025',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kredi Geçmişi'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Summary Card
          Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: isDark ? AppColors.darkGradient : AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.diamond_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Toplam Kredi',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '32 Kredi',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Bu Ay',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '18 Kullanıldı',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // History List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final item = _history[index];
                return _HistoryItem(
                  action: item['action'],
                  amount: item['amount'],
                  description: item['description'],
                  date: item['date'],
                  isDark: isDark,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final String action;
  final int amount;
  final String description;
  final String date;
  final bool isDark;

  const _HistoryItem({
    required this.action,
    required this.amount,
    required this.description,
    required this.date,
    required this.isDark,
  });

  IconData get _icon {
    switch (action) {
      case 'earned':
        return Icons.add_circle_rounded;
      case 'spent':
        return Icons.remove_circle_rounded;
      case 'purchased':
        return Icons.shopping_bag_rounded;
      default:
        return Icons.circle;
    }
  }

  Color get _color {
    switch (action) {
      case 'earned':
        return AppColors.success;
      case 'spent':
        return AppColors.error;
      case 'purchased':
        return AppColors.info;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _icon,
              color: _color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount > 0 ? '+$amount' : '$amount',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: _color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
