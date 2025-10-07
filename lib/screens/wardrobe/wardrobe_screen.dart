import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../models/clothing_item.dart';
import '../../providers/wardrobe_provider.dart';
import '../../l10n/app_localizations.dart';
import 'item_detail_screen.dart';

class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({super.key});

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> with AutomaticKeepAliveClientMixin {
  String _selectedCategory = 'all'; // Use 'all' as default
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Load wardrobe on init - REMOVED, will be loaded from HomeTab
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final wardrobeProvider = Provider.of<WardrobeProvider>(context);
    final l10n = AppLocalizations.of(context)!;
    
    print('🔵 WardrobeScreen: Building...');
    print('📦 Total items: ${wardrobeProvider.wardrobeItems.length}');
    print('🔄 Is loading: ${wardrobeProvider.isLoading}');
    print('🏷️ Selected category: $_selectedCategory');
    
    var filteredItems = _selectedCategory == 'all'
        ? wardrobeProvider.wardrobeItems
        : wardrobeProvider.getItemsByCategory(_selectedCategory);
    
    print('📦 Filtered items: ${filteredItems.length}');
    
    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filteredItems = filteredItems.where((item) {
        return item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               (item.brand?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      }).toList();
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('wardrobeTitle')),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: l10n.translate('wardrobeSearch'),
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          
          // Category Filter - Temporarily hidden
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   child: Row(
          //     children: [
          //       _CategoryChip(
          //         label: l10n.translate('wardrobeAll'),
          //         isSelected: _selectedCategory == l10n.translate('wardrobeAll'),
          //         onTap: () => setState(() => _selectedCategory = l10n.translate('wardrobeAll')),
          //         isDark: isDark,
          //       ),
          //       const SizedBox(width: 8),
          //       ...ClothingCategory.all.map((category) {
          //         return Padding(
          //           padding: const EdgeInsets.only(right: 8),
          //           child: _CategoryChip(
          //             label: ClothingCategory.getTranslatedName(category, l10n.translate),
          //             isSelected: _selectedCategory == category,
          //             onTap: () => setState(() => _selectedCategory = category),
          //             isDark: isDark,
          //           ),
          //         );
          //       }),
          //     ],
          //   ),
          // ),
          
          const SizedBox(height: 16),
          
          // Items Grid
          Expanded(
            child: filteredItems.isEmpty
                ? _buildEmptyState(isDark)
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      return _WardrobeItemCard(
                        item: filteredItems[index],
                        isDark: isDark,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.checkroom_outlined,
            size: 80,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.translate('wardrobeEmpty'),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              l10n.translate('wardrobeEmptyDesc'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
              : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? (isDark ? AppColors.darkBackground : Colors.white)
                : (isDark ? AppColors.darkText : AppColors.lightText),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _WardrobeItemCard extends StatelessWidget {
  final ClothingItem item;
  final bool isDark;

  const _WardrobeItemCard({
    required this.item,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ItemDetailScreen(item: item),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: item.imagePath != null
                          ? ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                              child: Image.file(
                                File(item.imagePath!),
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            )
                          : item.clothingUrl != null
                              ? ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                  child: CachedNetworkImage(
                                    imageUrl: item.clothingUrl!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                )
                              : Icon(
                                  Icons.checkroom_rounded,
                                  size: 48,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                ),
                    ),
                    
                    // Warning badge if no product link
                    if (item.needsProductLink)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.warning,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.link_off_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            
            // Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.category,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                  if (item.brand != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      item.brand!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
