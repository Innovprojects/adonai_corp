import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WeatherWidget extends StatelessWidget {
  final List<Map<String, dynamic>> weatherData;

  const WeatherWidget({
    Key? key,
    required this.weatherData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentWeather = weatherData.isNotEmpty ? weatherData[0] : null;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightTheme.colorScheme.primary,
            AppTheme.lightTheme.colorScheme.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'wb_sunny',
                color: Colors.white,
                size: 32,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Météo Agricole",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      "Conditions actuelles",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  currentWeather != null
                      ? currentWeather["temperature"]
                      : "N/A",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          if (currentWeather != null) ...[
            Row(
              children: [
                Expanded(
                  child: _buildWeatherInfo(
                    context,
                    "Condition",
                    currentWeather["condition"],
                    'cloud',
                  ),
                ),
                Expanded(
                  child: _buildWeatherInfo(
                    context,
                    "Précipitations",
                    currentWeather["precipitation"],
                    'grain',
                  ),
                ),
                Expanded(
                  child: _buildWeatherInfo(
                    context,
                    "Humidité",
                    currentWeather["humidity"],
                    'water_drop',
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
          ],
          Text(
            "Prévisions 5 jours",
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 12.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: weatherData.length,
              itemBuilder: (context, index) {
                final weather = weatherData[index];
                return Container(
                  width: 20.w,
                  margin: EdgeInsets.only(right: 3.w),
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        weather["day"],
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 1.h),
                      CustomIconWidget(
                        iconName: weather["icon"],
                        color: Colors.white,
                        size: 24,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        weather["temperature"],
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      Text(
                        weather["precipitation"],
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherInfo(
    BuildContext context,
    String label,
    String value,
    String iconName,
  ) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: Colors.white.withValues(alpha: 0.8),
          size: 20,
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.7),
              ),
          textAlign: TextAlign.center,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
