import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProductionChartWidget extends StatefulWidget {
  const ProductionChartWidget({Key? key}) : super(key: key);

  @override
  State<ProductionChartWidget> createState() => _ProductionChartWidgetState();
}

class _ProductionChartWidgetState extends State<ProductionChartWidget> {
  int _selectedChartIndex = 0;

  final List<Map<String, dynamic>> _chartTypes = [
    {"title": "Production Mensuelle", "type": "bar"},
    {"title": "Tendances Saisonnières", "type": "line"},
    {"title": "Répartition des Cultures", "type": "pie"},
  ];

  final List<BarChartGroupData> _monthlyProductionData = [
    BarChartGroupData(x: 0, barRods: [
      BarChartRodData(toY: 120, color: AppTheme.lightTheme.colorScheme.primary)
    ]),
    BarChartGroupData(x: 1, barRods: [
      BarChartRodData(toY: 150, color: AppTheme.lightTheme.colorScheme.primary)
    ]),
    BarChartGroupData(x: 2, barRods: [
      BarChartRodData(toY: 180, color: AppTheme.lightTheme.colorScheme.primary)
    ]),
    BarChartGroupData(x: 3, barRods: [
      BarChartRodData(toY: 200, color: AppTheme.lightTheme.colorScheme.primary)
    ]),
    BarChartGroupData(x: 4, barRods: [
      BarChartRodData(toY: 250, color: AppTheme.lightTheme.colorScheme.primary)
    ]),
    BarChartGroupData(x: 5, barRods: [
      BarChartRodData(toY: 280, color: AppTheme.lightTheme.colorScheme.primary)
    ]),
  ];

  final List<FlSpot> _seasonalTrendsData = [
    const FlSpot(0, 100),
    const FlSpot(1, 120),
    const FlSpot(2, 150),
    const FlSpot(3, 180),
    const FlSpot(4, 220),
    const FlSpot(5, 250),
    const FlSpot(6, 280),
    const FlSpot(7, 300),
    const FlSpot(8, 280),
    const FlSpot(9, 240),
    const FlSpot(10, 200),
    const FlSpot(11, 150),
  ];

