import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PropertyCardWidget extends StatelessWidget {
  final Map<String, dynamic> property;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const PropertyCardWidget({
    Key? key,
    required this.property,
    required this.onTap,
    required this.onFavoriteToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final images = property['images'] as List<dynamic>;
    final features = property['features'] as List<dynamic>;
    final isFavorite = property['isFavorite'] as bool;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: CustomImageWidget(
                      imageUrl: images.isNotEmpty ? images[0] as String : '',
                      width: double.infinity,
                      height: 25.h,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Price Badge
                  Positioned(
                    top: 2.h,
                    left: 3.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        property['price'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Favorite Button
                  Positioned(
                    top: 2.h,
                    right: 3.w,
                    child: GestureDetector(
                      onTap: onFavoriteToggle,
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: isFavorite ? 'favorite' : 'favorite_border',
                          color: isFavorite
                              ? AppTheme.lightTheme.colorScheme.error
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          size: 5.w,
                        ),
                      ),
                    ),
                  ),

                  // Image Count Indicator
                  if (images.length > 1)
                    Positioned(
                      bottom: 1.h,
                      right: 3.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 0.5.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName: 'photo_library',
                              color: Colors.white,
                              size: 3.w,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              '${images.length}',
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),

              // Content Section
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Type
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            property['title'] as String,
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.w,
                            vertical: 0.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme
                                .lightTheme.colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            property['type'] as String,
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSecondaryContainer,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 1.h),

                    // Location
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'location_on',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 4.w,
                        ),
                        SizedBox(width: 1.w),
                        Expanded(
                          child: Text(
                            property['location'] as String,
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 1.5.h),

                    // Property Details
                    Row(
                      children: [
                        _buildDetailItem(
                          'bed',
                          '${property['bedrooms']} ch.',
                        ),
                        SizedBox(width: 4.w),
                        _buildDetailItem(
                          'bathtub',
                          '${property['bathrooms']} sdb',
                        ),
                        SizedBox(width: 4.w),
                        _buildDetailItem(
                          'square_foot',
                          '${property['area']} m²',
                        ),
                      ],
                    ),

                    SizedBox(height: 2.h),

                    // Features
                    if (features.isNotEmpty)
                      Wrap(
                        spacing: 2.w,
                        runSpacing: 1.h,
                        children: features.take(3).map((feature) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.w,
                              vertical: 0.5.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme
                                  .lightTheme.colorScheme.tertiaryContainer,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              feature as String,
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onTertiaryContainer,
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                    SizedBox(height: 2.h),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              final contact =
                                  property['contact'] as Map<String, dynamic>;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Appel vers ${contact['name']}'),
                                ),
                              );
                            },
                            icon: CustomIconWidget(
                              iconName: 'phone',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 4.w,
                            ),
                            label: const Text('Appeler'),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Rendez-vous programmé'),
                                ),
                              );
                            },
                            icon: CustomIconWidget(
                              iconName: 'calendar_today',
                              color: Colors.white,
                              size: 4.w,
                            ),
                            label: const Text('RDV'),
                          ),
                        ),
                      ],
                    ),

                    // Last Updated
                    SizedBox(height: 1.h),
                    Text(
                      'Mis à jour le ${property['lastUpdated']}',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String iconName, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 4.w,
        ),
        SizedBox(width: 1.w),
        Text(
          text,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
