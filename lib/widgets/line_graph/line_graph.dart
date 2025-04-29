import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineGraph extends StatelessWidget {
  final DateTime birthDate;

  const LineGraph({super.key, required this.birthDate});

  List<int> calculateLifeCode(DateTime birthDate) {
    int day = birthDate.day;
    int month = birthDate.month;
    int year = birthDate.year;
    int product = day * month * year;
    String productStr = product.toString();

    while (productStr.length < 7) {
      productStr += productStr.substring(0, (7 - productStr.length));
    }

    return productStr.split('').map((e) => int.parse(e)).toList();
  }

  List<FlSpot> generateSpots(DateTime birthDate) {
    final code = calculateLifeCode(birthDate);
    final List<FlSpot> spots = [];

    for (int i = 0; i < 7; i++) {
      spots.add(FlSpot(i.toDouble(), code[i].toDouble()));
    }

    return spots;
  }

  List<String> generateYears(DateTime birthDate) {
    final int startYear = birthDate.year;
    return List.generate(105, (index) => "${startYear + index} г.");
  }

  @override
  Widget build(BuildContext context) {
    final spots = generateSpots(birthDate);
    final years = generateYears(birthDate);

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 9,
        minX: 0,
        maxX: 6,
        gridData: const FlGridData(
          show: true,
          drawVerticalLine: true,
          drawHorizontalLine: false,
          verticalInterval: 1,
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                int year = birthDate.year + value.toInt();
                return Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    year.toString(),
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() <= 9) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 10),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(color: Colors.black12),
            left: BorderSide(color: Colors.black12),
            right: BorderSide(color: Colors.black12),
            top: BorderSide(color: Colors.black12),
          ),
        ),
        
        lineBarsData: [
          LineChartBarData(
            
            isCurved: true,
            // preventCurveOverShooting: true,

                    color: Colors.red,
                    barWidth: 3,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          Colors.red.withOpacity(0.3),
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
          
            // color: Colors.orange,
            // barWidth: 2,
            // dotData: FlDotData(show: true),
            spots: spots,
          ),
        ],

        
      ),
    );
  }
}


/*const SizedBox(height: 20),

        SizedBox(
          height: 300, // ограничиваем высоту сетки годов
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(), // чтобы не скроллилась отдельно
            padding: const EdgeInsets.symmetric(horizontal: 10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7, // 7 колонок
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2.5, // компактность клеток
            ),
            itemCount: years.length,
            itemBuilder: (context, index) {
              return Center(
                child: Text(
                  years[index],
                  style: const TextStyle(fontSize: 10),
                ),
              );
            },
          ),
        ), */





// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';

// class LineGraph extends StatelessWidget {
//   final DateTime birthDate;

//   const LineGraph({super.key, required this.birthDate});

//   List<int> calculateLifeCode(DateTime birthDate) {
//     int day = birthDate.day;
//     int month = birthDate.month;
//     int year = birthDate.year;
//     int product = day * month * year;
//     String productStr = product.toString();

//     while (productStr.length < 7) {
//       productStr += productStr.substring(0, (7 - productStr.length));
//     }

//     return productStr.split('').map((e) => int.parse(e)).toList();
//   }

//   List<FlSpot> generateSpots(DateTime birthDate) {
//     final code = calculateLifeCode(birthDate);
//     final List<FlSpot> spots = [];

//     for (int i = 0; i < 7; i++) {
//       spots.add(FlSpot(i.toDouble(), code[i].toDouble()));
//     }

//     return spots;
//   }

//   List<String> generateYears(DateTime birthDate) {
//     final int startYear = birthDate.year;
//     return List.generate(
//         105, (index) => "${startYear + index} г."); // 7x15 = 105 лет
//   }

//   @override
//   Widget build(BuildContext context) {
//     final spots = generateSpots(birthDate);
//     final years = generateYears(birthDate);

//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           // График с ограничением по высоте
//           SizedBox(
//             height: 400,
//             child: LineChart(
//               LineChartData(
//                 minY: 0,
//                 maxY: 9,
//                 minX: 0,
//                 maxX: 6,
//                 gridData: const FlGridData(
//                   show: true,
//                   drawVerticalLine: true,
//                   drawHorizontalLine: false,
//                   verticalInterval: 1,
//                 ),
//                 titlesData: FlTitlesData(
//                   bottomTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       reservedSize: 30,
//                       interval: 1,
//                       getTitlesWidget: (value, meta) {
//                         int year = birthDate.year + value.toInt();
//                         return Padding(
//                           padding: const EdgeInsets.only(top: 4.0),
//                           child: Text(
//                             year.toString(),
//                             style: const TextStyle(fontSize: 10),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   leftTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       interval: 1,
//                       getTitlesWidget: (value, meta) {
//                         if (value.toInt() >= 0 && value.toInt() <= 9) {
//                           return Text(
//                             value.toInt().toString(),
//                             style: const TextStyle(fontSize: 10),
//                           );
//                         } else {
//                           return const SizedBox.shrink();
//                         }
//                       },
//                     ),
//                   ),
//                   topTitles: AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                   rightTitles: AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                 ),
//                 borderData: FlBorderData(
//                   show: true,
//                   border: const Border(
//                     bottom: BorderSide(color: Colors.black),
//                     left: BorderSide(color: Colors.black),
//                   ),
//                 ),
//                 lineBarsData: [
//                   LineChartBarData(
//                     isCurved: false,
//                     color: Colors.blue,
//                     barWidth: 3,
//                     dotData: FlDotData(show: false),
//                     belowBarData: BarAreaData(
//                       show: true,
//                       gradient: LinearGradient(
//                         colors: [
//                           Colors.blue.withOpacity(0.3),
//                           Colors.transparent,
//                         ],
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                       ),
//                     ),
//                     spots: spots,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//           // Сетка годов под графиком
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 0),
//             child: GridView.builder(
//               shrinkWrap: true,
//               physics:
//                   const NeverScrollableScrollPhysics(), // чтобы сетка не скроллилась отдельно
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 7, // 7 колонок
//                 mainAxisSpacing: 6, // между строками
//                 crossAxisSpacing: 6, // между колонками
//                 childAspectRatio: 1, // пропорция ширина/высота (идеально для такого текста)
//               ),
//               itemCount: years.length,
//               itemBuilder: (context, index) {
//                 return Center(
//                   child: Text(
//                     years[index],
//                     style: const TextStyle(fontSize: 10),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }