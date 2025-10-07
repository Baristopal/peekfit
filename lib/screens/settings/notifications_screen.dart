import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../models/notification_settings.dart';
import '../../providers/user_provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final userProvider = Provider.of<UserProvider>(context);
    final settings = userProvider.notificationSettings ?? NotificationSettings(
      creditAlert: true,
      priceDrop: true,
      stockAlert: true,
      newFeatures: true,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('profileNotifications')),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            l10n.translate('profileNotifications'),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.translate('profileNotificationsDesc'),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 32),
          
          _NotificationTile(
            title: l10n.translate('notifCreditAlert'),
            subtitle: l10n.translate('notifCreditAlertDesc'),
            value: settings.creditAlert,
            onChanged: _isLoading ? null : (value) => _updateSetting('creditAlert', value, settings),
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          
          _NotificationTile(
            title: l10n.translate('notifPriceDrop'),
            subtitle: l10n.translate('notifPriceDropDesc'),
            value: settings.priceDrop,
            onChanged: _isLoading ? null : (value) => _updateSetting('priceDrop', value, settings),
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          
          _NotificationTile(
            title: l10n.translate('notifStockAlert'),
            subtitle: l10n.translate('notifStockAlertDesc'),
            value: settings.stockAlert,
            onChanged: _isLoading ? null : (value) => _updateSetting('stockAlert', value, settings),
            isDark: isDark,
          ),
        ],
      ),
    );
  }
  
  Future<void> _updateSetting(String key, bool value, NotificationSettings current) async {
    setState(() => _isLoading = true);
    
    NotificationSettings newSettings;
    switch (key) {
      case 'creditAlert':
        newSettings = current.copyWith(creditAlert: value);
        break;
      case 'priceDrop':
        newSettings = current.copyWith(priceDrop: value);
        break;
      case 'stockAlert':
        newSettings = current.copyWith(stockAlert: value);
        break;
      case 'newFeatures':
        newSettings = current.copyWith(newFeatures: value);
        break;
      default:
        return;
    }
    
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final success = await userProvider.updateNotificationSettings(newSettings);
    
    setState(() => _isLoading = false);
    
    if (mounted && success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.translate('notifSettingsSaved'))),
      );
    }
  }
}

class _NotificationTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool isDark;

  const _NotificationTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
          ),
        ],
      ),
    );
  }
}
