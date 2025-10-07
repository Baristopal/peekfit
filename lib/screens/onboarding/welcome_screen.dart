import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';

class WelcomeScreen extends StatelessWidget {
  final VoidCallback onContinue;
  
  const WelcomeScreen({
    super.key,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              
              // App Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.checkroom_rounded,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Title
              Text(
                l10n.translate('onboardingWelcomeTitle'),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              // Subtitle
              Text(
                l10n.translate('onboardingWelcomeSubtitle'),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 48),
              
              // Features
              _FeatureItem(
                icon: Icons.auto_awesome_rounded,
                title: l10n.translate('onboardingFeature1Title'),
                subtitle: l10n.translate('onboardingFeature1Desc'),
                isDark: isDark,
              ),
              
              const SizedBox(height: 24),
              
              _FeatureItem(
                icon: Icons.speed_rounded,
                title: l10n.translate('onboardingFeature2Title'),
                subtitle: l10n.translate('onboardingFeature2Desc'),
                isDark: isDark,
              ),
              
              const SizedBox(height: 24),
              
              _FeatureItem(
                icon: Icons.checkroom_rounded,
                title: l10n.translate('onboardingFeature3Title'),
                subtitle: l10n.translate('onboardingFeature3Desc'),
                isDark: isDark,
              ),
              
              const Spacer(),
              
              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.translate('continue'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Page indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _PageDot(isActive: true, isDark: isDark),
                  const SizedBox(width: 8),
                  _PageDot(isActive: false, isDark: isDark),
                  const SizedBox(width: 8),
                  _PageDot(isActive: false, isDark: isDark),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDark;
  
  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: (isDark ? AppColors.darkPrimary : AppColors.lightPrimary).withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
            size: 28,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PageDot extends StatelessWidget {
  final bool isActive;
  final bool isDark;
  
  const _PageDot({
    required this.isActive,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
            : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary).withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
