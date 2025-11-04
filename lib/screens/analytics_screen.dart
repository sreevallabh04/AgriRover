import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/sensor_provider.dart';
import '../providers/predictive_provider.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final sensors = context.read<SensorProvider>().sensors;
    context.read<PredictiveProvider>().recompute(sensors);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sensors = context.watch<SensorProvider>().sensors;
    final predict = context.watch<PredictiveProvider>().latest;

    final moisturePoints = List.generate(
      sensors.length,
      (i) => FlSpot(
          i.toDouble(),
          (sensors[i].type == 'Soil Moisture')
              ? sensors[i].value
              : (50 + i).toDouble()),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Farm Analytics'),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _kpiRow(theme, predict),
            const SizedBox(height: 16),
            _chartCard(theme, moisturePoints),
            const SizedBox(height: 16),
            _insightsCard(theme, predict.summary),
          ],
        ),
      ),
    );
  }

  Widget _kpiRow(ThemeData theme, PredictiveInsight predict) {
    return Row(
      children: [
        Expanded(
          child: _kpiTile(
            theme,
            'Irrigation Suggestion',
            '${predict.recommendedIrrigationPercent.toStringAsFixed(0)}%',
            Icons.water_drop,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _kpiTile(
            theme,
            'Anomaly',
            predict.anomalyDetected ? 'Yes' : 'No',
            predict.anomalyDetected ? Icons.warning : Icons.check_circle,
            predict.anomalyDetected ? Colors.orange : Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _kpiTile(
      ThemeData theme, String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.bodySmall),
                Text(
                  value,
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chartCard(ThemeData theme, List<FlSpot> spots) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Soil Moisture Trend',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: true),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 3,
                    spots: spots,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue.withValues(alpha: 0.15),
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

  Widget _insightsCard(ThemeData theme, String summary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.psychology, color: Colors.purple),
          const SizedBox(width: 12),
          Expanded(
            child: Text(summary, style: theme.textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
