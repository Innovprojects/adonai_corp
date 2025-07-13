import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PropertyDetailWidget extends StatefulWidget {
  final Map<String, dynamic> property;
  final VoidCallback onFavoriteToggle;

  const PropertyDetailWidget({
    Key? key,
    required this.property,
    required this.onFavoriteToggle,
  }) : super(key: key);

  @override
  State<PropertyDetailWidget> createState() => _PropertyDetailWidgetState();
}

class _PropertyDetailWidgetState extends State<PropertyDetailWidget> {
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.property['images'] as List<dynamic>;
    final features = widget.property['features'] as List<dynamic>;
    final contact = widget.property['contact'] as Map<String, dynamic>;
    final isFavorite = widget.property['isFavorite'] as bool;

    return Container(
      height: 95.h,
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

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Gallery
                  SizedBox(
                    height: 35.h,
                    child: Stack(
                      children: [
                        PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentImageIndex = index;
                            });
                          },
                          itemCount: images.length,
                          itemBuilder: (context, index) {
                            return CustomImageWidget(
                              imageUrl: images[index] as String,
                              width: double.infinity,
                              height: 35.h,
                              fit: BoxFit.cover,
                            );
                          },
                        ),

                        // Image Indicators
                        if (images.length > 1)
                          Positioned(
                            bottom: 2.h,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: images.asMap().entries.map((entry) {
                                return Container(
                                  width: 2.w,
                                  height: 2.w,
                                  margin: EdgeInsets.symmetric(horizontal: 1.w),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentImageIndex == entry.key
                                        ? Colors.white
                                        : Colors.white.withValues(alpha: 0.5),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),

                        // Favorite Button
                        Positioned(
                          top: 2.h,
                          right: 4.w,
                          child: GestureDetector(
                            onTap: widget.onFavoriteToggle,
                            child: Container(
                              padding: EdgeInsets.all(3.w),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.9),
                                shape: BoxShape.circle,
                              ),
                              child: CustomIconWidget(
                                iconName:
                                    isFavorite ? 'favorite' : 'favorite_border',
                                color: isFavorite
                                    ? AppTheme.lightTheme.colorScheme.error
                                    : AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                size: 6.w,
                              ),
                            ),
                          ),
                        ),

                        // Share Button
                        Positioned(
                          top: 2.h,
                          left: 4.w,
                          child: GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Propriété partagée!'),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(3.w),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.9),
                                shape: BoxShape.circle,
                              ),
                              child: CustomIconWidget(
                                iconName: 'share',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 6.w,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Property Details
                  Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and Price
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.property['title'] as String,
                                    style: AppTheme
                                        .lightTheme.textTheme.headlineSmall
                                        ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 1.h),
                                  Text(
                                    widget.property['price'] as String,
                                    style: AppTheme
                                        .lightTheme.textTheme.headlineMedium
                                        ?.copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 3.w,
                                vertical: 1.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme
                                    .lightTheme.colorScheme.secondaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                widget.property['type'] as String,
                                style: AppTheme.lightTheme.textTheme.labelLarge
                                    ?.copyWith(
                                  color: AppTheme.lightTheme.colorScheme
                                      .onSecondaryContainer,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 2.h),

                        // Location
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'location_on',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 5.w,
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Text(
                                widget.property['location'] as String,
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 3.h),

                        // Property Specs
                        Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildSpecItem(
                                'bed',
                                '${widget.property['bedrooms']}',
                                'Chambres',
                              ),
                              _buildSpecItem(
                                'bathtub',
                                '${widget.property['bathrooms']}',
                                'Salles de bain',
                              ),
                              _buildSpecItem(
                                'square_foot',
                                '${widget.property['area']}',
                                'm²',
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 3.h),

                        // Description
                        Text(
                          'Description',
                          style: AppTheme.lightTheme.textTheme.titleLarge,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          widget.property['description'] as String,
                          style: AppTheme.lightTheme.textTheme.bodyLarge,
                        ),

                        SizedBox(height: 3.h),

                        // Features
                        if (features.isNotEmpty) ...[
                          Text(
                            'Caractéristiques',
                            style: AppTheme.lightTheme.textTheme.titleLarge,
                          ),
                          SizedBox(height: 2.h),
                          Wrap(
                            spacing: 2.w,
                            runSpacing: 1.h,
                            children: features.map((feature) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 3.w,
                                  vertical: 1.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme
                                      .lightTheme.colorScheme.tertiaryContainer,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  feature as String,
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onTertiaryContainer,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 3.h),
                        ],

                        // Contact Information
                        Text(
                          'Contact',
                          style: AppTheme.lightTheme.textTheme.titleLarge,
                        ),
                        SizedBox(height: 2.h),
                        Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 8.w,
                                    backgroundColor:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    child: Text(
                                      (contact['name'] as String)
                                          .substring(0, 1)
                                          .toUpperCase(),
                                      style: AppTheme
                                          .lightTheme.textTheme.titleLarge
                                          ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          contact['name'] as String,
                                          style: AppTheme
                                              .lightTheme.textTheme.titleMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 0.5.h),
                                        Text(
                                          'Agent immobilier',
                                          style: AppTheme
                                              .lightTheme.textTheme.bodyMedium
                                              ?.copyWith(
                                            color: AppTheme.lightTheme
                                                .colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 3.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Appel vers ${contact['name']}'),
                                          ),
                                        );
                                      },
                                      icon: CustomIconWidget(
                                        iconName: 'phone',
                                        color: AppTheme
                                            .lightTheme.colorScheme.primary,
                                        size: 5.w,
                                      ),
                                      label: const Text('Appeler'),
                                    ),
                                  ),
                                  SizedBox(width: 3.w),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Message à ${contact['name']}'),
                                          ),
                                        );
                                      },
                                      icon: CustomIconWidget(
                                        iconName: 'message',
                                        color: AppTheme
                                            .lightTheme.colorScheme.primary,
                                        size: 5.w,
                                      ),
                                      label: const Text('Message'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 4.h),

                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Visite virtuelle lancée'),
                                    ),
                                  );
                                },
                                icon: CustomIconWidget(
                                  iconName: 'view_in_ar',
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  size: 5.w,
                                ),
                                label: const Text('Visite 360°'),
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Rendez-vous programmé!'),
                                    ),
                                  );
                                },
                                icon: CustomIconWidget(
                                  iconName: 'calendar_today',
                                  color: Colors.white,
                                  size: 5.w,
                                ),
                                label: const Text('Prendre RDV'),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 2.h),
                      ],
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

  Widget _buildSpecItem(String iconName, String value, String label) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 8.w,
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
