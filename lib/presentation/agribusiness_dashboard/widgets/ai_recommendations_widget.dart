import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AIRecommendationsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> recommendations;

  const AIRecommendationsWidget({
    Key? key,
    required this.recommendations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1),
                AppTheme.lightTheme.colorScheme.secondary
                    .withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.tertiary
                  .withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomIconWidget(
                  iconName: 'psychology',
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Assistant IA Agricole",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      "Analyse en temps réel de vos données agricoles",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/ai-chat-assistant');
                },
                child: const Text("Chat IA"),
              ),
            ],
          ),
        ),
        SizedBox(height: 3.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recommendations.length,
          itemBuilder: (context, index) {
            final recommendation = recommendations[index];
            return _buildRecommendationCard(context, recommendation);
          },
        ),
      ],
    );
  }

  Widget _buildRecommendationCard(
    BuildContext context,
    Map<String, dynamic> recommendation,
  ) {
    final priority = recommendation["priority"] as String? ?? "Moyenne";
    final confidence = (recommendation["confidence"] as double? ?? 0.0);

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getPriorityColor(priority).withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: _getPriorityColor(priority),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  priority,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              SizedBox(width: 2.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  recommendation["category"] ?? "Général",
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'verified',
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    "${(confidence * 100).toInt()}%",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            recommendation["title"] ?? "Recommandation",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            recommendation["description"] ?? "Aucune description disponible",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 2.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'trending_up',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    recommendation["savings"] ?? "Bénéfice non spécifié",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Recommandation reportée'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: CustomIconWidget(
                    iconName: 'schedule',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 16,
                  ),
                  label: const Text("Reporter"),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Recommandation appliquée'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: CustomIconWidget(
                    iconName: 'check',
                    color: Colors.white,
                    size: 16,
                  ),
                  label: const Text("Appliquer"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'haute':
        return const Color(0xFFE53E3E);
      case 'moyenne':
        return const Color(0xFFFF8C00);
      case 'basse':
        return const Color(0xFF38A169);
      default:
        return AppTheme.lightTheme.colorScheme.outline;
    }
  }
}
