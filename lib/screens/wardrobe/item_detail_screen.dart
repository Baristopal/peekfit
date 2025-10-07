import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../models/clothing_item.dart';
import '../../providers/wardrobe_provider.dart';
import '../../l10n/app_localizations.dart';

class ItemDetailScreen extends StatefulWidget {
  final ClothingItem item;

  const ItemDetailScreen({super.key, required this.item});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  late TextEditingController _productUrlController;
  late TextEditingController _priceController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _productUrlController = TextEditingController(text: widget.item.productUrl ?? '');
    _priceController = TextEditingController(
      text: widget.item.price != null ? widget.item.price.toString() : '',
    );
  }

  @override
  void dispose() {
    _productUrlController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final updatedItem = widget.item.copyWith(
      productUrl: _productUrlController.text.isEmpty ? null : _productUrlController.text,
      price: _priceController.text.isEmpty ? null : double.tryParse(_priceController.text),
      lastChecked: DateTime.now(),
    );

    await Provider.of<WardrobeProvider>(context, listen: false).updateItem(updatedItem);
    
    setState(() => _isEditing = false);
    
    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.translate('wardrobeChangesSaved'))),
      );
    }
  }

  Future<void> _openProductUrl() async {
    if (widget.item.productUrl != null) {
      final uri = Uri.parse(widget.item.productUrl!);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  Future<void> _deleteItem() async {
    final l10n = AppLocalizations.of(context)!;
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.translate('wardrobeDeleteTitle')),
        content: Text(l10n.translate('wardrobeDeleteConfirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.translate('addToWardrobeCancel')),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(l10n.translate('wardrobeDeleteButton')),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await Provider.of<WardrobeProvider>(context, listen: false)
          .removeFromWardrobe(widget.item.id);
      
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.translate('wardrobeItemDeleted'))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _deleteItem,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            if (widget.item.imagePath != null)
              Container(
                width: double.infinity,
                height: 400,
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                child: Image.file(
                  File(widget.item.imagePath!),
                  fit: BoxFit.contain,
                ),
              )
            else if (widget.item.clothingUrl != null)
              Container(
                width: double.infinity,
                height: 400,
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                child: CachedNetworkImage(
                  imageUrl: widget.item.clothingUrl!,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              )
            else
              Container(
                width: double.infinity,
                height: 400,
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                child: Icon(
                  Icons.checkroom_rounded,
                  size: 120,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                    child: Text(
                      widget.item.category,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Product URL
                  if (!widget.item.hasProductLink) ...[
                    Text(
                      l10n.translate('wardrobeProductLink'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _productUrlController,
                      decoration: const InputDecoration(
                        hintText: 'https://...',
                        prefixIcon: Icon(Icons.link_outlined),
                      ),
                      keyboardType: TextInputType.url,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveChanges,
                        child: Text(l10n.translate('wardrobeSaveButton')),
                      ),
                    ),
                  ] else ...[
                    Text(
                      l10n.translate('wardrobeProductLink'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: _openProductUrl,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.info.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.info.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.link_rounded,
                              color: AppColors.info,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                widget.item.productUrl!,
                                style: TextStyle(
                                  color: AppColors.info,
                                  decoration: TextDecoration.underline,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(
                              Icons.open_in_new_rounded,
                              color: AppColors.info,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  
                  // Price & Stock - Only show if product link exists
                  if (widget.item.hasProductLink) ...[
                    const SizedBox(height: 24),
                    
                    // Price
                    if (widget.item.price != null) ...[
                      Text(
                        'Fiyat',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${widget.item.price!.toStringAsFixed(2)} ₺',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 24),
                    ],
                    
                    // Stock Status
                    if (widget.item.inStock != null) ...[
                      Text(
                        'Stok Durumu',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: widget.item.inStock!
                              ? AppColors.success.withOpacity(0.1)
                              : AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              widget.item.inStock!
                                  ? Icons.check_circle_rounded
                                  : Icons.cancel_rounded,
                              color: widget.item.inStock! ? AppColors.success : AppColors.error,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.item.inStock! ? 'Stokta Var' : 'Stokta Yok',
                              style: TextStyle(
                                color: widget.item.inStock! ? AppColors.success : AppColors.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                  
                  const SizedBox(height: 24),
                  
                  // Added Date
                  Text(
                    'Eklenme Tarihi',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${widget.item.addedDate.day}/${widget.item.addedDate.month}/${widget.item.addedDate.year}',
                    style: Theme.of(context).textTheme.bodyLarge,
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
