import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';

// TODO: In-App Purchase Integration (Subscription)
// Package: in_app_purchase: ^3.1.13
// - Google Play Billing (Android) - Auto-renewable subscriptions
// - App Store StoreKit (iOS) - Auto-renewable subscriptions
// - Revenue Cat (recommended for subscriptions)
//
// Steps:
// 1. Add in_app_purchase package to pubspec.yaml
// 2. Configure subscription products in Google Play Console & App Store Connect
// 3. Implement subscription flow with auto-renewal
// 4. Handle subscription status (active, expired, cancelled)
// 5. Sync subscription status with backend
// 6. Handle grace period & billing retry

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int _selectedPlan = 1; // 0: Starter, 1: Pro, 2: Business

  final List<Map<String, dynamic>> _plans = [
    {
      'name': 'Starter',
      'price': '₺149',
      'credits': '20',
      'color': AppColors.info,
      'popular': false,
    },
    {
      'name': 'Pro',
      'price': '₺299',
      'credits': '50',
      'color': AppColors.success,
      'popular': true,
    },
    {
      'name': 'Business',
      'price': '₺599',
      'credits': '120',
      'color': AppColors.warning,
      'popular': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('subTitle')),
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
                    // Header
                    Text(
                      l10n.translate('subHeader'),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.translate('subDesc'),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Plans
                    ..._plans.asMap().entries.map((entry) {
                      final index = entry.key;
                      final plan = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _PlanCard(
                          name: plan['name'],
                          price: plan['price'],
                          credits: plan['credits'],
                          color: plan['color'],
                          isPopular: plan['popular'],
                          isSelected: _selectedPlan == index,
                          onTap: () => setState(() => _selectedPlan = index),
                          isDark: isDark,
                        ),
                      );
                    }).toList(),
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
                        '${_plans[_selectedPlan]['credits']} ${l10n.translate('subCreditsPerMonth')}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '• ${_plans[_selectedPlan]['price']}${l10n.translate('subPerMonth')}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: _plans[_selectedPlan]['color'],
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
                            content: Text('${_plans[_selectedPlan]['name']} ${l10n.translate('subSelected')}!'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _plans[_selectedPlan]['color'],
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.translate('subContinue'),
                        style: const TextStyle(
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

class _PlanCard extends StatelessWidget {
  final String name;
  final String price;
  final String credits;
  final Color color;
  final bool isPopular;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _PlanCard({
    required this.name,
    required this.price,
    required this.credits,
    required this.color,
    required this.isPopular,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.workspace_premium_rounded,
                        color: color,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                price,
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: color,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '/ay',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.diamond_rounded,
                        color: color,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$credits ${AppLocalizations.of(context)!.translate('subCreditsPerMonth')}',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isPopular)
            Positioned(
              top: -1,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
                ),
                child: Text(
                  AppLocalizations.of(context)!.translate('subPopular'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
