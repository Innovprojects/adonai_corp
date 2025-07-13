import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DiscussionPostWidget extends StatelessWidget {
  final Map<String, dynamic> discussion;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback onTap;

  const DiscussionPostWidget({
    Key? key,
    required this.discussion,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime timestamp = discussion["timestamp"] as DateTime;
    final String timeAgo = _getTimeAgo(timestamp);
    final List<String> tags = (discussion["tags"] as List).cast<String>();

    return GestureDetector(
      onTap: onTap,
      onLongPress: onShare,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(timeAgo),
              SizedBox(height: 2.h),
              _buildContent(),
              SizedBox(height: 2.h),
              _buildTags(tags),
              SizedBox(height: 2.h),
              _buildActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String timeAgo) {
    return Row(
      children: [
        CircleAvatar(
          radius: 6.w,
          backgroundColor:
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          child: ClipOval(
            child: CustomImageWidget(
              imageUrl: discussion["avatar"] as String,
              width: 12.w,
              height: 12.w,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                discussion["author"] as String,
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                timeAgo,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
        PopupMenuButton<String>(
          icon: CustomIconWidget(
            iconName: 'more_vert',
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.6),
            size: 20,
          ),
          onSelected: (value) {
            switch (value) {
              case 'share':
                onShare();
                break;
              case 'report':
                // Handle report
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'share',
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'share',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 18,
                  ),
                  SizedBox(width: 2.w),
                  Text('Partager'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'report',
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'flag',
                    color: AppTheme.lightTheme.colorScheme.error,
                    size: 18,
                  ),
                  SizedBox(width: 2.w),
                  Text('Signaler'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          discussion["title"] as String,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 1.h),
        Text(
          discussion["content"] as String,
          style: AppTheme.lightTheme.textTheme.bodyMedium,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildTags(List<String> tags) {
    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: tags
          .map((tag) => Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  tag,
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        _buildActionButton(
          icon: discussion["isLiked"] as bool ? 'favorite' : 'favorite_border',
          label: '${discussion["likes"]}',
          color: discussion["isLiked"] as bool
              ? AppTheme.lightTheme.colorScheme.error
              : AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.6),
          onTap: onLike,
        ),
        SizedBox(width: 6.w),
        _buildActionButton(
          icon: 'chat_bubble_outline',
          label: '${discussion["comments"]}',
          color:
              AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
          onTap: onComment,
        ),
        Spacer(),
        _buildActionButton(
          icon: 'share',
          label: 'Partager',
          color:
              AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
          onTap: onShare,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: icon,
            color: color,
            size: 18,
          ),
          SizedBox(width: 1.w),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return 'il y a ${difference.inMinutes}min';
    } else if (difference.inHours < 24) {
      return 'il y a ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'il y a ${difference.inDays}j';
    } else {
      return 'il y a ${(difference.inDays / 7).floor()}sem';
    }
  }
}
