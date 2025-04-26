import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _dayController = TextEditingController(text: "12");
  final TextEditingController _monthController = TextEditingController(text: "12");
  final TextEditingController _yearController = TextEditingController(text: "2000");

  List<FlSpot> spots = [];

  @override
  void initState() {
    super.initState();
    generateLifeGraph();
  }

  void generateLifeGraph() {
    int birthDay = int.tryParse(_dayController.text) ?? 1;
    int birthMonth = int.tryParse(_monthController.text) ?? 1;
    int birthYear = int.tryParse(_yearController.text) ?? 2000;

    int result = birthDay * birthMonth * birthYear;
    String resultStr = result.toString();

    while (resultStr.length < 7) {
      resultStr += resultStr.substring(0, 7 - resultStr.length);
    }

    List<FlSpot> generatedSpots = [];
    for (int i = 0; i < 7; i++) {
      double year = birthYear + i.toDouble();
      double value = double.parse(resultStr[i]);
      generatedSpots.add(FlSpot(year, value));
    }

    setState(() {
      spots = generatedSpots;
    });
  }

  void resetFields() {
    _dayController.text = "12";
    _monthController.text = "12";
    _yearController.text = "2000";
    generateLifeGraph();
  }

  @override
  Widget build(BuildContext context) {
    List<int> years = List.generate(100, (index) => (spots.isNotEmpty ? spots.first.x.toInt() : 2000) + index);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Поля для ввода
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Row(
                children: [
                  _buildTextField(_dayController, 'День'),
                  const SizedBox(width: 8),
                  _buildTextField(_monthController, 'Месяц'),
                  const SizedBox(width: 8),
                  _buildTextField(_yearController, 'Год'),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: generateLifeGraph,
                    child: const Text('Построить график'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: resetFields,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Сброс'),
                  ),
                ],
              ),
            ),
            // График
            SizedBox(
              height: 250,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: LineChart(
                  LineChartData(
                    backgroundColor: Colors.grey[800],
                    minX: spots.isNotEmpty ? spots.first.x : 2000,
                    maxX: spots.isNotEmpty ? spots.last.x : 2006,
                    minY: 0,
                    maxY: 9,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      drawHorizontalLine: true,
                      horizontalInterval: 1,
                      verticalInterval: 1,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: Colors.grey.shade500,
                        strokeWidth: 1,
                      ),
                      getDrawingVerticalLine: (value) => FlLine(
                        color: Colors.grey.shade500,
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) => Text(
                            value.toInt().toString(),
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, meta) => Text(
                            value.toInt().toString() + ' г.',
                            style: const TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.orange, width: 2),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: false, // как на картинке: угловатая линия
                        spots: spots,
                        barWidth: 3,
                        color: Colors.orange,
                        belowBarData: BarAreaData(show: false),
                        dotData: FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Сетка с годами
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // 4 года в строке
                    childAspectRatio: 3,
                  ),
                  itemCount: years.length,
                  itemBuilder: (context, index) {
                    return Center(
                      child: Text(
                        '${years[index]} г.',
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return SizedBox(
      width: 70,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }
}
