import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/user_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/locale_provider.dart';
import '../../widgets/credit_upsell_dialog.dart';
import '../../l10n/app_localizations.dart';
import 'measurements_screen.dart';
import '../auth/login_screen.dart';
import '../subscription/subscription_screen.dart';
import '../subscription/credit_purchase_screen.dart';
import '../subscription/credit_history_screen.dart';
import '../settings/language_screen.dart';
import '../settings/notifications_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userProvider = Provider.of<UserProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('profileTitle')),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            
            // Profile Header
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: isDark ? AppColors.darkGradient : AppColors.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    userProvider.user?.name ?? 'Kullanıcı',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userProvider.user?.email ?? '',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Subscription Card (DYNAMIC)
            _SubscriptionCard(userProvider: userProvider, isDark: isDark, l10n: l10n),
            
            const SizedBox(height: 32),
            
            // Settings Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.translate('profileSettings'),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Measurements
                  _SettingsTile(
                    icon: Icons.straighten_rounded,
                    title: l10n.translate('profileMeasurements'),
                    subtitle: userProvider.hasMeasurements
                        ? '${l10n.translate('profileMeasurementsDesc')} ${userProvider.user!.measurements!.recommendedSize}'
                        : l10n.translate('profileMeasurementsMissing'),
                    trailing: userProvider.hasMeasurements
                        ? null
                        : Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              l10n.translate('profileMissingLabel'),
                              style: TextStyle(
                                color: AppColors.warning,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const MeasurementsScreen()),
                      );
                    },
                    isDark: isDark,
                  ),
                  const SizedBox(height: 8),
                  
                  // Dark Mode Toggle
                  _SettingsTile(
                    icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    title: l10n.translate('profileDarkMode'),
                    subtitle: isDark ? l10n.translate('profileDarkModeOn') : l10n.translate('profileDarkModeOff'),
                    trailing: Switch(
                      value: isDark,
                      onChanged: (value) {
                        themeProvider.toggleTheme();
                      },
                      activeColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                    ),
                    onTap: () {}, // Disable tap, only switch works
                    isDark: isDark,
                  ),
                  const SizedBox(height: 8),
                  
                  // Notifications
                  _SettingsTile(
                    icon: Icons.notifications_outlined,
                    title: l10n.translate('profileNotifications'),
                    subtitle: l10n.translate('profileNotificationsDesc'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                      );
                    },
                    isDark: isDark,
                  ),
                  const SizedBox(height: 8),
                  
                  // Language
                  _SettingsTile(
                    icon: Icons.language_rounded,
                    title: l10n.translate('profileLanguage'),
                    subtitle: Provider.of<LocaleProvider>(context).locale.languageCode == 'tr' ? 'Türkçe' : 'English',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const LanguageScreen()),
                      );
                    },
                    isDark: isDark,
                  ),

                  
                  const SizedBox(height: 32),
                  
                  // About Section
                  Text(
                    l10n.translate('profileAbout'),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  _SettingsTile(
                    icon: Icons.info_outline,
                    title: l10n.translate('profileAboutApp'),
                    subtitle: l10n.translate('profileVersion'),
                    onTap: () {
                      _showAboutDialog(context);
                    },
                    isDark: isDark,
                  ),
                  const SizedBox(height: 8),
                  
                  _SettingsTile(
                    icon: Icons.privacy_tip_outlined,
                    title: l10n.translate('profilePrivacy'),
                    onTap: () {
                      _showInfoDialog(
                        context,
                        l10n.translate('profilePrivacy'),
                        l10n.translate('privacyContent'),
                      );
                    },
                    isDark: isDark,
                  ),
                  const SizedBox(height: 8),
                  
                  _SettingsTile(
                    icon: Icons.description_outlined,
                    title: l10n.translate('profileTerms'),
                    onTap: () {
                      _showInfoDialog(
                        context,
                        l10n.translate('profileTerms'),
                        l10n.translate('termsContent'),
                      );
                    },
                    isDark: isDark,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: () => _logout(context),
                      icon: const Icon(Icons.logout_rounded),
                      label: Text(l10n.translate('profileLogout')),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: BorderSide(color: AppColors.error.withOpacity(0.5)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEnglish = l10n.translate('appName') == 'PeekFit';
    
    showAboutDialog(
      context: context,
      applicationName: 'PeekFit',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkSurface
              : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Icon(Icons.checkroom_rounded, size: 30),
      ),
      children: [
        Text(
          isEnglish
              ? 'Virtual try-on and wardrobe management app. '
                'Try on clothes virtually, manage your wardrobe and '
                'track prices.'
              : 'Sanal kıyafet deneme ve gardırop yönetim uygulaması. '
                'Kıyafetlerinizi sanal olarak deneyin, gardırobunuzu yönetin ve '
                'fiyat takibi yapın.',
        ),
      ],
    );
  }
  
  void _showInfoDialog(BuildContext context, String title, String content) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(content),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.translate('ok')),
          ),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Çıkış Yap'),
        content: const Text('Çıkış yapmak istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Çıkış Yap'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await Provider.of<UserProvider>(context, listen: false).logout();
      
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;
  final bool isDark;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
          ),
        ),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        trailing: trailing ?? const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}

// Separate widget for subscription card
class _SubscriptionCard extends StatelessWidget {
  final UserProvider userProvider;
  final bool isDark;
  final AppLocalizations l10n;

  const _SubscriptionCard({
    required this.userProvider,
    required this.isDark,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final subscription = userProvider.subscription;
    
    // No subscription
    if (subscription == null || !subscription.hasSubscription) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.diamond_outlined,
              size: 48,
              color: isDark ? Colors.grey[600] : Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              l10n.translate('freePlanTitle'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.translate('freePlanWarning'),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SubscriptionScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
              ),
              child: Text(l10n.translate('selectPlan')),
            ),
          ],
        ),
      );
    }
    
    // Active subscription
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: isDark ? AppColors.darkGradient : AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : AppColors.lightPrimary).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subscription.plan ?? 'Plan',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  subscription.isActive ? l10n.translate('subPlanActive') : l10n.translate('subExpired'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Icon(
                Icons.diamond_rounded,
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(width: 12),
              Text(
                '${subscription.remainingCredits}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '/${subscription.monthlyCredits}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 24,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                l10n.translate('creditCurrentAmount'),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: subscription.progressPercentage,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${l10n.translate('subRenewal')} ${subscription.daysRemaining} ${l10n.translate('subDaysLater')}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
