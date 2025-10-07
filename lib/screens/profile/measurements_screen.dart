import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../models/user_model.dart';
import '../../providers/user_provider.dart';
import '../../l10n/app_localizations.dart';

class MeasurementsScreen extends StatefulWidget {
  const MeasurementsScreen({super.key});

  @override
  State<MeasurementsScreen> createState() => _MeasurementsScreenState();
}

class _MeasurementsScreenState extends State<MeasurementsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _chestController = TextEditingController();
  final _waistController = TextEditingController();
  final _hipsController = TextEditingController();
  String _recommendedSize = '';
  bool _isCalculated = false;

  @override
  void initState() {
    super.initState();
    _loadExistingMeasurements();
  }

  void _loadExistingMeasurements() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.hasMeasurements) {
      final measurements = userProvider.user!.measurements!;
      _heightController.text = measurements.height.toString();
      _weightController.text = measurements.weight.toString();
      _chestController.text = measurements.chest.toString();
      _waistController.text = measurements.waist.toString();
      _hipsController.text = measurements.hips.toString();
      _recommendedSize = measurements.recommendedSize;
      _isCalculated = true;
    }
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _chestController.dispose();
    _waistController.dispose();
    _hipsController.dispose();
    super.dispose();
  }

  void _calculateSize() {
    if (_formKey.currentState!.validate()) {
      final height = double.parse(_heightController.text);
      final weight = double.parse(_weightController.text);
      final chest = double.parse(_chestController.text);
      final waist = double.parse(_waistController.text);

      setState(() {
        _recommendedSize = UserMeasurements.calculateSize(height, weight, chest, waist);
        _isCalculated = true;
      });
    }
  }

  Future<void> _saveMeasurements() async {
    if (_formKey.currentState!.validate()) {
      final l10n = AppLocalizations.of(context)!;
      
      // Call backend API
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final recommendedSize = await userProvider.saveMeasurements(
        height: int.parse(_heightController.text),
        weight: int.parse(_weightController.text),
        chest: int.parse(_chestController.text),
        waist: int.parse(_waistController.text),
        hips: int.parse(_hipsController.text),
        shoulderWidth: 0, // TODO: Add shoulder width field
      );
      
      // Update local state
      setState(() {
        _recommendedSize = recommendedSize;
        _isCalculated = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.translate('measurementsSaved'))),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('profileMeasurements')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Card
              Container(
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
                      Icons.info_outline,
                      color: AppColors.info,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.translate('measurementsInfo'),
                        style: TextStyle(color: AppColors.info),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Height
              Text(
                l10n.translate('measurementsHeight'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: '170',
                  prefixIcon: Icon(Icons.height_rounded),
                  suffixText: 'cm',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.translate('measurementsHeightError');
                  }
                  final height = double.tryParse(value);
                  if (height == null || height < 100 || height > 250) {
                    return l10n.translate('measurementsHeightInvalid');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Weight
              Text(
                l10n.translate('measurementsWeight'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: '70',
                  prefixIcon: Icon(Icons.monitor_weight_outlined),
                  suffixText: 'kg',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.translate('measurementsWeightError');
                  }
                  final weight = double.tryParse(value);
                  if (weight == null || weight < 30 || weight > 200) {
                    return l10n.translate('measurementsWeightInvalid');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Chest
              Text(
                l10n.translate('measurementsChest'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _chestController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: '95',
                  prefixIcon: Icon(Icons.straighten_rounded),
                  suffixText: 'cm',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.translate('measurementsChestError');
                  }
                  final chest = double.tryParse(value);
                  if (chest == null || chest < 60 || chest > 150) {
                    return l10n.translate('measurementsChestInvalid');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Waist
              Text(
                l10n.translate('measurementsWaist'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _waistController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: '80',
                  prefixIcon: Icon(Icons.straighten_rounded),
                  suffixText: 'cm',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.translate('measurementsWaistError');
                  }
                  final waist = double.tryParse(value);
                  if (waist == null || waist < 50 || waist > 150) {
                    return l10n.translate('measurementsWaistInvalid');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Hips
              Text(
                l10n.translate('measurementsHips'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _hipsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: '100',
                  prefixIcon: Icon(Icons.straighten_rounded),
                  suffixText: 'cm',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.translate('measurementsHipsError');
                  }
                  final hips = double.tryParse(value);
                  if (hips == null || hips < 60 || hips > 150) {
                    return l10n.translate('measurementsHipsInvalid');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Calculate Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: _calculateSize,
                  icon: const Icon(Icons.calculate_rounded),
                  label: Text(l10n.translate('measurementsCalculate')),
                ),
              ),

              // Recommended Size Display
              if (_isCalculated) ...[
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: isDark ? AppColors.darkGradient : AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        l10n.translate('measurementsRecommended'),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _recommendedSize,
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.translate('measurementsCalculatedInfo'),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _isCalculated ? _saveMeasurements : null,
                  icon: const Icon(Icons.save_rounded),
                  label: Text(l10n.translate('save')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
