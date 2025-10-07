import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/wardrobe_provider.dart';
import '../../providers/user_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../services/sample_data_service.dart';
import '../../models/clothing_item.dart';
import '../try_on/try_on_screen.dart';
import '../history/history_screen.dart';
import '../wardrobe/item_detail_screen.dart';
import '../subscription/credit_purchase_screen.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin {
  static bool _hasLoadedInitialData = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Load wardrobe, credit, subscription and notifications ONCE on first init
    if (!_hasLoadedInitialData) {
      _hasLoadedInitialData = true; // Set IMMEDIATELY to prevent double load
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final wardrobeProvider = Provider.of<WardrobeProvider>(context, listen: false);
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        
        wardrobeProvider.loadWardrobe();
        userProvider.loadCredit();
        userProvider.loadSubscription();
        userProvider.loadNotificationSettings(); // Load notification settings
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userProvider = Provider.of<UserProvider>(context);
    final wardrobeProvider = Provider.of<WardrobeProvider>(context);
    final l10n = AppLocalizations.of(context)!;
    
    final recommendedClothes = SampleDataService.getRecommendedClothes();
    final recentHistory = wardrobeProvider.history.take(3).toList();
    
    // Count items without product URL
    final itemsNeedingLinks = wardrobeProvider.wardrobeItems
        .where((item) => item.productUrl == null || item.productUrl!.isEmpty)
        .length;
    
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'PeekFit',
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Credit Badge
                            GestureDetector(
                              onTap: () {
                                // Navigate to credit purchase screen
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const CreditPurchaseScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: isDark 
                                      ? AppColors.darkSurface.withOpacity(0.8)
                                      : AppColors.lightSurface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isDark 
                                        ? AppColors.darkBorder
                                        : AppColors.lightBorder,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.account_balance_wallet_outlined,
                                      color: isDark 
                                          ? Colors.grey[400]
                                          : Colors.grey[600],
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${userProvider.credits}',
                                      style: TextStyle(
                                        color: isDark 
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                            ),
                          ),
                          child: Icon(
                            Icons.notifications_outlined,
                            color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Warning Card if items need links
            if (itemsNeedingLinks > 0)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.warning.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: AppColors.warning,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.translate('homeWarningTitle'),
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: isDark ? AppColors.darkText : AppColors.lightText,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${itemsNeedingLinks} ${l10n.translate('homeWarningDesc')}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            
            // Main Try On Button
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const TryOnScreen()),
                    );
                  },
                  child: Container(
                    height: 180,
                    decoration: BoxDecoration(
                      gradient: isDark ? AppColors.darkGradient : AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: (isDark ? Colors.black : Colors.black).withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -20,
                            bottom: -20,
                            child: Icon(
                              Icons.checkroom_rounded,
                              size: 120,
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.auto_awesome_rounded,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  l10n.translate('tryOnTitle'),
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  l10n.translate('tryOnTitle') == 'Virtual Try-On' 
                                    ? 'See clothes on yourself\nwith AI'
                                    : 'Yapay zeka ile kıyafetleri\nüzerinizde görün',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                    height: 1.3,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
            
            // Quick Stats
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.checkroom_rounded,
                        title: l10n.navWardrobe,
                        value: '${wardrobeProvider.wardrobeItems.length}',
                        color: AppColors.info,
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.history_rounded,
                        title: l10n.navHistory,
                        value: '${wardrobeProvider.historyTotalCount}',
                        color: AppColors.success,
                        isDark: isDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
            
            // Recommended Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.translate('homeRecommendedTitle'),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: Show all recommended
                      },
                      child: Text(l10n.translate('homeViewAllButton')),
                    ),
                  ],
                ),
              ),
            ),
            
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            
            // Recommended Items Horizontal List
            SliverToBoxAdapter(
              child: SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: recommendedClothes.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        right: index < recommendedClothes.length - 1 ? 16 : 0,
                      ),
                      child: _RecommendedItemCard(
                        item: recommendedClothes[index],
                        isDark: isDark,
                      ),
                    );
                  },
                ),
              ),
            ),
            
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
            
            // Recent Try-Ons
            if (recentHistory.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    l10n.translate('homePreviousTitle'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final historyItem = recentHistory[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        left: 24,
                        right: 24,
                        bottom: index == recentHistory.length - 1 ? 24 : 12,
                      ),
                      child: _HistoryItemCard(
                        historyItem: historyItem,
                        isDark: isDark,
                      ),
                    );
                  },
                  childCount: recentHistory.length,
                ),
              ),
            ] else ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.translate('homeNoTryOnYet'),
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.translate('homeNoTryOnDesc'),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final bool isDark;
  final bool fullWidth;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    required this.isDark,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _RecommendedItemCard extends StatelessWidget {
  final ClothingItem item;
  final bool isDark;

  const _RecommendedItemCard({
    required this.item,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to try-on screen with clothing URL pre-filled
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TryOnScreen(
              prefilledClothingUrl: item.imageUrl,
            ),
          ),
        );
      },
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: CachedNetworkImage(
            imageUrl: item.imageUrl!,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}

class _HistoryItemCard extends StatelessWidget {
  final dynamic historyItem;
  final bool isDark;

  const _HistoryItemCard({
    required this.historyItem,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Row(
          children: [
            // Image
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                child: historyItem.item.imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: historyItem.item.imageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      )
                    : Icon(
                        Icons.checkroom_rounded,
                        size: 40,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
              ),
            ),
            
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            historyItem.item.name,
                            style: Theme.of(context).textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (historyItem.addedToWardrobe)
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              Icons.check_circle_rounded,
                              size: 16,
                              color: AppColors.success,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      historyItem.item.category,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
    );
  }
}
