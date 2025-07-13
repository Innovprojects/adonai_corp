import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ResourceCardWidget extends StatelessWidget {
  final Map<String, dynamic> resource;
  final VoidCallback onDownload;
  final VoidCallback onView;

  const ResourceCardWidget({
    Key? key,
    required this.resource,
    required this.onDownload,
    required this.onView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String type = resource["type"] as String;
    final double progress = resource["progress"] as double;

    return GestureDetector(
      onTap: onView,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildThumbnail(type),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(type),
                  SizedBox(height: 1.h),
                  _buildTitle(),
                  SizedBox(height: 1.h),
                  _buildDescription(),
                  SizedBox(height: 2.h),
                  if (progress > 0) _buildProgressIndicator(progress),
                  if (progress > 0) SizedBox(height: 2.h),
                  _buildActions(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(String type) {
    return Stack(
      children: [
        Container(
          height: 20.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            color: AppTheme.lightTheme.colorScheme.surface,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: CustomImageWidget(
              imageUrl: resource["thumbnail"] as String,
              width: double.infinity,
              height: 20.h,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 2.h,
          right: 4.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: _getTypeColor(type).withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: _getTypeIcon(type),
                  color: Colors.white,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                  type,
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (resource["progress"] as double == 1.0)
          Positioned(
            top: 2.h,
            left: 4.w,
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'check',
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHeader(String type) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.secondary
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            resource["category"] as String,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Spacer(),
        Row(
          children: [
            CustomIconWidget(
              iconName: 'access_time',
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.6),
              size: 16,
            ),
            SizedBox(width: 1.w),
            Text(
              resource["duration"] as String,
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      resource["title"] as String,
      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDescription() {
    return Text(
      resource["description"] as String,
      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
        color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.7),
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildProgressIndicator(double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progression',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${(progress * 100).round()}%',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        LinearProgressIndicator(
          value: progress,
          backgroundColor:
              AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          valueColor: AlwaysStoppedAnimation<Color>(
            AppTheme.lightTheme.colorScheme.primary,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onView,
            icon: CustomIconWidget(
              iconName: 'play_arrow',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 18,
            ),
            label: Text('Voir'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onDownload,
            icon: CustomIconWidget(
              iconName: 'download',
              color: Colors.white,
              size: 18,
            ),
            label: Text('Télécharger'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
            ),
          ),
        ),
      ],
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Colors.red;
      case 'vidéo':
        return Colors.blue;
      case 'audio':
        return Colors.green;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  String _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return 'picture_as_pdf';
      case 'vidéo':
        return 'play_circle_filled';
      case 'audio':
        return 'headphones';
      default:
        return 'description';
    }
  }
}
