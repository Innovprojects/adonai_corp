import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChatMessageWidget extends StatelessWidget {
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final String? searchQuery;

  const ChatMessageWidget({
    Key? key,
    required this.message,
    required this.isUser,
    required this.timestamp,
    this.searchQuery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) _buildAvatar(),
          if (!isUser) SizedBox(width: 3.w),
          Flexible(
            child: Container(
              constraints: BoxConstraints(maxWidth: 75.w),
              child: Column(
                crossAxisAlignment:
                    isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  _buildMessageBubble(context),
                  SizedBox(height: 0.5.h),
                  _buildTimestamp(),
                ],
              ),
            ),
          ),
          if (isUser) SizedBox(width: 3.w),
          if (isUser) _buildAvatar(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 8.w,
      height: 8.w,
      decoration: BoxDecoration(
        color: isUser
            ? AppTheme.lightTheme.primaryColor
            : AppTheme.lightTheme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(4.w),
      ),
      child: CustomIconWidget(
        iconName: isUser ? 'person' : 'smart_toy',
        color: Colors.white,
        size: 16,
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: isUser
            ? AppTheme.lightTheme.primaryColor
            : AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4.w),
          topRight: Radius.circular(4.w),
          bottomLeft: Radius.circular(isUser ? 4.w : 1.w),
          bottomRight: Radius.circular(isUser ? 1.w : 4.w),
        ),
        border: !isUser
            ? Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
                width: 1,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: _buildMessageContent(),
    );
  }

  Widget _buildMessageContent() {
    if (searchQuery != null && searchQuery!.isNotEmpty) {
      return _buildHighlightedText();
    }

    return Text(
      message,
      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
        color:
            isUser ? Colors.white : AppTheme.lightTheme.colorScheme.onSurface,
        height: 1.4,
      ),
    );
  }

  Widget _buildHighlightedText() {
    final List<TextSpan> spans = [];
    final String lowerMessage = message.toLowerCase();
    final String lowerQuery = searchQuery!.toLowerCase();

    int start = 0;
    int index = lowerMessage.indexOf(lowerQuery);

    while (index != -1) {
      // Add text before highlight
      if (index > start) {
        spans.add(TextSpan(
          text: message.substring(start, index),
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: isUser
                ? Colors.white
                : AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ));
      }

      // Add highlighted text
      spans.add(TextSpan(
        text: message.substring(index, index + searchQuery!.length),
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          color:
              isUser ? Colors.white : AppTheme.lightTheme.colorScheme.onSurface,
          backgroundColor:
              AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.3),
          fontWeight: FontWeight.w600,
        ),
      ));

      start = index + searchQuery!.length;
      index = lowerMessage.indexOf(lowerQuery, start);
    }

    // Add remaining text
    if (start < message.length) {
      spans.add(TextSpan(
        text: message.substring(start),
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          color:
              isUser ? Colors.white : AppTheme.lightTheme.colorScheme.onSurface,
        ),
      ));
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }

  Widget _buildTimestamp() {
    final String timeString = _formatTime(timestamp);

    return Text(
      timeString,
      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
            .withValues(alpha: 0.6),
        fontSize: 9.sp,
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'À l\'instant';
    } else if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays}j';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
