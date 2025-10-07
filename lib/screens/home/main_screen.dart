import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/wardrobe_provider.dart';
import 'home_tab.dart';
import '../wardrobe/wardrobe_screen.dart';
import '../history/history_screen.dart';
import '../profile/profile_screen.dart';
import '../try_on/try_on_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeTab(),
    const WardrobeScreen(),
    const HistoryScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 65,
            child: Row(
              children: [
                Expanded(
                  child: _NavBarItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home_rounded,
                    label: l10n.navHome,
                    isActive: _currentIndex == 0,
                    onTap: () => setState(() => _currentIndex = 0),
                    isDark: isDark,
                  ),
                ),
                Expanded(
                  child: _NavBarItem(
                    icon: Icons.checkroom_outlined,
                    activeIcon: Icons.checkroom_rounded,
                    label: l10n.navWardrobe,
                    isActive: _currentIndex == 1,
                    onTap: () => setState(() => _currentIndex = 1),
                    isDark: isDark,
                  ),
                ),
                Expanded(
                  child: Transform.translate(
                    offset: const Offset(0, -15),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const TryOnScreen()),
                        );
                      },
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white : Colors.black,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: (isDark ? Colors.white : Colors.black).withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.auto_awesome_rounded,
                          color: isDark ? Colors.black : Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _NavBarItem(
                    icon: Icons.history_outlined,
                    activeIcon: Icons.history_rounded,
                    label: l10n.navHistory,
                    isActive: _currentIndex == 2,
                    onTap: () {
                      setState(() => _currentIndex = 2);
                      // Trigger history reload
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        final wardrobeProvider = Provider.of<WardrobeProvider>(context, listen: false);
                        wardrobeProvider.loadHistory();
                      });
                    },
                    isDark: isDark,
                  ),
                ),
                Expanded(
                  child: _NavBarItem(
                    icon: Icons.person_outline,
                    activeIcon: Icons.person_rounded,
                    label: l10n.navProfile,
                    isActive: _currentIndex == 3,
                    onTap: () => setState(() => _currentIndex = 3),
                    isDark: isDark,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final bool isDark;
  final bool isPrimary;

  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.isDark,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isPrimary
        ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
        : isActive
            ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
            : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: color,
              size: isPrimary ? 28 : 24,
            ),
            const SizedBox(height: 4),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: isPrimary ? 12 : 11,
                  color: color,
                  fontWeight: (isActive || isPrimary) ? FontWeight.w600 : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
