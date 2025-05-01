import 'package:arcane/services/providers/line_graph_provider.dart';
import 'package:arcane/widgets/line_graph/line_graph.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

class CalcLifeGraph extends StatefulWidget {
  const CalcLifeGraph({super.key});

  @override
  State<CalcLifeGraph> createState() => _CalcLifeGraphState();
}

class _CalcLifeGraphState extends State<CalcLifeGraph> {
  List<String> generateYears(DateTime birthDate) {
    final int startYear = birthDate.year;
    return List.generate(105, (index) => "${startYear + index} г.");
  }

  @override
  Widget build(BuildContext context) {
    final providerGraph = Provider.of<LifeChartProvider>(context);
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (isDesktop) {
          return DesktopWidgets(
            providerGraph: providerGraph,
            generateYears: generateYears,
          );
        } else if (isMobile) {
          return MobileWidgets(
            providerGraph: providerGraph,
            generateYears: generateYears,
          );
        } else {
          return TabletWidgets(
            providerGraph: providerGraph,
            generateYears: generateYears,
          );
        }
      },
    );
  }
}

class DesktopWidgets extends StatelessWidget {
  final LifeChartProvider providerGraph;
  final List<String> Function(DateTime) generateYears;

  const DesktopWidgets(
      {super.key, required this.generateYears, required this.providerGraph});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 30.0, top: 20.0, right: 30.0, bottom: 1000),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SelectableText(
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  height: 900,
                  decoration: BoxDecoration(
                    border: Border.all(
                        // ignore: deprecated_member_use
                        color: Colors.grey.withOpacity(0.3),
                        width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: providerGraph.isGraphVisible &&
                          providerGraph.selectedDate != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 30, horizontal: 30),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 800,
                                child: LineGraph(
                                    birthDate: providerGraph.selectedDate!),
                              ),
                            ],
                          ),
                        )
                      : const Center(
                          child: Text(
                            'Введите дату рождения и нажмите "Рассчитать график"',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
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
                            onChanged: providerGraph.setDay,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(2),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              // filled: true,
                              // fillColor: Colors.grey[200],
                              // hintText: "Введите день",
                              labelText:
                                  "Введите день", // <-- добавляем labelText
                              labelStyle: const TextStyle(color: Colors.grey),

                              hintStyle: const TextStyle(color: Colors.grey),
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
                            onChanged: providerGraph.setMonth,
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
                              labelStyle: const TextStyle(color: Colors.grey),
                              hintStyle: const TextStyle(color: Colors.grey),
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
                            onChanged: providerGraph.setYear,
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
                              labelStyle: const TextStyle(color: Colors.grey),
                              hintStyle: const TextStyle(color: Colors.grey),

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
                              onPressed: () =>
                                  providerGraph.calculateFlChart(context),
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
      ),
    );
  }
}

class MobileWidgets extends StatelessWidget {
  final LifeChartProvider providerGraph;
  final List<String> Function(DateTime) generateYears;
  const MobileWidgets({
    super.key,
    required this.providerGraph,
    required this.generateYears,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 20.0, top: 20.0, right: 20.0, bottom: 1000),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText(
                "График жизни",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w600,
                  fontSize: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Column(
            children: [
              Container(
                height: 450,
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
                        height: 30,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 13),
                        child: TextField(
                          onChanged: providerGraph.setDay,
                          keyboardType: TextInputType.number,
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
                            labelStyle: const TextStyle(color: Colors.grey),

                            hintStyle: const TextStyle(color: Colors.grey),
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
                          onChanged: providerGraph.setMonth,
                          keyboardType: TextInputType.number,
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
                            labelStyle: const TextStyle(color: Colors.grey),
                            hintStyle: const TextStyle(color: Colors.grey),
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
                          onChanged: providerGraph.setYear,
                          keyboardType: TextInputType.number,
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
                            labelText: "Введите год", // <-- добавляем labelText
                            labelStyle: const TextStyle(color: Colors.grey),
                            hintStyle: const TextStyle(color: Colors.grey),

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
                            onPressed: () =>
                                providerGraph.calculateFlChart(context),
                            icon: const Icon(IconlyLight.calendar),
                            label: const Text("Рассчитать график"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 550,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                      // ignore: deprecated_member_use
                      color: Colors.grey.withOpacity(0.3),
                      width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: providerGraph.isGraphVisible &&
                        providerGraph.selectedDate != null
                    ? Padding(
                        padding: EdgeInsets.only(
                          top: 30,
                          left: MediaQuery.of(context).size.width * 0.03,
                          right: MediaQuery.of(context).size.width * 0.055,
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 500,
                              child: LineGraph(
                                  birthDate: providerGraph.selectedDate!),
                            ),
                          ],
                        ),
                      )
                    : const Center(
                        child: Text(
                          'Введите дату рождения и нажмите "Рассчитать график"',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TabletWidgets extends StatelessWidget {
  final LifeChartProvider providerGraph;
  final List<String> Function(DateTime) generateYears;
  const TabletWidgets({
    super.key,
    required this.providerGraph,
    required this.generateYears,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 30.0, top: 20.0, right: 30.0, bottom: 1000),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText(
                "График жизни",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w600,
                  fontSize: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 300,
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
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 13,
                                ),
                                child: TextField(
                                  onChanged: providerGraph.setDay,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(2),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration:
                                      _buildInputDecoration("Введите день"),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 13),
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  onChanged: providerGraph.setMonth,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(2),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration:
                                      _buildInputDecoration("Введите месяц"),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 13),
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  onChanged: providerGraph.setYear,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(4),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration:
                                      _buildInputDecoration("Введите год"),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: SizedBox(
                            width: 200,
                            height: 45,
                            child: ElevatedButton.icon(
                              onPressed: () =>
                                  providerGraph.calculateFlChart(context),
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
          const SizedBox(height: 40),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  height: 870,
                  decoration: BoxDecoration(
                    border: Border.all(
                        // ignore: deprecated_member_use
                        color: Colors.grey.withOpacity(0.3),
                        width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: providerGraph.isGraphVisible &&
                          providerGraph.selectedDate != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 30, horizontal: 30),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 800,
                                child: LineGraph(
                                    birthDate: providerGraph.selectedDate!),
                              ),
                            ],
                          ),
                        )
                      : const Center(
                          child: Text(
                            'Введите дату рождения и нажмите "Рассчитать график"',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      // filled: true,
      // fillColor: Colors.grey[200],
      // hintText: label,
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      hintStyle: const TextStyle(color: Colors.grey),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.black12, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFb31217), width: 1.5),
      ),
    );
  }
}
