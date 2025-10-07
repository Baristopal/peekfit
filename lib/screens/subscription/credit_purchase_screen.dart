import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

// TODO: In-App Purchase Integration
// Package: in_app_purchase: ^3.1.13
// - Google Play Store (Android)
// - App Store (iOS)
// - Revenue Cat (optional, for easier management)
//
// Steps:
// 1. Add in_app_purchase package to pubspec.yaml
// 2. Configure products in Google Play Console & App Store Connect
// 3. Implement purchase flow
// 4. Verify purchase with backend
// 5. Update user credits after successful purchase

class CreditPurchaseScreen extends StatefulWidget {
  const CreditPurchaseScreen({super.key});

  @override
  State<CreditPurchaseScreen> createState() => _CreditPurchaseScreenState();
}

class _CreditPurchaseScreenState extends State<CreditPurchaseScreen> {
  int _selectedPackage = 1; // 0, 1, 2

  final List<Map<String, dynamic>> _packages = [
    {
      'credits': '10',
      'price': '₺80',
      'perCredit': '₺8/kredi',
      'discount': null,
      'color': AppColors.info,
    },
    {
      'credits': '25',
      'price': '₺180',
      'perCredit': '₺7.2/kredi',
      'discount': '%10 İndirim',
      'color': AppColors.success,
    },
    {
      'credits': '50',
      'price': '₺320',
      'perCredit': '₺6.4/kredi',
      'discount': '%20 İndirim',
      'color': AppColors.warning,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ek Kredi Satın Al'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Current Credits
                    Container(
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
                                  'Mevcut Krediniz',
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
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    Text(
                      'Kredi Paketleri',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Pro aboneler için özel indirimli fiyatlar',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 24),

                    // Packages
                    ..._packages.asMap().entries.map((entry) {
                      final index = entry.key;
                      final package = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _CreditPackageCard(
                          credits: package['credits'],
                          price: package['price'],
                          perCredit: package['perCredit'],
                          discount: package['discount'],
                          color: package['color'],
                          isSelected: _selectedPackage == index,
                          onTap: () => setState(() => _selectedPackage = index),
                          isDark: isDark,
                        ),
                      );
                    }).toList(),

                    const SizedBox(height: 24),

                    // Info Box
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.info.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.info.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: AppColors.info,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Satın aldığınız krediler hiç bitmez ve mevcut kredinize eklenir.',
                              style: TextStyle(
                                color: AppColors.info,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Button
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${_packages[_selectedPackage]['credits']} Kredi',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '• ${_packages[_selectedPackage]['price']}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: _packages[_selectedPackage]['color'],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Backend entegrasyonu
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${_packages[_selectedPackage]['credits']} kredi satın alındı!'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _packages[_selectedPackage]['color'],
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Satın Al',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreditPackageCard extends StatelessWidget {
  final String credits;
  final String price;
  final String perCredit;
  final String? discount;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _CreditPackageCard({
    required this.credits,
    required this.price,
    required this.perCredit,
    required this.discount,
    required this.color,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.lightCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? color : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.diamond_rounded,
                    color: color,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '$credits Kredi',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (discount != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.success.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                discount!,
                                style: TextStyle(
                                  color: AppColors.success,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        perCredit,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      price,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (isSelected)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
