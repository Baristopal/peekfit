import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/before_after_slider.dart';

class PaywallScreen extends StatefulWidget {
  final VoidCallback onComplete;
  
  const PaywallScreen({
    super.key,
    required this.onComplete,
  });

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  int _selectedPlanIndex = 1; // Pro plan default
  bool _isLoading = false;

  final List<Map<String, dynamic>> _plans = [
    {
      'name': 'Starter',
      'credits': 10,
      'price': '₺99',
      'pricePerMonth': '99',
    },
    {
      'name': 'Pro',
      'credits': 50,
      'price': '₺299',
      'pricePerMonth': '299',
      'popular': true,
    },
    {
      'name': 'Business',
      'credits': 200,
      'price': '₺799',
      'pricePerMonth': '799',
    },
  ];

  Future<void> _purchase() async {
    setState(() => _isLoading = true);
    
    // TODO: Implement actual purchase logic
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() => _isLoading = false);
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Stack(
        children: [
          // Before/After Section (Full height)
          Positioned.fill(
            child: Stack(
              children: [
                const BeforeAfterSlider(
                  beforeImage: 'lib/assets/manken.jpg',
                  afterImage: 'lib/assets/generated_manken.jpeg',
                  autoAnimate: true,
                ),
                
                // Gradient overlay at bottom
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: screenHeight * 0.5,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.7),
                          Colors.black.withOpacity(0.95),
                        ],
                        stops: const [0.0, 0.3, 0.7, 1.0],
                      ),
                    ),
                  ),
                ),
                
                // Close button
                SafeArea(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: IconButton(
                        onPressed: () => widget.onComplete(),
                        icon: const Icon(Icons.close_rounded),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black.withOpacity(0.5),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Subscription Plans Section (Bottom)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Text(
                      l10n.translate('onboardingPaywallTitle'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.translate('onboardingPaywallSubtitle'),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    
                    // Plans
                    Row(
                    children: List.generate(_plans.length, (index) {
                      final plan = _plans[index];
                      final isSelected = _selectedPlanIndex == index;
                      final isPopular = plan['popular'] == true;
                      
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedPlanIndex = index),
                          child: Container(
                            margin: EdgeInsets.only(
                              left: index == 0 ? 0 : 4,
                              right: index == _plans.length - 1 ? 0 : 4,
                            ),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                                  : (isDark ? AppColors.darkCard : AppColors.lightCard),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                                    : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                if (isPopular)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.warning,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      l10n.translate('subPopular'),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                if (isPopular) const SizedBox(height: 4),
                                Text(
                                  plan['name'],
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : null,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${plan['credits']}',
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : null,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  l10n.translate('subCreditsPerMonth'),
                                  style: TextStyle(
                                    color: isSelected ? Colors.white70 : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                                    fontSize: 10,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  plan['price'],
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : null,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Purchase Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _purchase,
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
                          : Text(
                              l10n.translate('onboardingPurchase'),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Terms
                  Text(
                    l10n.translate('onboardingTermsHint'),
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        ],
      ),
    );
  }
}
