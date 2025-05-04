import 'package:arcane/services/config/config_life_graph.dart';
import 'package:arcane/services/providers/line_graph_provider.dart';
import 'package:arcane/widgets/line_graph/line_graph.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

class GraphLife extends StatelessWidget {
  const GraphLife({super.key});

  List<String> generateYears(DateTime birthDate) {
    final int startYear = birthDate.year;
    return List.generate(105, (index) => "${startYear + index} г.");
  }

  @override
  Widget build(BuildContext context) {
    final providerGraph = Provider.of<LifeChartProvider>(context);
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final config = ConfigLifeGraph(isMobile, isTablet);

    /*
    Padding(
                        padding: EdgeInsets.only(
                          top: 30,
                          left: MediaQuery.of(context).size.width * 0.03,
                          right: MediaQuery.of(context).size.width * 0.055,
                        ),*/

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 25,
        horizontal: 15,
      ),
      child: Column(
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
          const SizedBox(height: 30),
          ResponsiveRowColumn(
            layout: isMobile || isTablet
                ? ResponsiveRowColumnType.COLUMN
                : ResponsiveRowColumnType.ROW,
            rowMainAxisAlignment: MainAxisAlignment.start,
            columnCrossAxisAlignment: CrossAxisAlignment.start,
            rowCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResponsiveRowColumnItem(
                rowFlex: 3,
                columnOrder: config.columnOrderResponsiveGraph,
                child: Container(
                  padding: isTablet
                      ? const EdgeInsets.only(
                          top: 30,
                        )
                      : null,
                  margin: const EdgeInsets.only(
                    bottom: 20,
                  ),
                  height: config.sizeContainerGraph,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey.withOpacity(0.3), width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: providerGraph.isGraphVisible &&
                          providerGraph.selectedDate != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 30, horizontal: 30),
                          child: SizedBox(
                            height: 800,
                            child: LineGraph(
                                birthDate: providerGraph.selectedDate!),
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
              ResponsiveRowColumnItem(
                rowFlex: 1,
                columnOrder: config.columnOrderResponsiveDate,
                child: Container(
                  height: 500,
                  margin: isMobile || isTablet
                      ? const EdgeInsets.only(bottom: 20)
                      : const EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey.withOpacity(0.3), width: 2),
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
