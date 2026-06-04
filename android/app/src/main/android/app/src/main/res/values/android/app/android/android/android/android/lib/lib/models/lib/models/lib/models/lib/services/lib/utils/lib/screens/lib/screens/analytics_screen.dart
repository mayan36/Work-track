import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../services/app_state.dart';
import '../models/day_record.dart';
import '../utils/app_theme.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  Color _barColor(double pct) {
    if (pct >= 90) return AppTheme.success;
    if (pct >= 60) return AppTheme.accent;
    if (pct >= 30) return AppTheme.warning;
    if (pct > 0) return AppTheme.danger;
    return AppTheme.divider;
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final last7 = state.getLast7Days();
    final weeklyAvg = state.weeklyAverage;
    final monthlyAvg = state.monthlyAverage;
    final threshold = state.streakThreshold;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Analytics',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Track your progress over time',
                      style: TextStyle(
                          color: AppTheme.textSecondary, fontSize: 13),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: _AverageCard(
                            label: '7-Day Avg',
                            percentage: weeklyAvg,
                            icon: Icons.calendar_view_week_rounded,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _AverageCard(
                            label: '30-Day Avg',
                            percentage: monthlyAvg,
                            icon: Icons.calendar_month_rounded,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text('Last 7 Days',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 16),
                    _WeekChart(
                      records: last7,
                      threshold: threshold.toDouble(),
                      barColor: _barColor,
                    ),
                    const SizedBox(height: 24),
                    Text('Daily Breakdown',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) {
                    final record = last7[last7.length - 1 - i];
                    return _DayRow(
                      record: record,
                      threshold: threshold,
                      barColor: _barColor(record.completionPercentage),
                    );
                  },
                  childCount: last7.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

class _AverageCard extends StatelessWidget {
  final String label;
  final double percentage;
  final IconData icon;

  const _AverageCard({
    required this.label,
    required this.percentage,
    required this.icon,
  });

  Color get _color {
    if (percentage >= 90) return AppTheme.success;
    if (percentage >= 60) return AppTheme.accent;
    if (percentage >= 30) return AppTheme.warning;
    if (percentage > 0) return AppTheme.danger;
    return AppTheme.textSecondary;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppTheme.textSecondary),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${percentage.toStringAsFixed(1)}%',
            style: TextStyle(
              color: _color,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekChart extends StatelessWidget {
  final List<DayRecord> records;
  final double threshold;
  final Color Function(double) barColor;

  const _WeekChart({
    required this.records,
    required this.threshold,
    required this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 100,
          minY: 0,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => AppTheme.surface,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${rod.toY.toStringAsFixed(1)}%',
                  const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();
                  if (idx < 0 || idx >= records.length) {
                    return const SizedBox();
                  }
                  final date = DateTime.parse(records[idx].date);
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      DateFormat('E').format(date),
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 25,
            getDrawingHorizontalLine: (value) =>
                FlLine(color: AppTheme.divider, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(records.length, (i) {
            final pct = records[i].completionPercentage;
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: pct,
                  color: barColor(pct),
                  width: 22,
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(6)),
                ),
              ],
            );
          }),
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              HorizontalLine(
                y: threshold,
                color: AppTheme.accentLight.withOpacity(0.5),
                strokeWidth: 1.5,
                dashArray: [6, 4],
                label: HorizontalLineLabel(
                  show: true,
                  alignment: Alignment.topRight,
                  labelResolver: (_) => '${threshold.toInt()}%',
                  style: const TextStyle(
                    color: AppTheme.accentLight,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DayRow extends StatelessWidget {
  final DayRecord record;
  final int threshold;
  final Color barColor;

  const _DayRow({
    required this.record,
    required this.threshold,
    required this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    final date = DateTime.parse(record.date);
    final isToday =
        record.date == DateFormat('yyyy-MM-dd').format(DateTime.now());
    final passed = record.completionPercentage >= threshold;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isToday ? 'Today' : DateFormat('EEE').format(date),
                  style: TextStyle(
                    color: isToday ? AppTheme.accent : AppTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  DateFormat('d MMM').format(date),
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: record.completionPercentage / 100,
                backgroundColor: AppTheme.divider,
                valueColor: AlwaysStoppedAnimation<Color>(barColor),
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 52,
            child: Text(
              '${record.completionPercentage.toStringAsFixed(1)}%',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: barColor,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            record.completionPercentage == 0
                ? Icons.remove_circle_outline
                : passed
                    ? Icons.check_circle
                    : Icons.cancel_outlined,
            size: 18,
            color: record.completionPercentage == 0
                ? AppTheme.textSecondary
                : passed
                    ? AppTheme.success
                    : AppTheme.danger,
          ),
        ],
      ),
    );
  }
}
