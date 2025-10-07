import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/clothing_item.dart';
import '../../l10n/app_localizations.dart';

class AddToWardrobeDialog extends StatefulWidget {
  final String? imagePath;
  final String? resultImageUrl; // FAL result image
  final String? originalClothingUrl; // Original Zara URL
  final Function(ClothingItem) onSave;

  const AddToWardrobeDialog({
    super.key,
    this.imagePath,
    this.resultImageUrl,
    this.originalClothingUrl,
    required this.onSave,
  });

  @override
  State<AddToWardrobeDialog> createState() => _AddToWardrobeDialogState();
}

class _AddToWardrobeDialogState extends State<AddToWardrobeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _productUrlController = TextEditingController();
  String _selectedCategory = ClothingCategory.tshirt;

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _productUrlController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final item = ClothingItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        imagePath: widget.imagePath,
        imageUrl: widget.resultImageUrl, // FAL result image
        category: _selectedCategory,
        brand: _brandController.text.isEmpty ? null : _brandController.text,
        clothingUrl: widget.originalClothingUrl, // Original Zara URL
        addedDate: DateTime.now(),
      );
      
      widget.onSave(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    
    return Dialog(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.translate('addToWardrobeTitle'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                
                // Name field
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: '${l10n.translate('addToWardrobeProductName')} *',
                    hintText: l10n.translate('addToWardrobeNameHint'),
                    prefixIcon: const Icon(Icons.label_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.translate('addToWardrobeProductName') == 'Product Name' ? 'Please enter product name' : 'Lütfen ürün adı girin';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Category dropdown
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: '${l10n.translate('addToWardrobeCategory')} *',
                    prefixIcon: const Icon(Icons.category_outlined),
                  ),
                  items: ClothingCategory.all.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(ClothingCategory.getTranslatedName(category, l10n.translate)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedCategory = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                
                // Brand field
                TextFormField(
                  controller: _brandController,
                  decoration: InputDecoration(
                    labelText: '${l10n.translate('addToWardrobeBrand')} (${l10n.translate('addToWardrobeCancel') == 'Cancel' ? 'Optional' : 'Opsiyonel'})',
                    hintText: l10n.translate('addToWardrobeBrandHint'),
                    prefixIcon: const Icon(Icons.store_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Product URL field
                TextFormField(
                  controller: _productUrlController,
                  decoration: InputDecoration(
                    labelText: '${l10n.translate('addToWardrobeProductLink')} (${l10n.translate('addToWardrobeCancel') == 'Cancel' ? 'Optional' : 'Opsiyonel'})',
                    hintText: l10n.translate('addToWardrobeLinkHint'),
                    prefixIcon: const Icon(Icons.link_outlined),
                  ),
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 8),
                
                // Info text
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: AppColors.info,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.translate('addToWardrobeCancel') == 'Cancel'
                              ? 'If you add product link, we can track price and stock'
                              : 'Ürün linki eklerseniz fiyat ve stok takibi yapabiliriz',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.info,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(l10n.translate('addToWardrobeCancel')),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _save,
                        child: Text(l10n.translate('addToWardrobeSave')),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
