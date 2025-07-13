import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/ai_recommendations_widget.dart';
import './widgets/crop_tracking_card.dart';
import './widgets/production_chart_widget.dart';
import './widgets/technical_datasheet_widget.dart';
import './widgets/weather_widget.dart';

class AgribusinessDashboard extends StatefulWidget {
  const AgribusinessDashboard({Key? key}) : super(key: key);

  @override
  State<AgribusinessDashboard> createState() => _AgribusinessDashboardState();
}

class _AgribusinessDashboardState extends State<AgribusinessDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isRefreshing = false;

  final List<Map<String, dynamic>> _cropData = [
    {
      "id": 1,
      "name": "Tomates Cerises",
      "variety": "Cherry Roma",
      "plantedDate": DateTime(2025, 5, 15),
      "expectedHarvest": DateTime(2025, 8, 20),
      "currentStage": "Floraison",
      "progress": 0.65,
      "nextAction": "Arrosage dans 2 jours",
      "image":
          "https://images.pexels.com/photos/533280/pexels-photo-533280.jpeg",
      "area": "250 m²",
      "yield": "85 kg estimé"
    },
    {
      "id": 2,
      "name": "Maïs Doux",
      "variety": "Golden Bantam",
      "plantedDate": DateTime(2025, 4, 10),
      "expectedHarvest": DateTime(2025, 7, 25),
      "currentStage": "Maturation",
      "progress": 0.80,
      "nextAction": "Fertilisation NPK",
      "image":
          "https://images.pexels.com/photos/547263/pexels-photo-547263.jpeg",
      "area": "500 m²",
      "yield": "320 kg estimé"
    },
    {
      "id": 3,
      "name": "Laitue Romaine",
      "variety": "Cos Lettuce",
      "plantedDate": DateTime(2025, 6, 1),
      "expectedHarvest": DateTime(2025, 7, 15),
      "currentStage": "Croissance",
      "progress": 0.45,
      "nextAction": "Traitement bio",
      "image":
          "https://images.pexels.com/photos/1656663/pexels-photo-1656663.jpeg",
      "area": "150 m²",
      "yield": "45 kg estimé"
    }
  ];

  final List<Map<String, dynamic>> _weatherData = [
    {
      "day": "Aujourd'hui",
      "date": "13 Jul",
      "temperature": "28°C",
      "condition": "Ensoleillé",
      "precipitation": "0%",
      "humidity": "65%",
      "icon": "wb_sunny"
    },
    {
      "day": "Demain",
      "date": "14 Jul",
      "temperature": "26°C",
      "condition": "Nuageux",
      "precipitation": "15%",
      "humidity": "70%",
      "icon": "cloud"
    },
    {
      "day": "Mardi",
      "date": "15 Jul",
      "temperature": "24°C",
      "condition": "Pluie légère",
      "precipitation": "60%",
      "humidity": "85%",
      "icon": "grain"
    },
    {
      "day": "Mercredi",
      "date": "16 Jul",
      "temperature": "27°C",
      "condition": "Partiellement nuageux",
      "precipitation": "20%",
      "humidity": "68%",
      "icon": "wb_cloudy"
    },
    {
      "day": "Jeudi",
      "date": "17 Jul",
      "temperature": "29°C",
      "condition": "Ensoleillé",
      "precipitation": "5%",
      "humidity": "60%",
      "icon": "wb_sunny"
    }
  ];

  final List<Map<String, dynamic>> _aiRecommendations = [
    {
      "id": 1,
      "title": "Optimisation de l'irrigation",
      "description":
          "Basé sur les prévisions météo, réduisez l'arrosage de 30% cette semaine pour vos tomates.",
      "priority": "Haute",
      "category": "Irrigation",
      "confidence": 0.92,
      "savings": "15% d'eau économisée"
    },
    {
      "id": 2,
      "title": "Fertilisation du maïs",
      "description":
          "Application d'engrais NPK recommandée dans 3-5 jours selon l'analyse du sol.",
      "priority": "Moyenne",
      "category": "Fertilisation",
      "confidence": 0.87,
      "savings": "12% d'amélioration du rendement"
    },
    {
      "id": 3,
      "title": "Protection biologique",
      "description":
          "Risque de pucerons détecté. Traitement préventif avec huile de neem recommandé.",
      "priority": "Haute",
      "category": "Protection",
      "confidence": 0.89,
      "savings": "Prévention de 80% des dégâts"
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _showBottomSheet(BuildContext context, String type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: type == 'calculator'
            ? _buildCalculatorSheet()
            : _buildTechnicalDataSheet(),
      ),
    );
  }

  Widget _buildCalculatorSheet() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            "Calculateur d'Engrais",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildCalculatorInput("Surface (m²)", "250"),
                  SizedBox(height: 2.h),
                  _buildCalculatorInput("Type de culture", "Tomates"),
                  SizedBox(height: 2.h),
                  _buildCalculatorInput("NPK souhaité", "10-10-10"),
                  SizedBox(height: 3.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Recommandation",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          "• Quantité: 12.5 kg d'engrais NPK\n• Fréquence: Tous les 15 jours\n• Dilution: 20g par litre d'eau",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculatorInput(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        SizedBox(height: 1.h),
        TextFormField(
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTechnicalDataSheet() {
    return TechnicalDatasheetWidget(
      crops: _cropData,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tableau de Bord Agricole"),
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: Colors.white,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'notifications',
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: Colors.white,
              size: 24,
            ),
            onSelected: (value) {
              switch (value) {
                case 'home':
                  Navigator.pushNamed(context, '/home-dashboard');
                  break;
                case 'real_estate':
                  Navigator.pushNamed(context, '/real-estate-properties');
                  break;
                case 'community':
                  Navigator.pushNamed(context, '/community-forum');
                  break;
                case 'ai_chat':
                  Navigator.pushNamed(context, '/ai-chat-assistant');
                  break;
                case 'auth':
                  Navigator.pushNamed(context, '/authentication-screen');
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'home',
                child: Text('Accueil'),
              ),
              const PopupMenuItem(
                value: 'real_estate',
                child: Text('Immobilier'),
              ),
              const PopupMenuItem(
                value: 'community',
                child: Text('Communauté'),
              ),
              const PopupMenuItem(
                value: 'ai_chat',
                child: Text('Assistant IA'),
              ),
              const PopupMenuItem(
                value: 'auth',
                child: Text('Connexion'),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Tableau de Bord"),
            Tab(text: "Cultures"),
            Tab(text: "Recommandations"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDashboardTab(),
          _buildCropsTab(),
          _buildRecommendationsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBottomSheet(context, 'datasheet'),
        child: CustomIconWidget(
          iconName: 'description',
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildDashboardTab() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WeatherWidget(weatherData: _weatherData),
            SizedBox(height: 3.h),
            Text(
              "Métriques de Production",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            ProductionChartWidget(),
            SizedBox(height: 3.h),
            Text(
              "Cultures Actives",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _cropData.length > 2 ? 2 : _cropData.length,
              itemBuilder: (context, index) {
                return CropTrackingCard(
                  cropData: _cropData[index],
                  onSwipeAction: (action) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Action: $action'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                );
              },
            ),
            if (_cropData.length > 2)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: Center(
                  child: TextButton(
                    onPressed: () => _tabController.animateTo(1),
                    child: const Text("Voir toutes les cultures"),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCropsTab() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Toutes les Cultures",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                ElevatedButton.icon(
                  onPressed: () => _showBottomSheet(context, 'calculator'),
                  icon: CustomIconWidget(
                    iconName: 'calculate',
                    color: Colors.white,
                    size: 20,
                  ),
                  label: const Text("Calculateur"),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _cropData.length,
              itemBuilder: (context, index) {
                return CropTrackingCard(
                  cropData: _cropData[index],
                  onSwipeAction: (action) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Action: $action pour ${_cropData[index]["name"]}'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsTab() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Recommandations IA",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 1.h),
            Text(
              "Conseils personnalisés basés sur vos données",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
            ),
            SizedBox(height: 3.h),
            AIRecommendationsWidget(recommendations: _aiRecommendations),
          ],
        ),
      ),
    );
  }
}
