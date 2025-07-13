import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/chat_message_widget.dart';
import './widgets/quick_action_widget.dart';
import './widgets/typing_indicator_widget.dart';

class AiChatAssistant extends StatefulWidget {
  const AiChatAssistant({Key? key}) : super(key: key);

  @override
  State<AiChatAssistant> createState() => _AiChatAssistantState();
}

class _AiChatAssistantState extends State<AiChatAssistant>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _messageFocusNode = FocusNode();

  bool _isTyping = false;
  bool _isAuthenticated = false;
  bool _showQuickActions = true;
  String _searchQuery = '';

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> _messages = [
    {
      "id": "1",
      "message":
          "Bonjour ! Je suis votre assistant IA ADONAI CORP. Comment puis-je vous aider aujourd'hui ?",
      "isUser": false,
      "timestamp": DateTime.now().subtract(Duration(minutes: 5)),
      "type": "greeting"
    },
    {
      "id": "2",
      "message":
          "Pouvez-vous me donner des conseils pour mon projet de construction ?",
      "isUser": true,
      "timestamp": DateTime.now().subtract(Duration(minutes: 4)),
      "type": "question"
    },
    {
      "id": "3",
      "message":
          "Bien sûr ! Pour vous donner les meilleurs conseils de construction, j'aurais besoin de quelques détails :\n\n• Type de projet (résidentiel, commercial, industriel)\n• Budget approximatif\n• Localisation\n• Timeline souhaité\n\nCela m'aidera à vous fournir des recommandations personnalisées.",
      "isUser": false,
      "timestamp": DateTime.now().subtract(Duration(minutes: 3)),
      "type": "advice"
    }
  ];

  final List<Map<String, dynamic>> _quickActions = [
    {
      "id": "weather",
      "title": "Météo",
      "icon": "cloud",
      "color": Color(0xFF1E90FF),
      "query": "Quelle est la météo aujourd'hui ?"
    },
    {
      "id": "market",
      "title": "Tendances",
      "icon": "trending_up",
      "color": Color(0xFFFF8C00),
      "query": "Quelles sont les tendances du marché ?"
    },
    {
      "id": "crops",
      "title": "Agriculture",
      "icon": "eco",
      "color": Color(0xFF28A745),
      "query": "Conseils pour mes cultures"
    },
    {
      "id": "projects",
      "title": "Projets",
      "icon": "construction",
      "color": Color(0xFF8B0000),
      "query": "Statut de mes projets"
    }
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkAuthentication();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  void _checkAuthentication() {
    // Mock authentication check
    setState(() {
      _isAuthenticated = true; // For demo purposes
    });
  }

  void _sendMessage(String message) {
    if (message.trim().isEmpty) return;

    if (!_isAuthenticated) {
      _showAuthenticationDialog();
      return;
    }

    setState(() {
      _messages.add({
        "id": DateTime.now().millisecondsSinceEpoch.toString(),
        "message": message.trim(),
        "isUser": true,
        "timestamp": DateTime.now(),
        "type": "user_message"
      });
      _showQuickActions = false;
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate AI response
    Future.delayed(Duration(seconds: 2), () {
      _generateAIResponse(message);
    });
  }

  void _generateAIResponse(String userMessage) {
    String response = _getContextualResponse(userMessage);

    setState(() {
      _isTyping = false;
      _messages.add({
        "id": DateTime.now().millisecondsSinceEpoch.toString(),
        "message": response,
        "isUser": false,
        "timestamp": DateTime.now(),
        "type": "ai_response"
      });
    });

    _scrollToBottom();
  }

  String _getContextualResponse(String message) {
    String lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('météo') || lowerMessage.contains('weather')) {
      return "🌤️ Météo d'aujourd'hui :\n\n• Température : 22°C\n• Conditions : Partiellement nuageux\n• Humidité : 65%\n• Vent : 15 km/h\n\nIdéal pour les travaux de construction extérieurs !";
    } else if (lowerMessage.contains('marché') ||
        lowerMessage.contains('tendance')) {
      return "📈 Tendances du marché immobilier :\n\n• Prix moyens en hausse de 3.2%\n• Demande forte pour résidentiel\n• Secteur commercial stable\n• Opportunités en périphérie urbaine\n\nSouhaitez-vous des détails sur une région spécifique ?";
    } else if (lowerMessage.contains('culture') ||
        lowerMessage.contains('agriculture')) {
      return "🌱 Conseils agricoles saisonniers :\n\n• Période idéale pour plantation\n• Irrigation recommandée : 2-3 fois/semaine\n• Fertilisation : NPK 15-15-15\n• Surveillance parasites recommandée\n\nQuel type de culture vous intéresse ?";
    } else if (lowerMessage.contains('projet') ||
        lowerMessage.contains('construction')) {
      return "🏗️ Gestion de projets de construction :\n\n• Phase actuelle : Planification\n• Délais respectés : 85%\n• Budget utilisé : 60%\n• Prochaine étape : Fondations\n\nBesoin d'aide pour optimiser votre planning ?";
    } else {
      return "Je comprends votre question. En tant qu'assistant IA d'ADONAI CORP, je peux vous aider avec :\n\n• Conseils en construction\n• Informations immobilières\n• Guidance agricole\n• Support communautaire\n\nPouvez-vous préciser votre domaine d'intérêt ?";
    }
  }

  void _showAuthenticationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Authentification requise',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          content: Text(
            'Vous devez vous connecter pour utiliser l\'assistant IA.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/authentication-screen');
              },
              child: Text('Se connecter'),
            ),
          ],
        );
      },
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleQuickAction(String query) {
    _sendMessage(query);
  }

  List<Map<String, dynamic>> _getFilteredMessages() {
    if (_searchQuery.isEmpty) return _messages;

    return _messages.where((message) {
      return (message["message"] as String)
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _messageFocusNode.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            if (_searchQuery.isNotEmpty) _buildSearchResults(),
            Expanded(
              child: _buildMessagesList(),
            ),
            if (_showQuickActions && _messages.length <= 3)
              _buildQuickActions(),
            if (_isTyping) _buildTypingIndicator(),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.primaryColor,
      foregroundColor: Colors.white,
      elevation: 2,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: Colors.white,
          size: 24,
        ),
      ),
      title: Row(
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.secondary,
              borderRadius: BorderRadius.circular(4.w),
            ),
            child: CustomIconWidget(
              iconName: 'smart_toy',
              color: Colors.white,
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Assistant IA',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'En ligne',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            showSearch(
              context: context,
              delegate: _ChatSearchDelegate(
                messages: _messages,
                onSearchChanged: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                },
              ),
            );
          },
          icon: CustomIconWidget(
            iconName: 'search',
            color: Colors.white,
            size: 24,
          ),
        ),
        PopupMenuButton<String>(
          icon: CustomIconWidget(
            iconName: 'more_vert',
            color: Colors.white,
            size: 24,
          ),
          onSelected: (value) {
            switch (value) {
              case 'clear':
                setState(() {
                  _messages.clear();
                  _showQuickActions = true;
                });
                break;
              case 'settings':
                // Navigate to settings
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'clear',
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'delete_outline',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text('Effacer l\'historique'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'settings',
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'settings',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text('Paramètres'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    final filteredMessages = _getFilteredMessages();

    return Container(
      padding: EdgeInsets.all(4.w),
      color: AppTheme.lightTheme.colorScheme.primaryContainer,
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'search',
            color: AppTheme.lightTheme.primaryColor,
            size: 20,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              '${filteredMessages.length} résultat(s) pour "$_searchQuery"',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.primaryColor,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _searchQuery = '';
              });
            },
            icon: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.lightTheme.primaryColor,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    final messagesToShow = _getFilteredMessages();

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      itemCount: messagesToShow.length,
      itemBuilder: (context, index) {
        final message = messagesToShow[index];
        return ChatMessageWidget(
          message: message["message"] as String,
          isUser: message["isUser"] as bool,
          timestamp: message["timestamp"] as DateTime,
          searchQuery: _searchQuery,
        );
      },
    );
  }

  Widget _buildQuickActions() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
              width: 1,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actions rapides',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 2.h),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3.5,
                crossAxisSpacing: 3.w,
                mainAxisSpacing: 2.h,
              ),
              itemCount: _quickActions.length,
              itemBuilder: (context, index) {
                final action = _quickActions[index];
                return QuickActionWidget(
                  title: action["title"] as String,
                  icon: action["icon"] as String,
                  color: action["color"] as Color,
                  onTap: () => _handleQuickAction(action["query"] as String),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.secondary,
              borderRadius: BorderRadius.circular(5.w),
            ),
            child: CustomIconWidget(
              iconName: 'smart_toy',
              color: Colors.white,
              size: 16,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: TypingIndicatorWidget(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                // Handle attachment
              },
              icon: CustomIconWidget(
                iconName: 'attach_file',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(6.w),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _messageController,
                  focusNode: _messageFocusNode,
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: _sendMessage,
                  decoration: InputDecoration(
                    hintText: 'Tapez votre message...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                    hintStyle:
                        AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.6),
                    ),
                  ),
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                // Handle voice input
              },
              icon: CustomIconWidget(
                iconName: 'mic',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
            ),
            IconButton(
              onPressed: () => _sendMessage(_messageController.text),
              icon: Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.primaryColor,
                  borderRadius: BorderRadius.circular(5.w),
                ),
                child: CustomIconWidget(
                  iconName: 'send',
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatSearchDelegate extends SearchDelegate<String> {
  final List<Map<String, dynamic>> messages;
  final Function(String) onSearchChanged;

  _ChatSearchDelegate({
    required this.messages,
    required this.onSearchChanged,
  });

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
          onSearchChanged('');
        },
        icon: CustomIconWidget(
          iconName: 'clear',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 24,
        ),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
        onSearchChanged('');
      },
      icon: CustomIconWidget(
        iconName: 'arrow_back',
        color: AppTheme.lightTheme.colorScheme.onSurface,
        size: 24,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onSearchChanged(query);
    close(context, query);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = messages
        .where((message) => (message["message"] as String)
            .toLowerCase()
            .contains(query.toLowerCase()))
        .take(5)
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final message = suggestions[index];
        final messageText = message["message"] as String;
        final isUser = message["isUser"] as bool;

        return ListTile(
          leading: CustomIconWidget(
            iconName: isUser ? 'person' : 'smart_toy',
            color: isUser
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.secondary,
            size: 24,
          ),
          title: Text(
            messageText.length > 50
                ? '${messageText.substring(0, 50)}...'
                : messageText,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          subtitle: Text(
            isUser ? 'Vous' : 'Assistant IA',
            style: AppTheme.lightTheme.textTheme.bodySmall,
          ),
          onTap: () {
            query = messageText;
            onSearchChanged(query);
            close(context, query);
          },
        );
      },
    );
  }
}
