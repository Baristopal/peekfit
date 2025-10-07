import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../models/clothing_item.dart';
import '../../models/try_on_history.dart';
import '../../providers/wardrobe_provider.dart';
import '../../providers/user_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../services/api/try_on_api_service.dart';
import 'package:provider/provider.dart';
import 'add_to_wardrobe_dialog.dart';
import 'try_on_result_screen.dart';
import '../subscription/subscription_screen.dart';

class TryOnScreen extends StatefulWidget {
  final String? prefilledClothingUrl;
  
  const TryOnScreen({super.key, this.prefilledClothingUrl});

  @override
  State<TryOnScreen> createState() => _TryOnScreenState();
}

class _TryOnScreenState extends State<TryOnScreen> {
  File? _userPhoto;
  File? _clothingPhoto;
  String? _clothingUrl;
  String _selectedCategory = 'Upper Body';
  final _urlController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool _isProcessing = false;

  final List<String> _categories = ['Upper Body', 'Lower Body', 'Full Body'];

  @override
  void initState() {
    super.initState();
    if (widget.prefilledClothingUrl != null) {
      _clothingUrl = widget.prefilledClothingUrl;
      _urlController.text = widget.prefilledClothingUrl!;
    }
    
    // Load credit when try-on screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.loadCredit();
    });
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _showPhotoSourceDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.translate('tryOnPhotoSelect'),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                _PhotoSourceOption(
                  icon: Icons.camera_alt_rounded,
                  title: l10n.translate('tryOnCamera'),
                  subtitle: l10n.translate('tryOnCameraDesc'),
                  color: AppColors.info,
                  isDark: isDark,
                  onTap: () {
                    Navigator.pop(context);
                    _pickPhoto(ImageSource.camera);
                  },
                ),
                const SizedBox(height: 16),
                _PhotoSourceOption(
                  icon: Icons.photo_library_rounded,
                  title: l10n.translate('tryOnGallery'),
                  subtitle: l10n.translate('tryOnGalleryDesc'),
                  color: AppColors.success,
                  isDark: isDark,
                  onTap: () {
                    Navigator.pop(context);
                    _pickPhoto(ImageSource.gallery);
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickPhoto(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _userPhoto = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.translate('tryOnPhotoError')}: $e')),
        );
      }
    }
  }

  Future<void> _pickClothingPhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _clothingPhoto = File(image.path);
          _clothingUrl = null;
          _urlController.clear();
        });
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.translate('tryOnPhotoError')}: $e')),
        );
      }
    }
  }
  
  void setClothingFromUrl(String url) {
    setState(() {
      _clothingUrl = url;
      _clothingPhoto = null;
      _urlController.text = url;
    });
  }

  Future<void> _startTryOn() async {
    final l10n = AppLocalizations.of(context)!;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    if (_userPhoto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.translate('tryOnErrorNoPhoto'))),
      );
      return;
    }

    if (_clothingPhoto == null && (_clothingUrl == null || _clothingUrl!.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.translate('tryOnErrorNoClothing'))),
      );
      return;
    }

    // Credit kontrolü
    if (userProvider.credits <= 0) {
      // Credit yok, satın alma ekranına yönlendir
      _showNoCreditDialog();
      return;
    }

    // Credit var, onay iste
    final confirmed = await _showCreditConfirmDialog();
    if (!confirmed) {
      return;
    }

    setState(() => _isProcessing = true);

    try {
      print('🔵 TryOn: Starting virtual try-on...');
      
      // Determine target area from category
      TargetArea targetArea;
      switch (_selectedCategory) {
        case 'Upper Body':
          targetArea = TargetArea.upperBody;
          break;
        case 'Lower Body':
          targetArea = TargetArea.lowerBody;
          break;
        case 'Full Body':
          targetArea = TargetArea.fullBody;
          break;
        default:
          targetArea = TargetArea.upperBody;
      }

      // Call Try-On API
      final tryOnService = TryOnApiService();
      
      // Sadece birini gönder: ya URL ya da local file
      final result = await tryOnService.tryOn(
        userImagePath: _userPhoto!.path,
        targetArea: targetArea,
        clothingUrl: _clothingPhoto == null ? _clothingUrl : null, // Local file varsa URL gönderme
        clothingImagePath: _clothingPhoto?.path, // Local file varsa onu gönder
      );

      print('✅ TryOn: Success! Result: $result');

      // Update credit from backend response
      if (result['newCredit'] != null && mounted) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.updateCredit(result['newCredit']);
        print('💰 Credit updated: ${result['newCredit']}');
      }

      setState(() => _isProcessing = false);
      
      if (mounted) {
        // Navigate to result screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TryOnResultScreen(
              resultImageUrl: result['generatedImageUrl'], // Backend'den gelen URL
              userPhoto: _userPhoto,
              clothingImagePath: _clothingPhoto?.path,
              clothingUrl: _clothingUrl,
              category: _selectedCategory,
            ),
          ),
        );
      }
    } catch (e) {
      print('❌ TryOn: Failed - $e');
      
      setState(() => _isProcessing = false);
      
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.translate('tryOnFailed')}: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<bool> _showCreditConfirmDialog() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;
    
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        title: Text(l10n.translate('creditUseTitle')),
        content: Text(
          l10n.translate('creditUseMessage').replaceAll('{credits}', '${userProvider.credits}'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.translate('no')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
            ),
            child: Text(l10n.translate('yes')),
          ),
        ],
      ),
    ) ?? false;
  }

  void _showNoCreditDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        title: Text(l10n.translate('insufficientCredit')),
        content: Text(l10n.translate('insufficientCreditSubscription')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.translate('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
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

  void _showAddToWardrobeDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AddToWardrobeDialog(
        imagePath: _clothingPhoto?.path,
        resultImageUrl: null,
        originalClothingUrl: _clothingUrl,
        onSave: (item) async {
          final wardrobeProvider = Provider.of<WardrobeProvider>(context, listen: false);
          
          final historyItem = TryOnHistory(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            item: item,
            triedOnDate: DateTime.now(),
            addedToWardrobe: true,
          );
          await wardrobeProvider.addToHistory(historyItem);
          await wardrobeProvider.addToWardrobe(item);
          
          if (mounted) {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.translate('success'))),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('tryOnTitle')),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Photo & Clothing Photo Side by Side
              Row(
                children: [
                  // User Photo
                  Expanded(
                    child: GestureDetector(
                      onTap: _showPhotoSourceDialog,
                      child: Container(
                        height: 250,
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                            width: 2,
                          ),
                        ),
                        child: _userPhoto == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: (isDark ? AppColors.darkBorder : AppColors.lightBorder).withOpacity(0.3),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.camera_alt_rounded,
                                      size: 30,
                                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    l10n.translate('tryOnYourPhoto'),
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    l10n.translate('tryOnTapToSelect'),
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                    ),
                                  ),
                                ],
                              )
                            : Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: Image.file(
                                      _userPhoto!,
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () => setState(() => _userPhoto = null),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.6),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close_rounded,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Clothing Photo
                  Expanded(
                    child: GestureDetector(
                      onTap: _pickClothingPhoto,
                      child: Container(
                        height: 250,
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                            width: 2,
                          ),
                        ),
                        child: _clothingPhoto == null && (_clothingUrl == null || _clothingUrl!.isEmpty)
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: (isDark ? AppColors.darkBorder : AppColors.lightBorder).withOpacity(0.3),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.checkroom_rounded,
                                      size: 30,
                                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    l10n.translate('tryOnClothingImage'),
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    l10n.translate('tryOnTapToSelect'),
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                    ),
                                  ),
                                ],
                              )
                            : Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: _clothingPhoto != null
                                        ? Image.file(
                                            _clothingPhoto!,
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                          )
                                        : CachedNetworkImage(
                                            imageUrl: _clothingUrl!,
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) => const Center(
                                              child: CircularProgressIndicator(),
                                            ),
                                            errorWidget: (context, url, error) => const Icon(Icons.error),
                                          ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () => setState(() {
                                        _clothingPhoto = null;
                                        _clothingUrl = null;
                                        _urlController.clear();
                                      }),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.6),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close_rounded,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Clothing Category
              Text(
                'Clothing Category',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _categories.map((category) {
                    final isSelected = _selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _selectedCategory = category);
                          }
                        },
                        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                        selectedColor: AppColors.info,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : (isDark ? AppColors.darkText : AppColors.lightText),
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                        side: BorderSide(
                          color: isSelected ? AppColors.info : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              
              // Optional: Add URL instead
              if (_clothingPhoto == null && (_clothingUrl == null || _clothingUrl!.isEmpty)) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Divider(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'OR',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _urlController,
                  decoration: InputDecoration(
                    hintText: 'Paste clothing URL here...',
                    prefixIcon: const Icon(Icons.link_rounded),
                    filled: true,
                    fillColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  ),
                  keyboardType: TextInputType.url,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        _clothingUrl = value;
                        _clothingPhoto = null;
                      });
                    }
                  },
                ),
              ],
              
              const SizedBox(height: 32),
              
              // Start Try-On Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _startTryOn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.info,
                    foregroundColor: Colors.white,
                  ),
                  child: _isProcessing
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Start Try-On',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhotoSourceOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;

  const _PhotoSourceOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: (isDark ? AppColors.darkCard : AppColors.lightCard),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
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
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
