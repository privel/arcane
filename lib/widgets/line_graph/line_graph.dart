import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineGraph extends StatelessWidget {
  const LineGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minY: 0, // Минимальное значение по оси Y
        gridData: FlGridData(
          show: true, 
          drawVerticalLine: true,
          drawHorizontalLine: false,
          

        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                const months = [
                  'Jan',
                  'Feb',
                  'Mar',
                  'Apr',
                  'May',
                  'Jun',
                  'Jul',
                  'Aug',
                  'Sep',
                  'Oct',
                  'Nov',
                  'Dec'
                ];
                if (value.toInt() >= 0 && value.toInt() < months.length) {
                  return Text(
                    months[value.toInt()],
                    style: const TextStyle(fontSize: 12),
                  );
                }
                return const SizedBox();
              },
              interval: 1,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),

          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: true,
           // Убираем границы
        ),
        lineBarsData: [
          LineChartBarData(
            isCurved: true, // Гладкие линии
            color: Colors.blue, // Цвет линии
            barWidth: 3,
            dotData: FlDotData(show: false), // Без точек на графике
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withOpacity(0.3),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            spots: [
              FlSpot(0, 5),
              FlSpot(1, 8),
              FlSpot(2, 6),
              FlSpot(3, 3),
              FlSpot(4, 4),
              FlSpot(5, 7),
              FlSpot(6, 6),
              FlSpot(7, 5),
              FlSpot(8, 6),
              FlSpot(9, 3),
              FlSpot(10, 7),
              FlSpot(11, 9),
            ],
          ),
        ],
      ),
    );
  }
}