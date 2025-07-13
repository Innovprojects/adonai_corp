import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TechnicalDatasheetWidget extends StatefulWidget {
  final List<Map<String, dynamic>> crops;

  const TechnicalDatasheetWidget({
    Key? key,
    required this.crops,
  }) : super(key: key);

  @override
  State<TechnicalDatasheetWidget> createState() =>
      _TechnicalDatasheetWidgetState();
}

class _TechnicalDatasheetWidgetState extends State<TechnicalDatasheetWidget> {
  int _selectedCropIndex = 0;

  final Map<String, Map<String, dynamic>> _technicalData = {
    "Tomates Cerises": {
      "semis": {
        "periode": "Mars - Avril",
        "temperature": "18-22°C",
        "profondeur": "0.5-1 cm",
        "espacement": "30-40 cm"
      },
      "croissance": {
        "duree": "70-80 jours",
        "arrosage": "Régulier, 2-3 fois/semaine",
        "fertilisation": "NPK 10-10-10 tous les 15 jours",
        "taille": "Éliminer les gourmands"
      },
      "recolte": {
        "periode": "Juillet - Septembre",
        "rendement": "3-4 kg/m²",
        "conservation": "5-7 jours à température ambiante",
        "signes": "Couleur rouge uniforme"
      },
      "maladies": [
        {
          "nom": "Mildiou",
          "traitement": "Bouillie bordelaise",
          "prevention": "Aération"
        },
        {
          "nom": "Pucerons",
          "traitement": "Savon noir",
          "prevention": "Plantes répulsives"
        }
      ]
    },
    "Maïs Doux": {
      "semis": {
        "periode": "Avril - Mai",
        "temperature": "12-15°C",
        "profondeur": "3-4 cm",
        "espacement": "25-30 cm"
      },
      "croissance": {
        "duree": "90-100 jours",
        "arrosage": "Abondant pendant la floraison",
        "fertilisation": "Riche en azote",
        "buttage": "Nécessaire pour la stabilité"
      },
      "recolte": {
        "periode": "Juillet - Août",
        "rendement": "1-2 épis/plant",
        "conservation": "Consommer rapidement",
        "signes": "Soies brunes, grains laiteux"
      },
      "maladies": [
        {
          "nom": "Pyrale",
          "traitement": "Bacillus thuringiensis",
          "prevention": "Rotation des cultures"
        },
        {
          "nom": "Charbon",
          "traitement": "Destruction des plants",
          "prevention": "Semences saines"
        }
      ]
    },
    "Laitue Romaine": {
      "semis": {
        "periode": "Mars - Septembre",
        "temperature": "15-18°C",
        "profondeur": "0.5 cm",
        "espacement": "25-30 cm"
      },
      "croissance": {
        "duree": "45-60 jours",
        "arrosage": "Régulier mais modéré",
        "fertilisation": "Compost bien décomposé",
        "eclaircissage": "Nécessaire"
      },
      "recolte": {
        "periode": "Mai - Novembre",
        "rendement": "300-500g/plant",
        "conservation": "1 semaine au réfrigérateur",
        "signes": "Pomme bien formée"
      },
      "maladies": [
        {
          "nom": "Limaces",
          "traitement": "Pièges à bière",
          "prevention": "Paillis répulsif"
        },
        {
          "nom": "Pourriture",
          "traitement": "Aération",
          "prevention": "Éviter l'excès d'eau"
        }
      ]
    }
  };

  @override
  Widget build(BuildContext context) {
    final cropNames =
        widget.crops.map((crop) => crop["name"] as String).toList();
    final selectedCropName =
        cropNames.isNotEmpty ? cropNames[_selectedCropIndex] : "";
    final technicalInfo = _technicalData[selectedCropName] ?? {};

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
          Row(
            children: [
              CustomIconWidget(
                iconName: 'description',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  "Fiches Techniques",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Téléchargement PDF en cours...'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: CustomIconWidget(
                  iconName: 'download',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          if (cropNames.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: _selectedCropIndex,
                  isExpanded: true,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCropIndex = value;
                      });
                    }
                  },
                  items: cropNames.asMap().entries.map((entry) {
                    return DropdownMenuItem<int>(
                      value: entry.key,
                      child: Text(entry.value),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 3.h),
          ],
          Expanded(
            child: technicalInfo.isNotEmpty
                ? SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (technicalInfo["semis"] != null)
                          _buildSection(
                              context, "Semis", technicalInfo["semis"], 'eco'),
                        if (technicalInfo["croissance"] != null)
                          _buildSection(context, "Croissance",
                              technicalInfo["croissance"], 'trending_up'),
                        if (technicalInfo["recolte"] != null)
                          _buildSection(context, "Récolte",
                              technicalInfo["recolte"], 'agriculture'),
                        if (technicalInfo["maladies"] != null)
                          _buildDiseasesSection(
                              context, technicalInfo["maladies"]),
                      ],
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'info',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 48,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "Aucune fiche technique disponible",
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
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

  Widget _buildSection(
    BuildContext context,
    String title,
    Map<String, dynamic> data,
    String iconName,
  ) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 3.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: iconName,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          ...data.entries.map((entry) {
            return Padding(
              padding: EdgeInsets.only(bottom: 1.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 25.w,
                    child: Text(
                      "${entry.key.substring(0, 1).toUpperCase()}${entry.key.substring(1)}:",
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      entry.value.toString(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildDiseasesSection(
    BuildContext context,
    List<dynamic> diseases,
  ) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 3.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'bug_report',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                "Maladies et Ravageurs",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          ...diseases.map((disease) {
            final diseaseMap = disease as Map<String, dynamic>;
            return Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 2.h),
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.errorContainer
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.error
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    diseaseMap["nom"] ?? "Maladie inconnue",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.lightTheme.colorScheme.error,
                        ),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 20.w,
                        child: Text(
                          "Traitement:",
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          diseaseMap["traitement"] ?? "Non spécifié",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 20.w,
                        child: Text(
                          "Prévention:",
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          diseaseMap["prevention"] ?? "Non spécifié",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
