import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PropertyFilterWidget extends StatefulWidget {
  final String selectedType;
  final double minPrice;
  final double maxPrice;
  final double radiusKm;
  final Function(String type, double min, double max, double radius)
      onApplyFilter;

  const PropertyFilterWidget({
    Key? key,
    required this.selectedType,
    required this.minPrice,
    required this.maxPrice,
    required this.radiusKm,
    required this.onApplyFilter,
  }) : super(key: key);

  @override
  State<PropertyFilterWidget> createState() => _PropertyFilterWidgetState();
}

class _PropertyFilterWidgetState extends State<PropertyFilterWidget> {
  late String _selectedType;
  late double _minPrice;
  late double _maxPrice;
  late double _radiusKm;

  final List<String> _propertyTypes = [
    'Tous',
    'Villa',
    'Appartement',
    'Maison',
    'Loft',
    'Studio',
    'Duplex'
  ];

  @override
  void initState() {
    super.initState();
    _selectedType = widget.selectedType;
    _minPrice = widget.minPrice;
    _maxPrice = widget.maxPrice;
    _radiusKm = widget.radiusKm;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Text(
                  'Filtres',
                  style: AppTheme.lightTheme.textTheme.headlineSmall,
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedType = 'Tous';
                      _minPrice = 50000;
                      _maxPrice = 1000000;
                      _radiusKm = 10;
                    });
                  },
                  child: const Text('Réinitialiser'),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Property Type Section
                  Text(
                    'Type de propriété',
                    style: AppTheme.lightTheme.textTheme.titleMedium,
                  ),
                  SizedBox(height: 2.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: _propertyTypes.map((type) {
                      final isSelected = _selectedType == type;
                      return FilterChip(
                        label: Text(type),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedType = type;
                          });
                        },
                        backgroundColor:
                            AppTheme.lightTheme.colorScheme.surface,
                        selectedColor:
                            AppTheme.lightTheme.colorScheme.primaryContainer,
                        labelStyle:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: isSelected
                              ? AppTheme
                                  .lightTheme.colorScheme.onPrimaryContainer
                              : AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 4.h),

                  // Price Range Section
                  Text(
                    'Fourchette de prix',
                    style: AppTheme.lightTheme.textTheme.titleMedium,
                  ),
                  SizedBox(height: 2.h),

                  Row(
                    children: [
                      Text(
                        '€${(_minPrice / 1000).toStringAsFixed(0)}k',
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),
                      const Spacer(),
                      Text(
                        '€${(_maxPrice / 1000).toStringAsFixed(0)}k',
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),
                    ],
                  ),

                  RangeSlider(
                    values: RangeValues(_minPrice, _maxPrice),
                    min: 50000,
                    max: 2000000,
                    divisions: 39,
                    labels: RangeLabels(
                      '€${(_minPrice / 1000).toStringAsFixed(0)}k',
                      '€${(_maxPrice / 1000).toStringAsFixed(0)}k',
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _minPrice = values.start;
                        _maxPrice = values.end;
                      });
                    },
                  ),

                  SizedBox(height: 3.h),

                  // Radius Section
                  Text(
                    'Rayon de recherche',
                    style: AppTheme.lightTheme.textTheme.titleMedium,
                  ),
                  SizedBox(height: 2.h),

                  Row(
                    children: [
                      Text(
                        '1 km',
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),
                      const Spacer(),
                      Text(
                        '${_radiusKm.toStringAsFixed(0)} km',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '50 km',
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),
                    ],
                  ),

                  Slider(
                    value: _radiusKm,
                    min: 1,
                    max: 50,
                    divisions: 49,
                    label: '${_radiusKm.toStringAsFixed(0)} km',
                    onChanged: (double value) {
                      setState(() {
                        _radiusKm = value;
                      });
                    },
                  ),

                  SizedBox(height: 3.h),

                  // Additional Filters
                  Text(
                    'Filtres supplémentaires',
                    style: AppTheme.lightTheme.textTheme.titleMedium,
                  ),
                  SizedBox(height: 2.h),

                  _buildFilterOption('Avec piscine', false),
                  _buildFilterOption('Avec jardin', false),
                  _buildFilterOption('Avec garage', false),
                  _buildFilterOption('Avec balcon', false),
                  _buildFilterOption('Récemment rénové', false),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),

          // Apply Button
          Container(
            padding: EdgeInsets.all(4.w),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onApplyFilter(
                      _selectedType, _minPrice, _maxPrice, _radiusKm);
                  Navigator.pop(context);
                },
                child: const Text('Appliquer les filtres'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOption(String title, bool value) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
          Switch(
            value: value,
            onChanged: (bool newValue) {
              // Handle switch change
            },
          ),
        ],
      ),
    );
  }
}
