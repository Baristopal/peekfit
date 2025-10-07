import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../screens/subscription/credit_purchase_screen.dart';
import '../screens/subscription/subscription_screen.dart';

class CreditUpsellDialog extends StatelessWidget {
  final int remainingCredits;

  const CreditUpsellDialog({
    super.key,
    this.remainingCredits = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: isDark ? AppColors.darkGradient : AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.diamond_rounded,
                color: Colors.white,
                size: 48,
              ),
            ),

            const SizedBox(height: 24),

            // Title
            Text(
              remainingCredits == 0 ? 'Krediniz Bitti!' : 'Krediniz Azalıyor!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Description
            Text(
              remainingCredits == 0
                  ? 'Virtual try-on özelliğini kullanmaya devam etmek için kredi satın alın veya planınızı yükseltin.'
                  : 'Sadece $remainingCredits krediniz kaldı. Daha fazla deneme yapmak için kredi ekleyin.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // Options
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _OptionItem(
                    icon: Icons.add_circle_rounded,
                    title: 'Ek Kredi Al',
                    subtitle: '10 kredi - ₺80\'den başlayan fiyatlarla',
                    color: AppColors.info,
                    isDark: isDark,
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const CreditPurchaseScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _OptionItem(
                    icon: Icons.workspace_premium_rounded,
                    title: 'Planı Yükselt',
                    subtitle: 'Daha fazla kredi, daha iyi fiyat',
                    color: AppColors.success,
                    isDark: isDark,
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SubscriptionScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Close Button
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Daha Sonra'),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;

  const _OptionItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
