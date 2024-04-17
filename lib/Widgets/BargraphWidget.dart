import 'package:abhibhut_v2/DataObjects/AppData.dart';
import 'package:abhibhut_v2/DataObjects/UsageStats.dart';
import 'package:abhibhut_v2/Screens/Home_Screen.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BargraphWidget extends StatefulWidget {

  BargraphWidget(tenure);

  @override
  State<BargraphWidget> createState() => _BargraphWidgetState();
}

class _BargraphWidgetState extends State<BargraphWidget> {

  @override
  void initState() {
    super.initState();
  }

  void load_usage_stats() async
  {
      List<UsageStats> stats = await UsageStats().load_usage_stats(tenure);
      List.generate(stats.length, (index) => BarChartRodData(toY: stats[index].))
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BarChart(BarChartData(
          maxY: widget.maxY.toDouble() + 1,
          minY: 0.0, 
          barGroups: ,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                    return SideTitleWidget(child: AppData.getIcon(), axisSide: axisSide)
                },
              )
            )
          )
          )
          ),
    );
  }
}
