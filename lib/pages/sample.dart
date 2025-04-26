import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LifeGraphPage extends StatefulWidget {
  const LifeGraphPage({super.key});

  @override
  State<LifeGraphPage> createState() => _LifeGraphPageState();
}

class _LifeGraphPageState extends State<LifeGraphPage> {
  final TextEditingController _dayController = TextEditingController(text: '15');
  final TextEditingController _monthController = TextEditingController(text: '12');
  final TextEditingController _yearController = TextEditingController(text: '2000');

  List<FlSpot> _graphData = [];

  void _generateGraph() {
    int day = int.tryParse(_dayController.text) ?? 1;
    int month = int.tryParse(_monthController.text) ?? 1;
    int year = int.tryParse(_yearController.text) ?? 2000;

    int value = day * month * year;
    String code = value.toString();

    while (code.length < 7) {
      code += code.substring(0, 7 - code.length);
    }

    List<FlSpot> spots = [];
    for (int i = 0; i < 7; i++) {
      double x = year + i.toDouble();
      double y = double.parse(code[i]);
      spots.add(FlSpot(x, y));
    }

    // Повторяем каждые 7 лет до 2100 года
    List<FlSpot> allSpots = [];
    for (int cycle = 0; year + cycle * 7 <= 2100; cycle++) {
      for (int i = 0; i < spots.length; i++) {
        allSpots.add(FlSpot(spots[i].x + cycle * 7, spots[i].y));
      }
    }

    setState(() => _graphData = allSpots);
  }

  void _resetGraph() {
    _dayController.clear();
    _monthController.clear();
    _yearController.clear();
    setState(() => _graphData = []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(title: const Text('График Жизни')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                _buildInputField('День', _dayController),
                const SizedBox(width: 8),
                _buildInputField('Месяц', _monthController),
                const SizedBox(width: 8),
                _buildInputField('Год', _yearController),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _generateGraph,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[600],
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Построить график'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: _resetGraph,
                  child: const Text('Сброс', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _graphData.isEmpty
                  ? const Center(child: Text('Введите дату рождения и нажмите "Построить график"', style: TextStyle(color: Colors.white70)))
                  : LineChart(
                      LineChartData(
                        minY: 0,
                        maxY: 9,
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true, interval: 1),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                if (value % 1 != 0 || value < _graphData.first.x || value > _graphData.last.x) return const SizedBox.shrink();
                                return Text('${value.toInt()} г.',
                                    style: const TextStyle(fontSize: 8, color: Colors.white), textAlign: TextAlign.center);
                              },
                            ),
                          ),
                        ),
                        gridData: FlGridData(show: true),
                        borderData: FlBorderData(show: true),
                        lineBarsData: [
                          LineChartBarData(
                            spots: _graphData,
                            isCurved: false,
                            color: Colors.orange,
                            barWidth: 2,
                            dotData: FlDotData(show: true),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return SizedBox(
      width: 80,
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.grey[800],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
