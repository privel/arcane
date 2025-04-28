import 'package:arcane/widgets/line_graph/line_graph.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';
import 'package:responsive_framework/responsive_framework.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;

    TextEditingController day = TextEditingController();
    TextEditingController month = TextEditingController();
    TextEditingController year = TextEditingController();

    @override
    void dispose() {
      // Clean up the controller when the widget is disposed.
      day.dispose();
      month.dispose();
      year.dispose();
      //super :)
      super.dispose();
    }

    void calculate_fl_chart() {
      if (day.text.isEmpty || month.text.isEmpty || year.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Пожалуйста, заполните все поля')),
        );
        return;
      }

      final int? dayInt = int.tryParse(day.text.trimLeft());
      final int? monthInt = int.tryParse(month.text.trimLeft());
      final int? yearInt = int.tryParse(year.text.trimLeft());

      if (dayInt == null || monthInt == null || yearInt == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Введите правильные числовые значения')),
        );
        return;
      }

      if (dayInt < 1 ||
          dayInt > 31 ||
          monthInt < 1 ||
          monthInt > 12 ||
          yearInt < 1000 ||
          yearInt > 3000) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Введите корректные дату, месяц и год')),
        );
        return;
      }

      // Перемножение дня, месяца и года
      int result = dayInt * monthInt * yearInt;

      String resultStr = result.toString();

      // Если число меньше 7 знаков — добавляем его начальные цифры к концу, пока не будет 7 знаков
      while (resultStr.length < 7) {
        resultStr += resultStr.substring(0, 1);
      }
      resultStr = resultStr.substring(0, 7); // точно обрезаем до 7 символов

      print('Итоговый семизначный код: $resultStr');

      // Теперь подготовка данных для графика
      int birthYear = yearInt;
      List<Map<String, dynamic>> graphData = [];

      for (int i = 0; i < 7; i++) {
        int year = birthYear + i;
        int yValue = int.parse(resultStr[i]);
        graphData.add({'year': year, 'value': yValue});
      }

      // Просто вывод для проверки
      for (var point in graphData) {
        print('Год: ${point['year']} — Значение: ${point['value']}');
      }

      // Теперь Вы можете использовать `graphData` для построения графика через fl_chart
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 30.0, top: 20.0, right: 30.0),
        child: Column(
          children: [
            // Заголовок и кнопка выбора даты
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "График жизни",
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600,
                    fontSize: 28,
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(IconlyLight.calendar),
                    label: const Text(
                      "Выбрать дату",
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Адаптивный контейнер
            if (isMobile) ...[
              Column(
                children: [
                  Container(
                    height: 250,
                    width: double.infinity,
                    color: Colors.blue[100],
                    child:
                        const Center(child: Text("Правый виджет (мобильный)")),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 250,
                    width: double.infinity,
                    color: Colors.green[100],
                    child:
                        const Center(child: Text("Левый виджет (мобильный)")),
                  ),
                ],
              ),
            ] else if (isTablet) ...[
              Column(
                children: [
                  Container(
                    height: 350,
                    width: double.infinity,
                    color: Colors.blue[100],
                    child: const Center(child: Text("Правый виджет (планшет)")),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    height: 350,
                    width: double.infinity,
                    color: Colors.green[100],
                    child: const Center(child: Text("Левый виджет (планшет)")),
                  ),
                ],
              ),
            ] else ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: 600,
                      color: Colors.green[100],
                      child: LineGraph(),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 500,
                      decoration: BoxDecoration(
                        border: Border.all(
                            // ignore: deprecated_member_use
                            color: Colors.grey.withOpacity(0.3),
                            width: 2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Выбор даты",
                              style: TextStyle(
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w400,
                                fontSize: 24,
                              ),
                            ),
                            const SizedBox(
                              height: 60,
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 13),
                              child: TextField(
                                controller: day,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(
                                      2), // <-- Ограничение на 2 символа
                                  FilteringTextInputFormatter
                                      .digitsOnly, // <-- Разрешаем только цифры
                                ],
                                decoration: InputDecoration(
                                  // filled: true,
                                  // fillColor: Colors.grey[200],
                                  // hintText: "Введите день",
                                  labelText:
                                      "Введите день", // <-- добавляем labelText
                                  labelStyle:
                                      const TextStyle(color: Colors.grey),

                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: Colors.black12, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFb31217), width: 1.5),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 13),
                              child: TextField(
                                controller: month,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(
                                      2), // <-- Ограничение на 2 символа
                                  FilteringTextInputFormatter
                                      .digitsOnly, // <-- Разрешаем только цифры
                                ],
                                decoration: InputDecoration(
                                  // filled: true,
                                  // fillColor: Colors.grey[200],
                                  // hintText: "Введите месяц",
                                  labelText:
                                      "Введите месяц", // <-- добавляем labelText
                                  labelStyle:
                                      const TextStyle(color: Colors.grey),
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: Colors.black12, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFb31217), width: 1.5),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 13),
                              child: TextField(
                                controller: year,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(
                                      4), // <-- Ограничение на 2 символа
                                  FilteringTextInputFormatter
                                      .digitsOnly, // <-- Разрешаем только цифры
                                ],
                                decoration: InputDecoration(
                                  // filled: true,
                                  // fillColor: Colors.grey[200],
                                  // hintText: "Введите год",
                                  labelText:
                                      "Введите год", // <-- добавляем labelText
                                  labelStyle:
                                      const TextStyle(color: Colors.grey),
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),

                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: Colors.black12, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFb31217), width: 1.5),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 50),
                            Center(
                              child: SizedBox(
                                width: 275,
                                height: 45,
                                child: ElevatedButton.icon(
                                  onPressed: calculate_fl_chart,
                                  icon: const Icon(IconlyLight.calendar),
                                  label: const Text("Рассчитать график"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}




/* final TextEditingController _dayController = TextEditingController(text: "12");
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
  } */