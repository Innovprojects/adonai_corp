import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_export.dart';
import './widgets/ai_chat_overlay.dart';
import './widgets/notification_banner.dart';
import './widgets/recent_activity_card.dart';
import './widgets/sector_navigation_card.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard>
    with TickerProviderStateMixin {
  bool _isRefreshing = false;
  bool _showNotificationBanner = true;
  bool _showAiChat = false;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  final List<Map<String, dynamic>> sectorData = [
    {
      "id": 1,
      "title": "Construction",
      "subtitle": "Services de construction",
      "description":
          "Accédez aux services de construction, demandes de devis et galerie de projets récents",
      "iconName": "construction",
      "color": Color(0xFF8B0000),
      "route": "/construction-services",
      "isActive": true,
    },
    {
      "id": 2,
      "title": "Immobilier",
      "subtitle": "Consultation immobilière",
      "description":
          "Explorez les propriétés, consultations et cartes interactives avec géolocalisation",
      "iconName": "home",
      "color": Color(0xFF1E90FF),
      "route": "/real-estate-properties",
      "isActive": true,
    },
    {
      "id": 3,
      "title": "Agribusiness",
      "subtitle": "Suivi agricole",
      "description":
          "Tableau de bord de production, fiches techniques et recommandations IA",
      "iconName": "agriculture",
      "color": Color(0xFF28A745),
      "route": "/agribusiness-dashboard",
      "isActive": true,
    },
    {
      "id": 4,
      "title": "Communauté",
      "subtitle": "Leadership & Forums",
      "description":
          "Forums de discussion, ressources éducatives et recommandations de contenu IA",
      "iconName": "group",
      "color": Color(0xFFFF8C00),
      "route": "/community-forum",
      "isActive": true,
    },
    {
      "id": 5,
      "title": "Partenaires",
      "subtitle": "Répertoire des partenaires",
      "description":
          "Annuaire filtrable par secteur avec profils détaillés et prise de rendez-vous",
      "iconName": "business",
      "color": Color(0xFF6F42C1),
      "route": "/partners-directory",
      "isActive": true,
    },
  ];

  final List<Map<String, dynamic>> recentActivities = [
    {
      "id": 1,
      "title": "Nouveau projet de construction",
      "description": "Villa moderne à Abidjan - Devis approuvé",
      "timestamp": DateTime.now().subtract(Duration(hours: 2)),
      "sector": "Construction",
      "iconName": "construction",
      "color": Color(0xFF8B0000),
      "isUnread": true,
    },
    {
      "id": 2,
      "title": "Propriété ajoutée",
      "description": "Appartement 3 pièces à Cocody disponible",
      "timestamp": DateTime.now().subtract(Duration(hours: 5)),
      "sector": "Immobilier",
      "iconName": "home",
      "color": Color(0xFF1E90FF),
      "isUnread": true,
    },
    {
      "id": 3,
      "title": "Recommandation IA",
      "description": "Période optimale pour la plantation de cacao",
      "timestamp": DateTime.now().subtract(Duration(hours: 8)),
      "sector": "Agribusiness",
      "iconName": "agriculture",
      "color": Color(0xFF28A745),
      "isUnread": false,
    },
    {
      "id": 4,
      "title": "Nouveau message forum",
      "description": "Discussion sur les stratégies de leadership",
      "timestamp": DateTime.now().subtract(Duration(days: 1)),
      "sector": "Communauté",
      "iconName": "group",
      "color": Color(0xFFFF8C00),
      "isUnread": false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    ));
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate network call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
      // Update timestamp for activities
      for (var activity in recentActivities) {
        if ((activity["timestamp"] as DateTime)
            .isAfter(DateTime.now().subtract(Duration(hours: 6)))) {
          activity["isUnread"] = true;
        }
      }
    });
  }

  void _dismissNotificationBanner() {
    setState(() {
      _showNotificationBanner = false;
    });
  }

  void _toggleAiChat() {
    setState(() {
      _showAiChat = !_showAiChat;
    });
  }

  void _navigateToSector(String route) {
    if (route == "/real-estate-properties" ||
        route == "/agribusiness-dashboard" ||
        route == "/community-forum") {
      Navigator.pushNamed(context, route);
    } else {
      // For other routes, show coming soon message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cette section sera bientôt disponible'),
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        ),
      );
    }
  }

  void _navigateToProfile() {
    Navigator.pushNamed(context, '/authentication-screen');
  }

  void _openAiAssistant() {
    Navigator.pushNamed(context, '/ai-chat-assistant');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryLight,
        foregroundColor: Colors.white,
        elevation: 2.0,
        title: Text(
          'ADONAI CORP',
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: _navigateToProfile,
            icon: CustomIconWidget(
              iconName: 'person',
              color: Colors.white,
              size: 24,
            ),
            tooltip: 'Profil utilisateur',
          ),
          IconButton(
            onPressed: () {
              // Settings functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Paramètres bientôt disponibles'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                ),
              );
            },
            icon: CustomIconWidget(
              iconName: 'settings',
              color: Colors.white,
              size: 24,
            ),
            tooltip: 'Paramètres',
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _handleRefresh,
            color: AppTheme.lightTheme.colorScheme.primary,
            child: CustomScrollView(
              slivers: [
                // Notification Banner
                if (_showNotificationBanner)
                  SliverToBoxAdapter(
                    child: NotificationBanner(
                      message:
                          "Nouvelles mises à jour disponibles dans vos secteurs actifs",
                      onDismiss: _dismissNotificationBanner,
                    ),
                  ),

                // Welcome Section
                SliverToBoxAdapter(
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tableau de bord',
                          style: GoogleFonts.inter(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Accédez rapidement à tous vos services ADONAI CORP',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Sector Navigation Cards
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Secteurs d\'activité',
                          style: GoogleFonts.inter(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        ...sectorData
                            .map((sector) => SectorNavigationCard(
                                  title: sector["title"] as String,
                                  subtitle: sector["subtitle"] as String,
                                  description: sector["description"] as String,
                                  iconName: sector["iconName"] as String,
                                  color: sector["color"] as Color,
                                  isActive: sector["isActive"] as bool,
                                  onTap: () => _navigateToSector(
                                      sector["route"] as String),
                                ))
                            .toList(),
                      ],
                    ),
                  ),
                ),

                // Recent Activities Section
                SliverToBoxAdapter(
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Activités récentes',
                              style: GoogleFonts.inter(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Navigate to full activity log
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Journal complet bientôt disponible'),
                                    backgroundColor:
                                        AppTheme.lightTheme.colorScheme.primary,
                                  ),
                                );
                              },
                              child: Text(
                                'Voir tout',
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        ...recentActivities
                            .take(3)
                            .map((activity) => RecentActivityCard(
                                  title: activity["title"] as String,
                                  description:
                                      activity["description"] as String,
                                  timestamp: activity["timestamp"] as DateTime,
                                  sector: activity["sector"] as String,
                                  iconName: activity["iconName"] as String,
                                  color: activity["color"] as Color,
                                  isUnread: activity["isUnread"] as bool,
                                  onTap: () {
                                    // Handle activity tap
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Détails de l\'activité: ${activity["title"]}'),
                                        backgroundColor: AppTheme
                                            .lightTheme.colorScheme.primary,
                                      ),
                                    );
                                  },
                                ))
                            .toList(),
                      ],
                    ),
                  ),
                ),

                // Bottom spacing
                SliverToBoxAdapter(
                  child: SizedBox(height: 10.h),
                ),
              ],
            ),
          ),

          // AI Chat Overlay
          if (_showAiChat)
            AiChatOverlay(
              onClose: _toggleAiChat,
              onOpenFullChat: _openAiAssistant,
            ),

          // Loading indicator
          if (_isRefreshing)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 4,
                child: LinearProgressIndicator(
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _fabAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _fabAnimation.value,
            child: FloatingActionButton(
              onPressed: _toggleAiChat,
              backgroundColor: AppTheme.secondaryLight,
              foregroundColor: Colors.white,
              elevation: 6.0,
              child: CustomIconWidget(
                iconName: _showAiChat ? 'close' : 'smart_toy',
                color: Colors.white,
                size: 28,
              ),
              tooltip: _showAiChat ? 'Fermer l\'assistant IA' : 'Assistant IA',
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
