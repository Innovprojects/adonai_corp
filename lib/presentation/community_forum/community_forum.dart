import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/ai_recommendation_widget.dart';
import './widgets/discussion_post_widget.dart';
import './widgets/post_composer_widget.dart';
import './widgets/resource_card_widget.dart';

class CommunityForum extends StatefulWidget {
  const CommunityForum({Key? key}) : super(key: key);

  @override
  State<CommunityForum> createState() => _CommunityForumState();
}

class _CommunityForumState extends State<CommunityForum>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _discussionScrollController = ScrollController();
  final ScrollController _resourceScrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = false;
  bool _isSearching = false;
  String _selectedFilter = 'Tous';

  // Mock data for discussions
  final List<Map<String, dynamic>> _discussions = [
    {
      "id": 1,
      "author": "Marie Dubois",
      "avatar":
          "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=400",
      "title": "Stratégies de leadership en période d'incertitude",
      "content":
          "Comment maintenir la motivation de votre équipe lors de changements organisationnels majeurs ? Partagez vos expériences et meilleures pratiques.",
      "timestamp": DateTime.now().subtract(Duration(hours: 2)),
      "likes": 24,
      "comments": 8,
      "tags": ["Leadership", "Management", "Équipe"],
      "isLiked": false,
    },
    {
      "id": 2,
      "author": "Pierre Martin",
      "avatar":
          "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=400",
      "title": "Innovation dans le secteur de la construction",
      "content":
          "Les nouvelles technologies transforment notre industrie. Quels outils utilisez-vous pour optimiser vos projets de construction ?",
      "timestamp": DateTime.now().subtract(Duration(hours: 5)),
      "likes": 18,
      "comments": 12,
      "tags": ["Construction", "Innovation", "Technologie"],
      "isLiked": true,
    },
    {
      "id": 3,
      "author": "Sophie Laurent",
      "avatar":
          "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
      "title": "Développement durable en agriculture",
      "content":
          "Partage d'expériences sur l'implémentation de pratiques agricoles durables. Comment concilier productivité et respect de l'environnement ?",
      "timestamp": DateTime.now().subtract(Duration(hours: 8)),
      "likes": 31,
      "comments": 15,
      "tags": ["Agriculture", "Durabilité", "Environnement"],
      "isLiked": false,
    },
    {
      "id": 4,
      "author": "Jean-Claude Moreau",
      "avatar":
          "https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg?auto=compress&cs=tinysrgb&w=400",
      "title": "Tendances du marché immobilier 2024",
      "content":
          "Analyse des évolutions du marché immobilier français. Quelles opportunités pour les investisseurs cette année ?",
      "timestamp": DateTime.now().subtract(Duration(days: 1)),
      "likes": 42,
      "comments": 23,
      "tags": ["Immobilier", "Investissement", "Marché"],
      "isLiked": true,
    },
  ];

  // Mock data for resources
  final List<Map<String, dynamic>> _resources = [
    {
      "id": 1,
      "title": "Guide du Leadership Transformationnel",
      "type": "PDF",
      "duration": "45 pages",
      "thumbnail":
          "https://images.pexels.com/photos/3184291/pexels-photo-3184291.jpeg?auto=compress&cs=tinysrgb&w=400",
      "description":
          "Manuel complet sur les techniques de leadership moderne pour dirigeants d'entreprise.",
      "category": "Leadership",
      "downloadUrl": "https://example.com/leadership-guide.pdf",
      "progress": 0.0,
    },
    {
      "id": 2,
      "title": "Webinaire: Innovation en Construction",
      "type": "Vidéo",
      "duration": "1h 30min",
      "thumbnail":
          "https://images.pexels.com/photos/3184338/pexels-photo-3184338.jpeg?auto=compress&cs=tinysrgb&w=400",
      "description":
          "Conférence sur les dernières innovations technologiques dans le secteur du bâtiment.",
      "category": "Construction",
      "downloadUrl": "https://example.com/construction-webinar.mp4",
      "progress": 0.65,
    },
    {
      "id": 3,
      "title": "Podcast: Agriculture du Futur",
      "type": "Audio",
      "duration": "42min",
      "thumbnail":
          "https://images.pexels.com/photos/1595104/pexels-photo-1595104.jpeg?auto=compress&cs=tinysrgb&w=400",
      "description":
          "Discussion avec des experts sur l'avenir de l'agriculture durable et les nouvelles pratiques.",
      "category": "Agriculture",
      "downloadUrl": "https://example.com/agriculture-podcast.mp3",
      "progress": 0.3,
    },
    {
      "id": 4,
      "title": "Rapport: Marché Immobilier 2024",
      "type": "PDF",
      "duration": "28 pages",
      "thumbnail":
          "https://images.pexels.com/photos/3184465/pexels-photo-3184465.jpeg?auto=compress&cs=tinysrgb&w=400",
      "description":
          "Analyse détaillée des tendances et opportunités du marché immobilier français.",
      "category": "Immobilier",
      "downloadUrl": "https://example.com/real-estate-report.pdf",
      "progress": 1.0,
    },
  ];

  // Mock data for AI recommendations
  final List<Map<String, dynamic>> _aiRecommendations = [
    {
      "id": 1,
      "title": "Formation en Gestion de Projet",
      "type": "Cours",
      "relevanceScore": 95,
      "reason": "Basé sur votre intérêt pour le leadership et la construction",
      "thumbnail":
          "https://images.pexels.com/photos/3184360/pexels-photo-3184360.jpeg?auto=compress&cs=tinysrgb&w=400",
      "description":
          "Cours complet sur les méthodologies agiles en gestion de projet.",
      "category": "Formation",
    },
    {
      "id": 2,
      "title": "Networking: Entrepreneurs du BTP",
      "type": "Événement",
      "relevanceScore": 88,
      "reason": "Correspondant à votre profil professionnel",
      "thumbnail":
          "https://images.pexels.com/photos/3184339/pexels-photo-3184339.jpeg?auto=compress&cs=tinysrgb&w=400",
      "description":
          "Rencontre mensuelle des entrepreneurs du secteur du bâtiment.",
      "category": "Networking",
    },
    {
      "id": 3,
      "title": "Webinaire: IA en Agriculture",
      "type": "Webinaire",
      "relevanceScore": 82,
      "reason": "Aligné avec vos recherches récentes",
      "thumbnail":
          "https://images.pexels.com/photos/3184317/pexels-photo-3184317.jpeg?auto=compress&cs=tinysrgb&w=400",
      "description":
          "Comment l'intelligence artificielle révolutionne les pratiques agricoles.",
      "category": "Technologie",
    },
  ];

  final List<String> _filterOptions = [
    'Tous',
    'Leadership',
    'Construction',
    'Agriculture',
    'Immobilier',
    'Innovation'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _setupScrollListeners();
  }

  void _setupScrollListeners() {
    _discussionScrollController.addListener(() {
      if (_discussionScrollController.position.pixels ==
          _discussionScrollController.position.maxScrollExtent) {
        _loadMoreDiscussions();
      }
    });

    _resourceScrollController.addListener(() {
      if (_resourceScrollController.position.pixels ==
          _resourceScrollController.position.maxScrollExtent) {
        _loadMoreResources();
      }
    });
  }

  Future<void> _loadMoreDiscussions() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    setState(() => _isLoading = false);
  }

  Future<void> _loadMoreResources() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    setState(() => _isLoading = false);
  }

  Future<void> _refreshContent() async {
    setState(() => _isLoading = true);

    // Simulate refresh
    await Future.delayed(Duration(seconds: 1));

    setState(() => _isLoading = false);
  }

  void _showPostComposer() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PostComposerWidget(
        onPost: (String content, List<String> tags) {
          // Handle post creation
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Publication créée avec succès'),
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            ),
          );
        },
      ),
    );
  }

  void _showAuthenticationPrompt() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Connexion requise'),
        content:
            Text('Vous devez vous connecter pour interagir avec le contenu.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/authentication-screen');
            },
            child: Text('Se connecter'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _discussionScrollController.dispose();
    _resourceScrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        foregroundColor: Colors.white,
        title: Text(
          'Communauté & Leadership',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pushNamed(context, '/home-dashboard'),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: Colors.white,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() => _isSearching = !_isSearching);
            },
            icon: CustomIconWidget(
              iconName: _isSearching ? 'close' : 'search',
              color: Colors.white,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/ai-chat-assistant'),
            icon: CustomIconWidget(
              iconName: 'smart_toy',
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(_isSearching ? 120.0 : 48.0),
          child: Column(
            children: [
              if (_isSearching) _buildSearchBar(),
              TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white.withValues(alpha: 0.7),
                labelStyle: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle:
                    AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                ),
                tabs: [
                  Tab(text: 'Discussions'),
                  Tab(text: 'Ressources'),
                  Tab(text: 'IA Recommandations'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDiscussionsTab(),
          _buildResourcesTab(),
          _buildAIRecommendationsTab(),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              onPressed: _showPostComposer,
              backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
              child: CustomIconWidget(
                iconName: 'add',
                color: Colors.white,
                size: 24,
              ),
            )
          : null,
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: TextField(
        controller: _searchController,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          hintText: 'Rechercher dans la communauté...',
          hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
          ),
          prefixIcon: CustomIconWidget(
            iconName: 'search',
            color: Colors.white.withValues(alpha: 0.7),
            size: 20,
          ),
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        ),
        onChanged: (value) {
          // Implement search functionality
        },
      ),
    );
  }

  Widget _buildDiscussionsTab() {
    return RefreshIndicator(
      onRefresh: _refreshContent,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: ListView.builder(
              controller: _discussionScrollController,
              padding: EdgeInsets.symmetric(vertical: 1.h),
              itemCount: _discussions.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _discussions.length) {
                  return _buildLoadingIndicator();
                }

                final discussion = _discussions[index];
                return DiscussionPostWidget(
                  discussion: discussion,
                  onLike: () => _showAuthenticationPrompt(),
                  onComment: () => _showAuthenticationPrompt(),
                  onShare: () {
                    // Implement share functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Lien copié dans le presse-papiers')),
                    );
                  },
                  onTap: () {
                    // Navigate to full thread view
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Ouverture de la discussion complète...')),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourcesTab() {
    return RefreshIndicator(
      onRefresh: _refreshContent,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: Column(
        children: [
          _buildResourceFilterChips(),
          Expanded(
            child: ListView.builder(
              controller: _resourceScrollController,
              padding: EdgeInsets.symmetric(vertical: 1.h),
              itemCount: _resources.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _resources.length) {
                  return _buildLoadingIndicator();
                }

                final resource = _resources[index];
                return ResourceCardWidget(
                  resource: resource,
                  onDownload: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Téléchargement démarré...')),
                    );
                  },
                  onView: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Ouverture de la ressource...')),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIRecommendationsTab() {
    return RefreshIndicator(
      onRefresh: _refreshContent,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        itemCount: _aiRecommendations.length,
        itemBuilder: (context, index) {
          final recommendation = _aiRecommendations[index];
          return AIRecommendationWidget(
            recommendation: recommendation,
            onTap: () => _showAuthenticationPrompt(),
            onDismiss: () {
              setState(() {
                _aiRecommendations.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Recommandation masquée')),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 6.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filterOptions.length,
        itemBuilder: (context, index) {
          final filter = _filterOptions[index];
          final isSelected = _selectedFilter == filter;

          return Container(
            margin: EdgeInsets.only(right: 2.w),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              backgroundColor: AppTheme.lightTheme.colorScheme.surface,
              selectedColor: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.2),
              labelStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              side: BorderSide(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResourceFilterChips() {
    final resourceFilters = ['Tous', 'PDF', 'Vidéo', 'Audio', 'Formation'];

    return Container(
      height: 6.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: resourceFilters.length,
        itemBuilder: (context, index) {
          final filter = resourceFilters[index];
          final isSelected = _selectedFilter == filter;

          return Container(
            margin: EdgeInsets.only(right: 2.w),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              backgroundColor: AppTheme.lightTheme.colorScheme.surface,
              selectedColor: AppTheme.lightTheme.colorScheme.secondary
                  .withValues(alpha: 0.2),
              labelStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.secondary
                    : AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              side: BorderSide(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.secondary
                    : AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Center(
        child: CircularProgressIndicator(
          color: AppTheme.lightTheme.colorScheme.primary,
        ),
      ),
    );
  }
}
