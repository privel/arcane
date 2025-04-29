import 'package:arcane/services/providers/line_graph_provider.dart';
import 'package:arcane/widgets/line_graph/line_graph.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> generateYears(DateTime birthDate) {
    final int startYear = birthDate.year;
    return List.generate(105, (index) => "${startYear + index} г.");
  }

  @override
  Widget build(BuildContext context) {
    final providerGraph = Provider.of<LifeChartProvider>(context);

    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;

    // TextEditingController day = TextEditingController();
    // TextEditingController month = TextEditingController();
    // TextEditingController year = TextEditingController();

    providerGraph.setDay("12");
    providerGraph.setMonth("12");
    providerGraph.setYear("2000");
    DateTime? selectedDate;
    bool isGraphVisible = false;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 30.0, top: 20.0, right: 30.0),
        child: ListView(
          children: [
            Column(
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
                        child: const Center(
                            child: Text("Правый виджет (мобильный)")),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 250,
                        width: double.infinity,
                        color: Colors.green[100],
                        child: const Center(
                            child: Text("Левый виджет (мобильный)")),
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
                        child: const Center(
                            child: Text("Правый виджет (планшет)")),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        height: 350,
                        width: double.infinity,
                        color: Colors.green[100],
                        child:
                            const Center(child: Text("Левый виджет (планшет)")),
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
                          height: 700,
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
                                      Container(
                                        height: 400,
                                        child: LineGraph(
                                            birthDate:
                                                providerGraph.selectedDate!),
                                      ),
                                      // const SizedBox(height: 30),
                                      // Text('${generateYears(providerGraph.selectedDate!)}'),
                                      
                                      // Padding(
                                      //   padding: const EdgeInsets.symmetric(
                                      //       horizontal: 10),
                                      //   child: SizedBox(
                                      //     height:
                                      //         180, // ЗАДАЁМ высоту для сетки годов
                                      //     child: GridView.builder(
                                      //       padding: EdgeInsets.zero,
                                      //       physics:
                                      //           const NeverScrollableScrollPhysics(),
                                      //       gridDelegate:
                                      //           const SliverGridDelegateWithFixedCrossAxisCount(
                                      //         crossAxisCount: 7, // 7 колонок
                                      //         mainAxisSpacing: 2,
                                      //         crossAxisSpacing: 80,
                                      //         childAspectRatio:
                                      //             8, // Текст не сжимается
                                      //       ),
                                      //       itemCount: generateYears(
                                      //               providerGraph.selectedDate!)
                                      //           .length,
                                      //       itemBuilder: (context, index) {
                                      //         return Container(
                                      //           color: Colors.amber,
                                      //           child: Text(
                                      //             '${generateYears(providerGraph.selectedDate!)[index]}',
                                      //             style: const TextStyle(
                                      //                 fontSize: 10),
                                      //           ),
                                      //         );
                                      //       },
                                      //     ),
                                      //   ),
                                      // ),
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
                                            color: Color(0xFFb31217),
                                            width: 1.5),
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
                                            color: Color(0xFFb31217),
                                            width: 1.5),
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
                                            color: Color(0xFFb31217),
                                            width: 1.5),
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
                                      onPressed: () => providerGraph
                                          .calculateFlChart(context),
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
          ],
        ),
      ),
    );
  }
}
