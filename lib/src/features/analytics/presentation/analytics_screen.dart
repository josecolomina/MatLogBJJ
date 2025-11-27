import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matlog/l10n/app_localizations.dart';
import '../../training_log/data/training_repository.dart';
import '../../training_log/domain/activity.dart';
import '../../technique_library/data/technique_repository.dart';
import '../../technique_library/domain/technique.dart';

import '../../authentication/data/auth_repository.dart';
import '../../social_rivals/data/rivals_repository.dart';
import '../../social_rivals/domain/rival.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final trainingAsync = ref.watch(userActivitiesProvider);
    final techniquesAsync = ref.watch(userTechniquesProvider);
    final user = ref.watch(authRepositoryProvider).currentUser;
    final rivalsAsync = user != null ? ref.watch(rivalsStreamProvider(user.uid)) : const AsyncValue<List<Rival>>.loading();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.analyticsTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey[50],
      body: trainingAsync.when(
        data: (activities) => techniquesAsync.when(
          data: (techniques) => rivalsAsync.when(
            data: (rivals) => SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context, AppLocalizations.of(context)!.gameStyleTitle, AppLocalizations.of(context)!.gameStyleExplanation),
                  const SizedBox(height: 16),
                  _buildRadarChartCard(techniques),
                  const SizedBox(height: 32),
                  _buildSectionTitle(context, AppLocalizations.of(context)!.trainingDistributionTitle, AppLocalizations.of(context)!.trainingDistributionExplanation),
                  const SizedBox(height: 16),
                  _buildGiNoGiChartCard(activities),
                  const SizedBox(height: 32),
                  _buildSectionTitle(context, AppLocalizations.of(context)!.matTimeTitle, AppLocalizations.of(context)!.matTimeExplanation),
                  const SizedBox(height: 16),
                  _buildMatTimeChartCard(activities),
                  const SizedBox(height: 32),
                  _buildSectionTitle(context, AppLocalizations.of(context)!.intensityTitle, AppLocalizations.of(context)!.intensityExplanation),
                  const SizedBox(height: 16),
                  _buildIntensityChartCard(activities),
                  const SizedBox(height: 32),
                  _buildSectionTitle(context, AppLocalizations.of(context)!.topPositionsTitle, AppLocalizations.of(context)!.topPositionsExplanation),
                  const SizedBox(height: 16),
                  _buildTechniqueCategoriesChartCard(techniques),
                  const SizedBox(height: 32),
                  _buildSectionTitle(context, 'Progreso de las Técnicas', 'Muestra la distribución de tus técnicas por nivel de maestría. Te ayuda a ver cuántas técnicas dominas en cada cinturón.'),
                  const SizedBox(height: 16),
                  _buildBeltProgressChartCard(techniques),
                  const SizedBox(height: 32),
                  _buildSectionTitle(context, AppLocalizations.of(context)!.weeklyConsistencyTitle, AppLocalizations.of(context)!.weeklyConsistencyExplanation),
                  const SizedBox(height: 16),
                  _buildActivityChartCard(activities),
                  const SizedBox(height: 32),
                  _buildSectionTitle(context, 'Estadísticas de Combate', 'Resumen de tus enfrentamientos con rivales registrados.'),
                  const SizedBox(height: 16),
                  _buildRivalsStatsCard(rivals),
                ],
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error loading rivals: $err')),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error loading techniques: $err')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading activities: $err')),
      ),
    );
  }



  Widget _buildSectionTitle(BuildContext context, String title, String explanation) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(explanation),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1565C0),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.info_outline, size: 18, color: Color(0xFF1565C0)),
        ],
      ),
    );
  }

  Widget _buildRadarChartCard(List<Technique> techniques) {
    // Calculate scores based on technique repetitions
    double guardia = 0;
    double pasaje = 0;
    double sumision = 0;
    double defensa = 0;
    double derribos = 0;

    for (var t in techniques) {
      final cat = t.category.toLowerCase();
      final score = t.totalRepetitions.toDouble();
      
      if (cat.contains('guard') || cat.contains('sweep')) guardia += score;
      else if (cat.contains('pass') || cat.contains('pasaje')) pasaje += score;
      else if (cat.contains('subm') || cat.contains('sumis') || cat.contains('choke') || cat.contains('lock')) sumision += score;
      else if (cat.contains('defen') || cat.contains('escap')) defensa += score;
      else if (cat.contains('takedown') || cat.contains('derribo') || cat.contains('throw')) derribos += score;
    }

    // Normalize to max 100 for the chart, but keep relative proportions
    final maxScore = [guardia, pasaje, sumision, defensa, derribos].reduce((a, b) => a > b ? a : b);
    final scale = maxScore > 0 ? 100 / maxScore : 1.0;

    // If no data, show a balanced small chart
    if (maxScore == 0) {
      guardia = 20; pasaje = 20; sumision = 20; defensa = 20; derribos = 20;
    } else {
      guardia *= scale;
      pasaje *= scale;
      sumision *= scale;
      defensa *= scale;
      derribos *= scale;
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1.3,
              child: RadarChart(
                RadarChartData(
                  dataSets: [
                    RadarDataSet(
                      fillColor: const Color(0xFF1565C0).withOpacity(0.2),
                      borderColor: const Color(0xFF1565C0),
                      entryRadius: 3,
                      dataEntries: [
                        RadarEntry(value: guardia),
                        RadarEntry(value: pasaje),
                        RadarEntry(value: sumision),
                        RadarEntry(value: defensa),
                        RadarEntry(value: derribos),
                      ],
                      borderWidth: 2,
                    ),
                  ],
                  radarBackgroundColor: Colors.transparent,
                  borderData: FlBorderData(show: false),
                  radarBorderData: const BorderSide(color: Colors.transparent),
                  titlePositionPercentageOffset: 0.2,
                  titleTextStyle: const TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.bold),
                  getTitle: (index, angle) {
                    switch (index) {
                      case 0:
                        return const RadarChartTitle(text: 'Guardia');
                      case 1:
                        return const RadarChartTitle(text: 'Pasaje');
                      case 2:
                        return const RadarChartTitle(text: 'Sumisión');
                      case 3:
                        return const RadarChartTitle(text: 'Defensa');
                      case 4:
                        return const RadarChartTitle(text: 'Derribos');
                      default:
                        return const RadarChartTitle(text: '');
                    }
                  },
                  tickCount: 1,
                  ticksTextStyle: const TextStyle(color: Colors.transparent),
                  tickBorderData: const BorderSide(color: Colors.transparent),
                  gridBorderData: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                swapAnimationDuration: const Duration(milliseconds: 400),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              maxScore == 0 
                  ? 'Registra técnicas para ver tu estilo' 
                  : 'Basado en tus técnicas aprendidas',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityChartCard(List<Activity> activities) {
    // Calculate activity per day of week (0=Monday, 6=Sunday)
    final Map<int, int> activityCounts = {0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0};
    
    // Filter for current week or just aggregate all time by weekday for demo
    print('DEBUG: Total activities: ${activities.length}');
    for (var activity in activities) {
      // weekday is 1 (Mon) to 7 (Sun), convert to 0-6
      final dayIndex = activity.timestampStart.weekday - 1;
      activityCounts[dayIndex] = (activityCounts[dayIndex] ?? 0) + 1;
    }
    print('DEBUG: Activity Counts: $activityCounts');

    // Find max Y for scaling
    double maxY = 0;
    activityCounts.forEach((_, count) {
      if (count > maxY) maxY = count.toDouble();
    });
    maxY = (maxY + 2).roundToDouble(); // Add some buffer

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: AspectRatio(
          aspectRatio: 1.5,
          child: BarChart(
            BarChartData(
              maxY: maxY,
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => Colors.blueGrey,
                  tooltipHorizontalAlignment: FLHorizontalAlignment.right,
                  tooltipMargin: -10,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    String weekDay;
                    switch (group.x) {
                      case 0: weekDay = 'Lunes'; break;
                      case 1: weekDay = 'Martes'; break;
                      case 2: weekDay = 'Miércoles'; break;
                      case 3: weekDay = 'Jueves'; break;
                      case 4: weekDay = 'Viernes'; break;
                      case 5: weekDay = 'Sábado'; break;
                      case 6: weekDay = 'Domingo'; break;
                      default: throw Error();
                    }
                    return BarTooltipItem(
                      '$weekDay\n',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: (rod.toY).toInt().toString(),
                          style: const TextStyle(
                            color: Colors.yellow,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                touchCallback: (FlTouchEvent event, barTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        barTouchResponse == null ||
                        barTouchResponse.spot == null) {
                      _touchedIndex = -1;
                      return;
                    }
                    _touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
                  });
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      const style = TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      );
                      Widget text;
                      switch (value.toInt()) {
                        case 0: text = const Text('L', style: style); break;
                        case 1: text = const Text('M', style: style); break;
                        case 2: text = const Text('X', style: style); break;
                        case 3: text = const Text('J', style: style); break;
                        case 4: text = const Text('V', style: style); break;
                        case 5: text = const Text('S', style: style); break;
                        case 6: text = const Text('D', style: style); break;
                        default: text = const Text('', style: style); break;
                      }
                      return SideTitleWidget(
                        meta: meta,
                        space: 16,
                        child: text,
                      );
                    },
                    reservedSize: 38,
                  ),
                ),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: [
                _makeGroupData(0, activityCounts[0]!.toDouble(), maxY: maxY, barColor: _getActivityColor(activityCounts[0]!)),
                _makeGroupData(1, activityCounts[1]!.toDouble(), maxY: maxY, barColor: _getActivityColor(activityCounts[1]!)),
                _makeGroupData(2, activityCounts[2]!.toDouble(), maxY: maxY, barColor: _getActivityColor(activityCounts[2]!)),
                _makeGroupData(3, activityCounts[3]!.toDouble(), maxY: maxY, barColor: _getActivityColor(activityCounts[3]!)),
                _makeGroupData(4, activityCounts[4]!.toDouble(), maxY: maxY, barColor: _getActivityColor(activityCounts[4]!)),
                _makeGroupData(5, activityCounts[5]!.toDouble(), maxY: maxY, barColor: _getActivityColor(activityCounts[5]!)),
                _makeGroupData(6, activityCounts[6]!.toDouble(), maxY: maxY, barColor: _getActivityColor(activityCounts[6]!)),
              ],
              gridData: const FlGridData(show: false),
            ),
          ),
        ),
      ),
    );
  }

  BarChartGroupData _makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color? barColor,
    double width = 22,
    List<int> showTooltips = const [],
    required double maxY,
  }) {
    barColor ??= const Color(0xFF1565C0);
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? Colors.yellow : barColor,
          width: width,
          borderSide: isTouched
              ? const BorderSide(color: Colors.yellow)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: maxY,
            color: Colors.grey.shade100,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  Widget _buildGiNoGiChartCard(List<Activity> activities) {
    int giCount = 0;
    int nogiCount = 0;

    for (var a in activities) {
      if (a.type.toLowerCase() == 'gi') giCount++;
      else nogiCount++;
    }

    final total = giCount + nogiCount;
    if (total == 0) return const SizedBox.shrink();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: [
                      PieChartSectionData(
                        color: const Color(0xFF1565C0),
                        value: giCount.toDouble(),
                        title: '${((giCount / total) * 100).toInt()}%',
                        radius: 50,
                        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      PieChartSectionData(
                        color: Colors.orange,
                        value: nogiCount.toDouble(),
                        title: '${((nogiCount / total) * 100).toInt()}%',
                        radius: 50,
                        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLegendItem(const Color(0xFF1565C0), 'Gi ($giCount)'),
                const SizedBox(height: 8),
                _buildLegendItem(Colors.orange, 'NoGi ($nogiCount)'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(width: 16, height: 16, color: color),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildMatTimeChartCard(List<Activity> activities) {
    // Sort activities by date
    final sortedActivities = List<Activity>.from(activities)
      ..sort((a, b) => a.timestampStart.compareTo(b.timestampStart));

    if (sortedActivities.isEmpty) return const SizedBox.shrink();

    // Calculate cumulative hours per date (group by day)
    final Map<DateTime, double> dailyHours = {};
    for (var activity in sortedActivities) {
      final date = DateTime(activity.timestampStart.year, activity.timestampStart.month, activity.timestampStart.day);
      dailyHours[date] = (dailyHours[date] ?? 0) + (activity.durationMinutes / 60.0);
    }

    // Create cumulative hours map
    final sortedDates = dailyHours.keys.toList()..sort();
    List<FlSpot> spots = [];
    double cumulativeHours = 0;
    
    for (int i = 0; i < sortedDates.length; i++) {
      cumulativeHours += dailyHours[sortedDates[i]]!;
      spots.add(FlSpot(i.toDouble(), cumulativeHours));
    }

    // Round up maxY to a nice number
    final maxHours = cumulativeHours;
    final maxY = ((maxHours / 10).ceil() * 10).toDouble() + 5;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1.7,
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: maxY,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: maxY / 5,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.shade200,
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: (sortedDates.length / 4).ceilToDouble(),
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= sortedDates.length) return const SizedBox.shrink();
                          final date = sortedDates[index];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              '${date.month}/${date.year.toString().substring(2)}',
                              style: const TextStyle(color: Colors.grey, fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: maxY / 5,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}h',
                            style: const TextStyle(color: Colors.grey, fontSize: 10),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: const Color(0xFF1565C0),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: const Color(0xFF1565C0).withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Total: ${cumulativeHours.toStringAsFixed(1)} horas',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntensityChartCard(List<Activity> activities) {
    if (activities.isEmpty) return const SizedBox.shrink();

    // Sort by date
    final sortedActivities = List<Activity>.from(activities)
      ..sort((a, b) => a.timestampStart.compareTo(b.timestampStart));

    // Group by week and calculate average RPE + store activities
    final Map<int, List<Activity>> weeklyActivities = {};
    final Map<int, List<double>> weeklyRPE = {};
    final Map<int, DateTime> weekStartDates = {};
    
    for (var activity in sortedActivities) {
      final weekNumber = _getWeekNumber(activity.timestampStart);
      weeklyActivities.putIfAbsent(weekNumber, () => []).add(activity);
      weeklyRPE.putIfAbsent(weekNumber, () => []).add(activity.rpe.toDouble());
      
      // Store the earliest date for this week if not already stored
      if (!weekStartDates.containsKey(weekNumber) || activity.timestampStart.isBefore(weekStartDates[weekNumber]!)) {
        weekStartDates[weekNumber] = activity.timestampStart;
      }
    }

    // Calculate average RPE per week
    final allWeeks = weeklyRPE.keys.toList()..sort();
    
    // Show only last 8 weeks to avoid saturation
    final weeks = allWeeks.length > 8 ? allWeeks.sublist(allWeeks.length - 8) : allWeeks;
    final maxY = 10.0;

    int touchedIndex = -1;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1.7,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceEvenly,
                  maxY: maxY,
                  minY: 0,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchCallback: (FlTouchEvent event, barTouchResponse) {
                      if (event is FlTapUpEvent && barTouchResponse?.spot != null) {
                        final index = barTouchResponse!.spot!.touchedBarGroupIndex;
                        final weekNumber = weeks[index];
                        final sessionsInWeek = weeklyActivities[weekNumber] ?? [];
                        
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Semana ${weekStartDates[weekNumber]!.day}/${weekStartDates[weekNumber]!.month}'),
                            content: SizedBox(
                              width: double.maxFinite,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ...sessionsInWeek.map((activity) {
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                color: _getRpeColor(activity.rpe.toDouble()),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                '${activity.timestampStart.day}/${activity.timestampStart.month} - ${activity.type.toUpperCase()}',
                                                style: const TextStyle(fontSize: 13),
                                              ),
                                            ),
                                            Text(
                                              'RPE: ${activity.rpe}',
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Cerrar'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 2,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.shade200,
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: (weeks.length / 2).ceilToDouble().clamp(1, double.infinity),
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= weeks.length) return const SizedBox.shrink();
                          final weekNumber = weeks[index];
                          final date = weekStartDates[weekNumber];
                          if (date == null) return const SizedBox.shrink();
                          
                          return SideTitleWidget(
                            meta: meta,
                            space: 8,
                            child: Text(
                              '${date.day}/${date.month}',
                              style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 2,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(color: Colors.grey, fontSize: 10),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(weeks.length, (index) {
                    final avgRPE = weeklyRPE[weeks[index]]!.reduce((a, b) => a + b) / weeklyRPE[weeks[index]]!.length;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: avgRPE,
                          color: _getRpeColor(avgRPE),
                          width: 16,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(6),
                            topRight: Radius.circular(6),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _buildRPELegend(Colors.green, 'Suave (1-3)'),
                _buildRPELegend(Colors.orange, 'Moderado (4-6)'),
                _buildRPELegend(Colors.red, 'Intenso (7-10)'),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Toca una barra para ver las sesiones',
              style: TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRPELegend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  int _getWeekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
    return (daysSinceFirstDay / 7).floor();
  }

  Color _getRpeColor(double rpe) {
    if (rpe < 4) return Colors.green;
    if (rpe < 7) return Colors.orange;
    return Colors.red;
  }

  Color _getFrequencyColor(double percentage) {
    if (percentage < 0.33) return Colors.green;
    if (percentage < 0.66) return Colors.orange;
    return Colors.red;
  }

  Color _getActivityColor(int count) {
    if (count <= 1) return Colors.green;
    if (count == 2) return Colors.orange;
    return Colors.red;
  }

  Widget _buildTechniqueCategoriesChartCard(List<Technique> techniques) {
    if (techniques.isEmpty) return const SizedBox.shrink();

    // Count techniques per category
    final Map<String, int> categoryCounts = {};
    for (var t in techniques) {
      final category = t.category;
      categoryCounts[category] = (categoryCounts[category] ?? 0) + 1;
    }

    // Sort by count descending
    final sortedCategories = categoryCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: sortedCategories.map((entry) {
            final maxCount = sortedCategories.first.value;
            final percentage = entry.value / maxCount;
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      entry.key,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: percentage,
                          child: Container(
                            height: 12,
                            decoration: BoxDecoration(
                              color: _getFrequencyColor(percentage),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${entry.value}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildBeltProgressChartCard(List<Technique> techniques) {
    if (techniques.isEmpty) return const SizedBox.shrink();

    // Count techniques per belt level
    final Map<String, int> beltCounts = {
      'White': 0,
      'Blue': 0,
      'Purple': 0,
      'Brown': 0,
      'Black': 0,
    };

    for (var t in techniques) {
      final beltName = t.masteryBelt.name;
      final displayName = beltName[0].toUpperCase() + beltName.substring(1);
      beltCounts[displayName] = (beltCounts[displayName] ?? 0) + 1;
    }

    // Remove belts with 0 count
    beltCounts.removeWhere((key, value) => value == 0);

    if (beltCounts.isEmpty) return const SizedBox.shrink();

    final total = beltCounts.values.reduce((a, b) => a + b);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    sections: beltCounts.entries.map((entry) {
                      return PieChartSectionData(
                        color: _getBeltColor(entry.key),
                        value: entry.value.toDouble(),
                        title: '${((entry.value / total) * 100).toInt()}%',
                        radius: 50,
                        titleStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: entry.key == 'White' ? Colors.black : Colors.white,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: beltCounts.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: _getBeltColor(entry.key),
                          borderRadius: BorderRadius.circular(2),
                          border: entry.key == 'White' ? Border.all(color: Colors.grey) : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${entry.key} (${entry.value})',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Color _getBeltColor(String beltName) {
    switch (beltName) {
      case 'White':
        return Colors.white;
      case 'Blue':
        return Colors.blue[800]!;
      case 'Purple':
        return Colors.purple[800]!;
      case 'Brown':
        return Colors.brown[800]!;
      case 'Black':
        return Colors.black;
      default:
        return Colors.grey;
    }
  }

  Widget _buildRivalsStatsCard(List<Rival> rivals) {
    if (rivals.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: Text('No hay datos de rivales aún')),
        ),
      );
    }

    Rival? mostFrequent;
    Rival? nemesis;
    Rival? customer;

    int maxMatches = 0;
    int maxLosses = 0;
    int maxWins = 0;

    for (var r in rivals) {
      final totalMatches = r.wins + r.losses + r.draws;
      if (totalMatches > maxMatches) {
        maxMatches = totalMatches;
        mostFrequent = r;
      }

      if (r.losses > maxLosses) { // My losses against them
        maxLosses = r.losses;
        nemesis = r;
      }

      if (r.wins > maxWins) { // My wins against them
        maxWins = r.wins;
        customer = r;
      }
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildStatRow(
              'Mayor Rival', 
              mostFrequent?.rivalName ?? '-', 
              '${mostFrequent?.wins ?? 0}W - ${mostFrequent?.losses ?? 0}L - ${mostFrequent?.draws ?? 0}D',
              Icons.people,
              Colors.blue,
            ),
            const Divider(),
            _buildStatRow(
              'Tu Némesis', 
              nemesis?.rivalName ?? '-', 
              'Has perdido ${nemesis?.losses ?? 0} veces',
              Icons.warning_amber_rounded,
              Colors.red,
            ),
            const Divider(),
            _buildStatRow(
              'Tu Cliente', 
              customer?.rivalName ?? '-', 
              'Has ganado ${customer?.wins ?? 0} veces',
              Icons.check_circle_outline,
              Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String title, String name, String subtitle, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(subtitle, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
