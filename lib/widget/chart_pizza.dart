import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartPizza extends StatelessWidget {
  List<PieChartSectionData> showingSections;

  ChartPizza(this.showingSections);

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {}),
        borderData: FlBorderData(
          show: false,
        ),
        sectionsSpace: 0,
        centerSpaceRadius: 50,
        sections: showingSections,
      ),
    );
  }
}