  final List<PieChartSectionData> _cropDistributionData = [
    PieChartSectionData(
        value: 40,
        title: 'Tomates\n40%',
        color: AppTheme.lightTheme.colorScheme.primary,
        radius: 60,
        titleStyle: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
    PieChartSectionData(
        value: 35,
        title: 'Maïs\n35%',
        color: AppTheme.lightTheme.colorScheme.secondary,
        radius: 60,
        titleStyle: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
    PieChartSectionData(
        value: 25,
        title: 'Laitue\n25%',
        color: AppTheme.lightTheme.colorScheme.tertiary,
        radius: 60,
        titleStyle: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2)),
            ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
                child: Text(_chartTypes[_selectedChartIndex]["title"],
                    style: Theme.of(context).textTheme.titleMedium)),
            PopupMenuButton<int>(
                icon: CustomIconWidget(
                    iconName: 'more_horiz',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 24),
                onSelected: (index) {
                  setState(() {
                    _selectedChartIndex = index;
                  });
                },
                itemBuilder: (context) => _chartTypes
                    .asMap()
                    .entries
                    .map((entry) => PopupMenuItem<int>(
                        value: entry.key, child: Text(entry.value["title"])))
                    .toList()),
          ]),
          SizedBox(height: 3.h),
          SizedBox(height: 30.h, child: _buildSelectedChart()),
          SizedBox(height: 2.h),
          _buildChartLegend(),
        ]));
  }

  Widget _buildSelectedChart() {
    switch (_chartTypes[_selectedChartIndex]["type"]) {
      case "bar":
        return _buildBarChart();
      case "line":
        return _buildLineChart();
      case "pie":
        return _buildPieChart();
      default:
        return _buildBarChart();
    }
  }

  Widget _buildBarChart() {
    return BarChart(BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 300,
        barTouchData: BarTouchData(touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
          final months = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun'];
          return BarTooltipItem('${months[group.x]}\n${rod.toY.round()} kg',
              Theme.of(context).textTheme.bodySmall!);
        })),
        titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const months = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun'];
                      if (value.toInt() >= 0 && value.toInt() < months.length) {
                        return Text(months[value.toInt()],
                            style: Theme.of(context).textTheme.labelSmall);
                      }
                      return const Text('');
                    })),
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text('${value.toInt()}',
                          style: Theme.of(context).textTheme.labelSmall);
                    })),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false))),
        borderData: FlBorderData(show: false),
        barGroups: _monthlyProductionData,
        gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 50,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                  strokeWidth: 1);
            })));
  }

  Widget _buildLineChart() {
    return LineChart(LineChartData(
        gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 50,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                  strokeWidth: 1);
            }),
        titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const months = [
                        'J',
                        'F',
                        'M',
                        'A',
                        'M',
                        'J',
                        'J',
                        'A',
                        'S',
                        'O',
                        'N',
                        'D'
                      ];
                      if (value.toInt() >= 0 && value.toInt() < months.length) {
                        return Text(months[value.toInt()],
                            style: Theme.of(context).textTheme.labelSmall);
                      }
                      return const Text('');
                    })),
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text('${value.toInt()}',
                          style: Theme.of(context).textTheme.labelSmall);
                    })),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false))),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: 11,
        minY: 0,
        maxY: 350,
        lineBarsData: [
          LineChartBarData(
              spots: _seasonalTrendsData,
              isCurved: true,
              color: AppTheme.lightTheme.colorScheme.primary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                        radius: 4,
                        color: AppTheme.lightTheme.colorScheme.primary,
                        strokeWidth: 2,
                        strokeColor: Colors.white);
                  }),
              belowBarData: BarAreaData(
                  show: true,
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1))),
        ],
        lineTouchData: LineTouchData(touchTooltipData:
            LineTouchTooltipData(getTooltipItems: (touchedSpots) {
          return touchedSpots.map((spot) {
            const months = [
              'Jan',
              'Fév',
              'Mar',
              'Avr',
              'Mai',
              'Jun',
              'Jul',
              'Aoû',
              'Sep',
              'Oct',
              'Nov',
              'Déc'
            ];
            return LineTooltipItem(
                '${months[spot.x.toInt()]}\n${spot.y.round()} kg',
                Theme.of(context).textTheme.bodySmall!);
          }).toList();
        }))));
  }

  Widget _buildPieChart() {
    return PieChart(PieChartData(
        sections: _cropDistributionData,
        centerSpaceRadius: 40,
        sectionsSpace: 2,
        pieTouchData:
            PieTouchData(touchCallback: (FlTouchEvent event, pieTouchResponse) {
          // Handle touch interactions
        })));
  }

  Widget _buildChartLegend() {
    switch (_chartTypes[_selectedChartIndex]["type"]) {
      case "bar":
        return _buildBarLegend();
      case "line":
        return _buildLineLegend();
      case "pie":
        return _buildPieLegend();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildBarLegend() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
          width: 4.w,
          height: 2.h,
          decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary,
              borderRadius: BorderRadius.circular(2))),
      SizedBox(width: 2.w),
      Text("Production (kg)", style: Theme.of(context).textTheme.labelMedium),
    ]);
  }

  Widget _buildLineLegend() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
          width: 6.w,
          height: 0.3.h,
          decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary,
              borderRadius: BorderRadius.circular(2))),
      SizedBox(width: 2.w),
      Text("Tendance annuelle", style: Theme.of(context).textTheme.labelMedium),
    ]);
  }

  Widget _buildPieLegend() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      _buildLegendItem("Tomates", AppTheme.lightTheme.colorScheme.primary),
      _buildLegendItem("Maïs", AppTheme.lightTheme.colorScheme.secondary),
      _buildLegendItem("Laitue", AppTheme.lightTheme.colorScheme.tertiary),
    ]);
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
          width: 3.w,
          height: 3.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      SizedBox(width: 1.w),
      Text(label, style: Theme.of(context).textTheme.labelSmall),
    ]);
  }
}
