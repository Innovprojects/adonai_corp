import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PropertyMapWidget extends StatefulWidget {
  final List<Map<String, dynamic>> properties;
  final Function(Map<String, dynamic>) onPropertyTap;

  const PropertyMapWidget({
    Key? key,
    required this.properties,
    required this.onPropertyTap,
  }) : super(key: key);

  @override
  State<PropertyMapWidget> createState() => _PropertyMapWidgetState();
}

class _PropertyMapWidgetState extends State<PropertyMapWidget> {
  bool _isLocationEnabled = false;
  Map<String, dynamic>? _selectedProperty;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  void _requestLocationPermission() async {
    // Simulate location permission request
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isLocationEnabled = true;
    });
  }

  void _centerOnUserLocation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Centrage sur votre position...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Map Container (Simulated)
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.lightTheme.colorScheme.tertiaryContainer,
                AppTheme.lightTheme.colorScheme.secondaryContainer,
              ],
            ),
          ),
          child: Stack(
            children: [
              // Simulated Map Background
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'map',
                      size: 20.w,
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.5),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Carte Interactive',
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.7),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Pincer pour zoomer • Glisser pour naviguer',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),

              // Property Markers
              ...widget.properties.asMap().entries.map((entry) {
                final index = entry.key;
                final property = entry.value;
                final isSelected = _selectedProperty?['id'] == property['id'];

                // Simulate marker positions
                final left = (20 + (index * 15) % 60).toDouble();
                final top = (20 + (index * 20) % 50).toDouble();

                return Positioned(
                  left: left.w,
                  top: top.h,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedProperty = property;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      transform: Matrix4.identity()
                        ..scale(isSelected ? 1.2 : 1.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 1.h,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? Colors.white
                                : AppTheme.lightTheme.colorScheme.outline,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName: 'home',
                              size: 4.w,
                              color: isSelected
                                  ? Colors.white
                                  : AppTheme.lightTheme.colorScheme.primary,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              property['price'] as String,
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : AppTheme.lightTheme.colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),

        // Map Controls
        Positioned(
          top: 2.h,
          right: 4.w,
          child: Column(
            children: [
              // Location Button
              FloatingActionButton.small(
                heroTag: "location",
                onPressed: _isLocationEnabled ? _centerOnUserLocation : null,
                backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                child: CustomIconWidget(
                  iconName:
                      _isLocationEnabled ? 'my_location' : 'location_disabled',
                  color: _isLocationEnabled
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
              ),

              SizedBox(height: 2.h),

              // Zoom Controls
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Zoom avant')),
                        );
                      },
                      icon: CustomIconWidget(
                        iconName: 'add',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 5.w,
                      ),
                    ),
                    Container(
                      height: 1,
                      width: 8.w,
                      color: AppTheme.lightTheme.colorScheme.outline,
                    ),
                    IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Zoom arrière')),
                        );
                      },
                      icon: CustomIconWidget(
                        iconName: 'remove',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 5.w,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Property Preview Card
        if (_selectedProperty != null)
          Positioned(
            bottom: 2.h,
            left: 4.w,
            right: 4.w,
            child: GestureDetector(
              onTap: () => widget.onPropertyTap(_selectedProperty!),
              onVerticalDragUpdate: (details) {
                if (details.delta.dy < -5) {
                  widget.onPropertyTap(_selectedProperty!);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Swipe Indicator
                        Container(
                          width: 12.w,
                          height: 0.5.h,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.outline,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),

                        SizedBox(height: 2.h),

                        Row(
                          children: [
                            // Property Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CustomImageWidget(
                                imageUrl: (_selectedProperty!['images'] as List)
                                        .isNotEmpty
                                    ? (_selectedProperty!['images'] as List)[0]
                                        as String
                                    : '',
                                width: 20.w,
                                height: 15.h,
                                fit: BoxFit.cover,
                              ),
                            ),

                            SizedBox(width: 4.w),

                            // Property Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedProperty!['title'] as String,
                                    style: AppTheme
                                        .lightTheme.textTheme.titleMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 1.h),
                                  Text(
                                    _selectedProperty!['price'] as String,
                                    style: AppTheme
                                        .lightTheme.textTheme.titleMedium
                                        ?.copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Row(
                                    children: [
                                      CustomIconWidget(
                                        iconName: 'location_on',
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                        size: 3.w,
                                      ),
                                      SizedBox(width: 1.w),
                                      Expanded(
                                        child: Text(
                                          _selectedProperty!['location']
                                              as String,
                                          style: AppTheme
                                              .lightTheme.textTheme.bodySmall,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 1.h),
                                  Row(
                                    children: [
                                      CustomIconWidget(
                                        iconName: 'bed',
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                        size: 3.w,
                                      ),
                                      SizedBox(width: 1.w),
                                      Text(
                                        '${_selectedProperty!['bedrooms']}',
                                        style: AppTheme
                                            .lightTheme.textTheme.bodySmall,
                                      ),
                                      SizedBox(width: 3.w),
                                      CustomIconWidget(
                                        iconName: 'bathtub',
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                        size: 3.w,
                                      ),
                                      SizedBox(width: 1.w),
                                      Text(
                                        '${_selectedProperty!['bathrooms']}',
                                        style: AppTheme
                                            .lightTheme.textTheme.bodySmall,
                                      ),
                                      SizedBox(width: 3.w),
                                      CustomIconWidget(
                                        iconName: 'square_foot',
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                        size: 3.w,
                                      ),
                                      SizedBox(width: 1.w),
                                      Text(
                                        '${_selectedProperty!['area']}m²',
                                        style: AppTheme
                                            .lightTheme.textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 2.h),

                        Text(
                          'Glissez vers le haut pour plus de détails',
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

        // Close Button for Selected Property
        if (_selectedProperty != null)
          Positioned(
            bottom: 32.h,
            right: 4.w,
            child: FloatingActionButton.small(
              heroTag: "close",
              onPressed: () {
                setState(() {
                  _selectedProperty = null;
                });
              },
              backgroundColor: AppTheme.lightTheme.colorScheme.surface,
              child: CustomIconWidget(
                iconName: 'close',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 5.w,
              ),
            ),
          ),
      ],
    );
  }
}
