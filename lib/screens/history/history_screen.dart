import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/wardrobe_provider.dart';
import '../../l10n/app_localizations.dart';
import '../wardrobe/item_detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    // Load history on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final wardrobeProvider = Provider.of<WardrobeProvider>(context, listen: false);
      wardrobeProvider.loadHistory();
    });
    
    // Setup scroll listener for infinite scroll
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      // Near bottom, load more
      _loadMoreHistory();
    }
  }

  Future<void> _loadMoreHistory() async {
    if (_isLoadingMore) return;
    
    final wardrobeProvider = Provider.of<WardrobeProvider>(context, listen: false);
    
    // Check if there are more items to load
    if (wardrobeProvider.history.length >= wardrobeProvider.historyTotalCount) {
      return; // All items loaded
    }
    
    setState(() => _isLoadingMore = true);
    
    try {
      await wardrobeProvider.loadMoreHistory();
    } finally {
      if (mounted) {
        setState(() => _isLoadingMore = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final wardrobeProvider = Provider.of<WardrobeProvider>(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navHistory),
        actions: [
          if (wardrobeProvider.history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _showClearHistoryDialog(context),
            ),
        ],
      ),
      body: wardrobeProvider.history.isEmpty
          ? _buildEmptyState(context, isDark)
          : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: wardrobeProvider.history.length,
              itemBuilder: (context, index) {
                // Show loading indicator at the end
                if (index == wardrobeProvider.history.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final historyItem = wardrobeProvider.history[index];
                final isToday = _isToday(historyItem.triedOnDate);
                final isYesterday = _isYesterday(historyItem.triedOnDate);
                
                // Show date header
                bool showDateHeader = false;
                if (index == 0) {
                  showDateHeader = true;
                } else {
                  final previousDate = wardrobeProvider.history[index - 1].triedOnDate;
                  showDateHeader = !_isSameDay(historyItem.triedOnDate, previousDate);
                }
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showDateHeader) ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 8, top: 8, bottom: 12),
                        child: Text(
                          isToday
                              ? l10n.translate('historyToday')
                              : isYesterday
                                  ? l10n.translate('historyYesterday')
                                  : DateFormat('d MMMM yyyy').format(historyItem.triedOnDate),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    _HistoryItemCard(
                      historyItem: historyItem,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 12),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_outlined,
            size: 80,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.translate('homeNoTryOnYet'),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              l10n.translate('homeNoHistoryDesc'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  bool _isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Future<void> _showClearHistoryDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.translate('historyClearTitle')),
        content: Text(l10n.translate('historyClearConfirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.translate('addToWardrobeCancel')),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(l10n.translate('historyClearButton')),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await Provider.of<WardrobeProvider>(context, listen: false).clearHistory();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.translate('historyCleared'))),
        );
      }
    }
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
              child: historyItem.item.imagePath != null
                  ? ClipRRect(
                      borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                      child: Image.file(
                        File(historyItem.item.imagePath!),
                        fit: BoxFit.cover,
                      ),
                    )
                  : historyItem.item.imageUrl != null
                      ? ClipRRect(
                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                          child: CachedNetworkImage(
                            imageUrl: historyItem.item.imageUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ),
                        )
                      : Icon(
                          Icons.checkroom_rounded,
                          size: 40,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
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
                    if (historyItem.item.brand != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        historyItem.item.brand!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      DateFormat('HH:mm').format(historyItem.triedOnDate),
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
