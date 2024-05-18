import 'package:abhibhut_v2/DataObjects/AppData.dart';
import 'package:abhibhut_v2/DataObjects/AppUsage.dart';
import 'package:abhibhut_v2/DataObjects/UsageStats.dart';
import 'package:abhibhut_v2/Screens/Home_Screen.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BargraphWidget extends StatefulWidget {
  String tenure;
  List<AppUsage> BarGrpupList;

  BargraphWidget({super.key, required this.tenure, required this.BarGrpupList});

  @override
  State<BargraphWidget> createState() => _BargraphWidgetState();
}

class _BargraphWidgetState extends State<BargraphWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SizedBox(
            child: BarChart(BarChartData(
                /* if the duration is more than an hour for any app , then the graph will show data in hours , else in minutes */
                maxY: widget.BarGrpupList[0].duration! >= 60
                    ? widget.BarGrpupList[0].duration! + 1
                    : widget.BarGrpupList[0].duration! + 5,
                minY: 0,
                barGroups: List.generate(
                    widget.BarGrpupList.length,
                    (index) => BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: widget.BarGrpupList[index].duration!
                                  .toDouble(),
                              color: Colors.blue[200],
                              width: 20,
                            ),
                          ],
                          showingTooltipIndicators: [0],
                        )),
                /*titlesData: FlTitlesData(
                   bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                  showTitles: true,
                  : (value, meta) {
                    return widget.BarGrpupList[value.toInt()].app_icon!
                        as Widget;
                  },
                )))*/
                titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        var imageData =
                            widget.BarGrpupList[value.toInt()].app_icon!;
                        return Image(image: MemoryImage(imageData));
                      },
                    )),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    show: true)))));
  }
}
