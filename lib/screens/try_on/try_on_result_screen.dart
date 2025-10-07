import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../models/clothing_item.dart';
import '../../models/try_on_history.dart';
import '../../providers/wardrobe_provider.dart';
import '../../providers/user_provider.dart';
import '../subscription/subscription_screen.dart';
import 'add_to_wardrobe_dialog.dart';

class TryOnResultScreen extends StatefulWidget {
  final String? resultImageUrl;
  final File? userPhoto;
  final String? clothingImagePath;
  final String? clothingUrl;
  final String category;

  const TryOnResultScreen({
    super.key,
    this.resultImageUrl,
    this.userPhoto,
    this.clothingImagePath,
    this.clothingUrl,
    required this.category,
  });

  @override
  State<TryOnResultScreen> createState() => _TryOnResultScreenState();
}

class _TryOnResultScreenState extends State<TryOnResultScreen> {
  static const int _creditThreshold = 3; // Eşik değeri
  double _sliderPosition = 0.5; // 0.0 to 1.0
  
  @override
  void initState() {
    super.initState();
    // Show credit warning dialog after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowCreditWarning();
    });
  }
  
  void _checkAndShowCreditWarning() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final credits = userProvider.credits;
    final isCreditAlertEnabled = userProvider.isCreditAlertEnabled;
    
    // Only show dialogs if credit alert is enabled
    if (!isCreditAlertEnabled) {
      print('🔕 Credit alert disabled, skipping warning');
      return;
    }
    
    if (credits == 0) {
      _showNoCreditDialog();
    } else if (credits <= _creditThreshold) {
      _showLowCreditDialog(credits);
    }
  }
  
  void _showLowCreditDialog(int credits) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.warning),
            const SizedBox(width: 12),
            Text(l10n.translate('creditLowTitle')),
          ],
        ),
        content: Text(
          l10n.translate('creditLowMessage').replaceAll('{credits}', '$credits'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.translate('later')),
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
              backgroundColor: AppColors.warning,
            ),
            child: Text(l10n.translate('selectPlan')),
          ),
        ],
      ),
    );
  }
  
  void _showNoCreditDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        title: Row(
          children: [
            Icon(Icons.error_outline, color: AppColors.error),
            const SizedBox(width: 12),
            Text(l10n.translate('creditEmptyTitle')),
          ],
        ),
        content: Text(l10n.translate('creditEmptyMessage')),
        actions: [
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: Text(l10n.translate('tryOnResult')),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () => _shareResult(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Result Image with Before/After Slider
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: widget.resultImageUrl != null && widget.userPhoto != null
                    ? _buildBeforeAfterSlider(isDark)
                    : widget.resultImageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: widget.resultImageUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                              child: const Center(
                                child: Icon(Icons.error_outline, size: 48),
                              ),
                            ),
                          )
                        : widget.userPhoto != null
                            ? Image.file(
                                widget.userPhoto!,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                                child: const Center(
                                  child: Icon(Icons.image_outlined, size: 48),
                                ),
                              ),
              ),
            ),
          ),

          // Info Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.success,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.translate('tryOnSuccess'),
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.translate('tryOnSuccessDesc'),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Divider(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
                const SizedBox(height: 16),
                
                // Category Info
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.info.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.category_rounded,
                        color: AppColors.info,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.category,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Try Again Button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(l10n.translate('tryOnAgain')),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Add to Wardrobe Button
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddToWardrobeDialog(context),
                    icon: const Icon(Icons.add_rounded),
                    label: Text(
                      l10n.translate('addToWardrobeTitle'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ).copyWith(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddToWardrobeDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    print('🔵 Result Screen: Opening wardrobe dialog');
    print('📸 Result Image URL: ${widget.resultImageUrl}');
    print('👕 Clothing URL: ${widget.clothingUrl}');
    print('✅ Using: ${widget.resultImageUrl ?? widget.clothingUrl}');
    
    showDialog(
      context: context,
      builder: (context) => AddToWardrobeDialog(
        imagePath: widget.clothingImagePath,
        resultImageUrl: widget.resultImageUrl, // FAL result
        originalClothingUrl: widget.clothingUrl, // Original Zara
        onSave: (item) async {
          try {
            final wardrobeProvider = Provider.of<WardrobeProvider>(context, listen: false);
            
            final historyItem = TryOnHistory(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              item: item,
              triedOnDate: DateTime.now(),
              addedToWardrobe: true,
            );
            await wardrobeProvider.addToHistory(historyItem);
            await wardrobeProvider.addToWardrobe(item);
            
            if (context.mounted) {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Close result screen
              Navigator.of(context).pop(); // Close try-on screen
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.translate('success'))),
              );
            }
          } catch (e) {
            print('❌ Error saving to wardrobe: $e');
            if (context.mounted) {
              final l10n = AppLocalizations.of(context)!;
              Navigator.of(context).pop(); // Close dialog
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${l10n.translate('error')}: $e'),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          }
        },
      ),
    );
  }
  
  Future<void> _shareResult(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    
    try {
      if (widget.resultImageUrl != null) {
        // Share network image
        final response = await http.get(Uri.parse(widget.resultImageUrl!));
        final bytes = response.bodyBytes;
        final temp = await getTemporaryDirectory();
        final path = '${temp.path}/tryon_result.jpg';
        File(path).writeAsBytesSync(bytes);
        
        await Share.shareXFiles(
          [XFile(path)],
          text: l10n.translate('shareText'),
        );
      } else if (widget.userPhoto != null) {
        // Share local file
        await Share.shareXFiles(
          [XFile(widget.userPhoto!.path)],
          text: l10n.translate('shareText'),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.translate('error')}: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
  
  Widget _buildBeforeAfterSlider(bool isDark) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          _sliderPosition += details.delta.dx / context.size!.width;
          _sliderPosition = _sliderPosition.clamp(0.0, 1.0);
        });
      },
      child: Stack(
        children: [
          // After image (Result - full)
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: widget.resultImageUrl!,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
          
          // Before image (Original - clipped)
          Positioned.fill(
            child: ClipRect(
              clipper: _BeforeAfterClipper(_sliderPosition),
              child: Image.file(
                widget.userPhoto!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // Divider line
          Positioned(
            left: MediaQuery.of(context).size.width * _sliderPosition - 18,
            top: 0,
            bottom: 0,
            child: Container(
              width: 4,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ),
          
          // Slider handle
          Positioned(
            left: MediaQuery.of(context).size.width * _sliderPosition - 38,
            top: MediaQuery.of(context).size.height * 0.4,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Icon(
                Icons.compare_arrows,
                color: Colors.black,
                size: 24,
              ),
            ),
          ),
          
          // Labels
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'BEFORE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'AFTER',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BeforeAfterClipper extends CustomClipper<Rect> {
  final double progress;
  
  _BeforeAfterClipper(this.progress);
  
  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, size.width * progress, size.height);
  }
  
  @override
  bool shouldReclip(_BeforeAfterClipper oldClipper) {
    return oldClipper.progress != progress;
  }
}
