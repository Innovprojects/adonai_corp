import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';

class AiChatOverlay extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback onOpenFullChat;

  const AiChatOverlay({
    super.key,
    required this.onClose,
    required this.onOpenFullChat,
  });

  @override
  State<AiChatOverlay> createState() => _AiChatOverlayState();
}

class _AiChatOverlayState extends State<AiChatOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  final TextEditingController _messageController = TextEditingController();

  final List<Map<String, dynamic>> quickActions = [
    {
      "title": "Recommandations IA",
      "subtitle": "Obtenez des conseils personnalisés",
      "iconName": "lightbulb",
      "color": Color(0xFFFF8C00),
    },
    {
      "title": "Assistance technique",
      "subtitle": "Support pour vos projets",
      "iconName": "support_agent",
      "color": Color(0xFF1E90FF),
    },
    {
      "title": "Analyse de données",
      "subtitle": "Insights sur vos activités",
      "iconName": "analytics",
      "color": Color(0xFF28A745),
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _handleClose() async {
    await _animationController.reverse();
    widget.onClose();
  }

  void _handleQuickAction(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Action rapide: $title'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      final message = _messageController.text.trim();
      _messageController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Message envoyé: $message'),
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            color: Colors.black.withValues(alpha: 0.5),
            child: Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 6.w),
                  constraints: BoxConstraints(
                    maxHeight: 70.h,
                    maxWidth: 90.w,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 20.0,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppTheme.secondaryLight,
                              AppTheme.tertiaryLight,
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: CustomIconWidget(
                                iconName: 'smart_toy',
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
                                    'Assistant IA ADONAI',
                                    style: GoogleFonts.inter(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Comment puis-je vous aider?',
                                    style: GoogleFonts.inter(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color:
                                          Colors.white.withValues(alpha: 0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: widget.onOpenFullChat,
                                  icon: CustomIconWidget(
                                    iconName: 'open_in_full',
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  tooltip: 'Ouvrir en plein écran',
                                ),
                                IconButton(
                                  onPressed: _handleClose,
                                  icon: CustomIconWidget(
                                    iconName: 'close',
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  tooltip: 'Fermer',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Content
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.all(4.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Actions rapides',
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      AppTheme.lightTheme.colorScheme.onSurface,
                                ),
                              ),
                              SizedBox(height: 2.h),

                              // Quick Actions
                              ...quickActions
                                  .map((action) => Container(
                                        margin: EdgeInsets.only(bottom: 1.h),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () => _handleQuickAction(
                                                action["title"] as String),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            child: Container(
                                              padding: EdgeInsets.all(3.w),
                                              decoration: BoxDecoration(
                                                color: (action["color"]
                                                        as Color)
                                                    .withValues(alpha: 0.05),
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                                border: Border.all(
                                                  color: (action["color"]
                                                          as Color)
                                                      .withValues(alpha: 0.2),
                                                  width: 1.0,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    padding:
                                                        EdgeInsets.all(2.w),
                                                    decoration: BoxDecoration(
                                                      color: (action["color"]
                                                              as Color)
                                                          .withValues(
                                                              alpha: 0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    child: CustomIconWidget(
                                                      iconName:
                                                          action["iconName"]
                                                              as String,
                                                      color: action["color"]
                                                          as Color,
                                                      size: 20,
                                                    ),
                                                  ),
                                                  SizedBox(width: 3.w),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          action["title"]
                                                              as String,
                                                          style:
                                                              GoogleFonts.inter(
                                                            fontSize: 13.sp,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: AppTheme
                                                                .lightTheme
                                                                .colorScheme
                                                                .onSurface,
                                                          ),
                                                        ),
                                                        Text(
                                                          action["subtitle"]
                                                              as String,
                                                          style:
                                                              GoogleFonts.inter(
                                                            fontSize: 11.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: AppTheme
                                                                .lightTheme
                                                                .colorScheme
                                                                .onSurfaceVariant,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  CustomIconWidget(
                                                    iconName:
                                                        'arrow_forward_ios',
                                                    color: action["color"]
                                                        as Color,
                                                    size: 14,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ],
                          ),
                        ),
                      ),

                      // Message Input
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _messageController,
                                decoration: InputDecoration(
                                  hintText: 'Tapez votre message...',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: AppTheme
                                      .lightTheme.scaffoldBackgroundColor,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 4.w,
                                    vertical: 1.h,
                                  ),
                                  hintStyle: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  color:
                                      AppTheme.lightTheme.colorScheme.onSurface,
                                ),
                                maxLines: 1,
                                textInputAction: TextInputAction.send,
                                onSubmitted: (value) => _sendMessage(),
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.secondaryLight,
                                    AppTheme.tertiaryLight,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              child: IconButton(
                                onPressed: _sendMessage,
                                icon: CustomIconWidget(
                                  iconName: 'send',
                                  color: Colors.white,
                                  size: 20,
                                ),
                                tooltip: 'Envoyer',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
