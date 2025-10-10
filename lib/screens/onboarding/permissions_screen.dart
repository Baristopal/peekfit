import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';

class PermissionsScreen extends StatefulWidget {
  final VoidCallback onComplete;
  
  const PermissionsScreen({
    super.key,
    required this.onComplete,
  });

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  bool _cameraGranted = false;
  bool _photosGranted = false;
  bool _notificationsGranted = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final camera = await Permission.camera.status;
    final photos = await Permission.photos.status;
    final notifications = await Permission.notification.status;
    
    setState(() {
      _cameraGranted = camera.isGranted;
      _photosGranted = photos.isGranted;
      _notificationsGranted = notifications.isGranted;
    });
  }

  Future<void> _requestCamera() async {
    final status = await Permission.camera.request();
    setState(() => _cameraGranted = status.isGranted);
    
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  Future<void> _requestPhotos() async {
    final status = await Permission.photos.request();
    setState(() => _photosGranted = status.isGranted);
    
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  Future<void> _requestNotifications() async {
    final status = await Permission.notification.request();
    setState(() => _notificationsGranted = status.isGranted);
    
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  Future<void> _requestAllPermissions() async {
    setState(() => _isLoading = true);
    
    final results = await [
      Permission.camera,
      Permission.photos,
      Permission.notification,
    ].request();
    
    setState(() {
      _cameraGranted = results[Permission.camera]?.isGranted ?? false;
      _photosGranted = results[Permission.photos]?.isGranted ?? false;
      _notificationsGranted = results[Permission.notification]?.isGranted ?? false;
      _isLoading = false;
    });
    
    // If permanently denied, open settings
    if (results[Permission.camera]?.isPermanentlyDenied == true ||
        results[Permission.photos]?.isPermanentlyDenied == true ||
        results[Permission.notification]?.isPermanentlyDenied == true) {
      await openAppSettings();
      return;
    }
    
    if (_cameraGranted && _photosGranted && _notificationsGranted) {
      widget.onComplete();
    }
  }

  bool get _allGranted => _cameraGranted && _photosGranted && _notificationsGranted;

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
              
              // Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.darkPrimary : AppColors.lightPrimary).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.security_rounded,
                  size: 50,
                  color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Title
              Text(
                l10n.translate('onboardingPermissionsTitle'),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              // Subtitle
              Text(
                l10n.translate('onboardingPermissionsSubtitle'),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 48),
              
              // Camera Permission
              _PermissionItem(
                icon: Icons.camera_alt_rounded,
                title: l10n.translate('onboardingPermissionCamera'),
                subtitle: l10n.translate('onboardingPermissionCameraDesc'),
                isGranted: _cameraGranted,
                onTap: _requestCamera,
                isDark: isDark,
              ),
              
              const SizedBox(height: 16),
              
              // Photos Permission
              _PermissionItem(
                icon: Icons.photo_library_rounded,
                title: l10n.translate('onboardingPermissionPhotos'),
                subtitle: l10n.translate('onboardingPermissionPhotosDesc'),
                isGranted: _photosGranted,
                onTap: _requestPhotos,
                isDark: isDark,
              ),
              
              const SizedBox(height: 16),
              
              // Notifications Permission
              _PermissionItem(
                icon: Icons.notifications_rounded,
                title: l10n.translate('onboardingPermissionNotifications'),
                subtitle: l10n.translate('onboardingPermissionNotificationsDesc'),
                isGranted: _notificationsGranted,
                onTap: _requestNotifications,
                isDark: isDark,
              ),
              
              const Spacer(),
              
              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : (_allGranted ? widget.onComplete : _requestAllPermissions),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _allGranted
                                  ? l10n.translate('continue')
                                  : l10n.translate('onboardingAllowAll'),
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
                  _PageDot(isActive: false, isDark: isDark),
                  const SizedBox(width: 8),
                  _PageDot(isActive: true, isDark: isDark),
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

class _PermissionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isGranted;
  final VoidCallback onTap;
  final bool isDark;
  
  const _PermissionItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isGranted,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isGranted
              ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: isGranted ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: (isDark ? AppColors.darkPrimary : AppColors.lightPrimary).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
              size: 24,
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
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          if (isGranted)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 20,
              ),
            )
          else
            InkWell(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Allow',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
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
