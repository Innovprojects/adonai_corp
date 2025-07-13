import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/property_card_widget.dart';
import './widgets/property_detail_widget.dart';
import './widgets/property_filter_widget.dart';
import './widgets/property_map_widget.dart';

class RealEstateProperties extends StatefulWidget {
  const RealEstateProperties({Key? key}) : super(key: key);

  @override
  State<RealEstateProperties> createState() => _RealEstatePropertiesState();
}

class _RealEstatePropertiesState extends State<RealEstateProperties>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isFilterVisible = false;
  String _selectedPropertyType = 'Tous';
  double _minPrice = 50000;
  double _maxPrice = 1000000;
  double _radiusKm = 10;
  List<Map<String, dynamic>> _filteredProperties = [];
  bool _isLoading = false;

  // Mock property data
  final List<Map<String, dynamic>> _allProperties = [
    {
      "id": 1,
      "title": "Villa Moderne avec Piscine",
      "price": "\\€750,000",
      "location": "Nice, Côte d'Azur",
      "type": "Villa",
      "bedrooms": 4,
      "bathrooms": 3,
      "area": 250,
      "description":
          "Magnifique villa moderne avec piscine privée, jardin paysager et vue mer panoramique. Située dans un quartier résidentiel calme.",
      "images": [
        "https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?fm=jpg&q=60&w=3000",
        "https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?fm=jpg&q=60&w=3000",
        "https://images.unsplash.com/photo-1600566753190-17f0baa2a6c3?fm=jpg&q=60&w=3000"
      ],
      "latitude": 43.7102,
      "longitude": 7.2620,
      "contact": {
        "name": "Marie Dubois",
        "phone": "+33 6 12 34 56 78",
        "email": "marie.dubois@immobilier.fr"
      },
      "features": ["Piscine", "Jardin", "Garage", "Climatisation"],
      "isFavorite": false,
      "lastUpdated": "2025-07-12"
    },
    {
      "id": 2,
      "title": "Appartement Centre-Ville",
      "price": "\\€320,000",
      "location": "Lyon, Rhône-Alpes",
      "type": "Appartement",
      "bedrooms": 2,
      "bathrooms": 1,
      "area": 85,
      "description":
          "Appartement lumineux en centre-ville avec balcon, proche des transports et commerces. Rénové récemment avec finitions de qualité.",
      "images": [
        "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?fm=jpg&q=60&w=3000",
        "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?fm=jpg&q=60&w=3000"
      ],
      "latitude": 45.7640,
      "longitude": 4.8357,
      "contact": {
        "name": "Pierre Martin",
        "phone": "+33 6 98 76 54 32",
        "email": "pierre.martin@immobilier.fr"
      },
      "features": ["Balcon", "Ascenseur", "Cave", "Parking"],
      "isFavorite": true,
      "lastUpdated": "2025-07-11"
    },
    {
      "id": 3,
      "title": "Maison de Campagne",
      "price": "\\€450,000",
      "location": "Provence, Vaucluse",
      "type": "Maison",
      "bedrooms": 3,
      "bathrooms": 2,
      "area": 180,
      "description":
          "Charmante maison de campagne avec grand terrain, idéale pour les amoureux de la nature. Possibilité d'extension.",
      "images": [
        "https://images.unsplash.com/photo-1570129477492-45c003edd2be?fm=jpg&q=60&w=3000",
        "https://images.unsplash.com/photo-1564013799919-ab600027ffc6?fm=jpg&q=60&w=3000"
      ],
      "latitude": 44.0582,
      "longitude": 4.8351,
      "contact": {
        "name": "Sophie Leroy",
        "phone": "+33 6 45 67 89 01",
        "email": "sophie.leroy@immobilier.fr"
      },
      "features": ["Grand terrain", "Cheminée", "Garage", "Calme"],
      "isFavorite": false,
      "lastUpdated": "2025-07-10"
    },
    {
      "id": 4,
      "title": "Loft Industriel",
      "price": "\\€580,000",
      "location": "Paris, Île-de-France",
      "type": "Loft",
      "bedrooms": 1,
      "bathrooms": 1,
      "area": 120,
      "description":
          "Loft industriel unique avec hauts plafonds et poutres apparentes. Espace ouvert idéal pour artistes ou professionnels créatifs.",
      "images": [
        "https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?fm=jpg&q=60&w=3000",
        "https://images.unsplash.com/photo-1493809842364-78817add7ffb?fm=jpg&q=60&w=3000"
      ],
      "latitude": 48.8566,
      "longitude": 2.3522,
      "contact": {
        "name": "Thomas Bernard",
        "phone": "+33 6 23 45 67 89",
        "email": "thomas.bernard@immobilier.fr"
      },
      "features": [
        "Hauts plafonds",
        "Poutres",
        "Espace ouvert",
        "Métro proche"
      ],
      "isFavorite": false,
      "lastUpdated": "2025-07-13"
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _filteredProperties = List.from(_allProperties);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterProperties() {
    setState(() {
      _filteredProperties = _allProperties.where((property) {
        final price = double.tryParse((property['price'] as String)
                .replaceAll(RegExp(r'[^\d]'), '')) ??
            0;
        final matchesType = _selectedPropertyType == 'Tous' ||
            property['type'] == _selectedPropertyType;
        final matchesPrice = price >= _minPrice && price <= _maxPrice;
        final matchesSearch = _searchController.text.isEmpty ||
            (property['title'] as String)
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            (property['location'] as String)
                .toLowerCase()
                .contains(_searchController.text.toLowerCase());

        return matchesType && matchesPrice && matchesSearch;
      }).toList();
    });
  }

  void _refreshProperties() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      // Update last updated timestamps
      for (var property in _allProperties) {
        property['lastUpdated'] = '2025-07-13';
      }
    });

    _filterProperties();
  }

  void _toggleFavorite(int propertyId) {
    setState(() {
      final propertyIndex =
          _allProperties.indexWhere((p) => p['id'] == propertyId);
      if (propertyIndex != -1) {
        _allProperties[propertyIndex]['isFavorite'] =
            !(_allProperties[propertyIndex]['isFavorite'] as bool);
      }
    });
    _filterProperties();
  }

  void _showPropertyDetail(Map<String, dynamic> property) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PropertyDetailWidget(
        property: property,
        onFavoriteToggle: () => _toggleFavorite(property['id'] as int),
      ),
    );
  }

  void _showAddPropertyForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 90.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
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
              SizedBox(height: 2.h),
              Text(
                'Ajouter une Propriété',
                style: AppTheme.lightTheme.textTheme.headlineSmall,
              ),
              SizedBox(height: 3.h),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Titre de la propriété',
                          hintText: 'Ex: Villa moderne avec piscine',
                        ),
                      ),
                      SizedBox(height: 2.h),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Prix',
                          hintText: 'Ex: 750000',
                          prefixText: '€ ',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 2.h),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Localisation',
                          hintText: 'Ex: Nice, Côte d\'Azur',
                        ),
                      ),
                      SizedBox(height: 2.h),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Type de propriété',
                        ),
                        value: 'Villa',
                        items: ['Villa', 'Appartement', 'Maison', 'Loft']
                            .map((type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                ))
                            .toList(),
                        onChanged: (value) {},
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                labelText: 'Chambres',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                labelText: 'Salles de bain',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Surface (m²)',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 2.h),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          hintText: 'Décrivez votre propriété...',
                        ),
                        maxLines: 3,
                      ),
                      SizedBox(height: 3.h),
                      Container(
                        width: double.infinity,
                        height: 15.h,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.outline,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'add_a_photo',
                              size: 8.w,
                              color: AppTheme.lightTheme.colorScheme.primary,
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Ajouter des photos',
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Propriété ajoutée avec succès!'),
                              ),
                            );
                          },
                          child: const Text('Publier la propriété'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Immobilier'),
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: Colors.white,
            size: 6.w,
          ),
          onPressed: () => Navigator.pushNamed(context, '/home-dashboard'),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Carte', icon: Icon(Icons.map)),
            Tab(text: 'Liste', icon: Icon(Icons.list)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: EdgeInsets.all(4.w),
            color: AppTheme.lightTheme.colorScheme.surface,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher une propriété...',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'search',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: CustomIconWidget(
                          iconName: 'clear',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 5.w,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          _filterProperties();
                        },
                      )
                    : null,
              ),
              onChanged: (value) => _filterProperties(),
            ),
          ),

          // Tab View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Map View
                PropertyMapWidget(
                  properties: _filteredProperties,
                  onPropertyTap: _showPropertyDetail,
                ),

                // List View
                RefreshIndicator(
                  onRefresh: () async {
                    _refreshProperties();
                  },
                  child: _isLoading
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: AppTheme.lightTheme.colorScheme.primary,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'Mise à jour des propriétés...',
                                style: AppTheme.lightTheme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        )
                      : _filteredProperties.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomIconWidget(
                                    iconName: 'home_work',
                                    size: 20.w,
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    'Aucune propriété trouvée',
                                    style: AppTheme
                                        .lightTheme.textTheme.titleMedium,
                                  ),
                                  SizedBox(height: 1.h),
                                  Text(
                                    'Essayez de modifier vos filtres',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.symmetric(vertical: 2.h),
                              itemCount: _filteredProperties.length,
                              itemBuilder: (context, index) {
                                final property = _filteredProperties[index];
                                return PropertyCardWidget(
                                  property: property,
                                  onTap: () => _showPropertyDetail(property),
                                  onFavoriteToggle: () =>
                                      _toggleFavorite(property['id'] as int),
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        ],
      ),

      // Filter FAB
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "add",
            onPressed: _showAddPropertyForm,
            backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
            child: CustomIconWidget(
              iconName: 'add',
              color: Colors.white,
              size: 6.w,
            ),
          ),
          SizedBox(height: 2.h),
          FloatingActionButton(
            heroTag: "filter",
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => PropertyFilterWidget(
                  selectedType: _selectedPropertyType,
                  minPrice: _minPrice,
                  maxPrice: _maxPrice,
                  radiusKm: _radiusKm,
                  onApplyFilter: (type, min, max, radius) {
                    setState(() {
                      _selectedPropertyType = type;
                      _minPrice = min;
                      _maxPrice = max;
                      _radiusKm = radius;
                    });
                    _filterProperties();
                  },
                ),
              );
            },
            child: CustomIconWidget(
              iconName: 'filter_list',
              color: Colors.white,
              size: 6.w,
            ),
          ),
        ],
      ),
    );
  }
}
