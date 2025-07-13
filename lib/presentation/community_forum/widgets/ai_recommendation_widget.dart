import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AIRecommendationWidget extends StatelessWidget {
  final Map<String, dynamic> recommendation;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const AIRecommendationWidget({
    Key? key,
    required this.recommendation,
    required this.onTap,
    required this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int relevanceScore = recommendation["relevanceScore"] as int;

    return Dismissible(
      key: Key('recommendation_${recommendation["id"]}'),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 4.w),
        color: AppTheme.lightTheme.colorScheme.error,
        child: CustomIconWidget(
          iconName: 'delete',
          color: Colors.white,
          size: 24,
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.05),
                  AppTheme.lightTheme.colorScheme.secondary
                      .withValues(alpha: 0.05),
                ],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(relevanceScore),
                  SizedBox(height: 2.h),
                  _buildContent(),
                  SizedBox(height: 2.h),
                  _buildReasonBadge(),
                  SizedBox(height: 2.h),
                  _buildActionButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(int relevanceScore) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: CustomIconWidget(
            iconName: 'auto_awesome',
            color: AppTheme.lightTheme.colorScheme.tertiary,
            size: 24,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'IA Recommandation',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  _buildRelevanceScore(relevanceScore),
                ],
              ),
              SizedBox(height: 0.5.h),
              Text(
                recommendation["category"] as String,
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onDismiss,
          icon: CustomIconWidget(
            iconName: 'close',
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.6),
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildRelevanceScore(int score) {
    Color scoreColor;
    if (score >= 90) {
      scoreColor = AppTheme.lightTheme.colorScheme.primary;
    } else if (score >= 75) {
      scoreColor = AppTheme.lightTheme.colorScheme.secondary;
    } else {
      scoreColor =
          AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: scoreColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$score%',
        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          color: scoreColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Row(
      children: [
        Container(
          width: 20.w,
          height: 15.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppTheme.lightTheme.colorScheme.surface,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CustomImageWidget(
              imageUrl: recommendation["thumbnail"] as String,
              width: 20.w,
              height: 15.h,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.secondary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  recommendation["type"] as String,
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                recommendation["title"] as String,
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 1.h),
              Text(
                recommendation["description"] as String,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.7),
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReasonBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: 'lightbulb',
            color: AppTheme.lightTheme.colorScheme.tertiary,
            size: 16,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              recommendation["reason"] as String,
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.tertiary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: CustomIconWidget(
          iconName: 'arrow_forward',
          color: Colors.white,
          size: 18,
        ),
        label: Text('Découvrir'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 1.5.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
