import 'package:arcane/services/config/config_matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_framework/responsive_framework.dart';

class MatrixPage extends StatefulWidget {
  const MatrixPage({super.key});

  @override
  State<MatrixPage> createState() => _MatrixPageState();
}

class _MatrixPageState extends State<MatrixPage> {
  List<MatrixPoint> points = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  void handleSubmit() {
    final name = nameController.text.trim();
    final dateText = dateController.text.trim();

    try {
      // 🔴 Проверка на пустое имя
      if (name.isEmpty) {
        throw FormatException("Пожалуйста, введите имя");
      }

      final parts = dateText.split(RegExp(r'[./\-]'));
      if (parts.length != 3) throw FormatException("Неверный формат даты");

      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      if (day < 1 ||
          day > 31 ||
          month < 1 ||
          month > 12 ||
          year < 1000 || // изменено: допускаем года от 1000
          year > DateTime.now().year) {
        throw FormatException("Недопустимые значения даты");
      }

      final date = DateTime(year, month, day);
      if (date.month != month || date.day != day || date.year != year) {
        throw FormatException("Такой даты не существует");
      }

      final result = calculateMatrix(date);
      setState(() {
        points = result;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e is FormatException ? e.message : 'Ошибка при обработке данных',
          ),
        ),
      );
    }
  }

  int sumDigits(int number) {
    while (number > 22 && ![11, 22].contains(number)) {
      number =
          number.toString().split('').map(int.parse).reduce((a, b) => a + b);
    }
    return number;
  }

  List<MatrixPoint> calculateMatrix(DateTime birthDate) {
    final day = birthDate.day;
    final month = birthDate.month;
    final year = birthDate.year;

    final a = sumDigits(day + month); // точка 0 лет
    final b = sumDigits(day + year); // точка 20 лет
    final c = sumDigits(a + b); // точка 40 лет
    final g = sumDigits(c + a); // точка 60 лет
    final d = [11, 22].contains(a + b + c) ? a + b + c : sumDigits(a + b + c);

    final e = ((a + b) / 2).round();
    final f = ((b + c) / 2).round();
    final h = ((g + a) / 2).round();
    final i = ((c + g) / 2).round();

    final k = sumDigits(b + d);
    final l = sumDigits(c + d);
    final m = sumDigits(a + d);
    final n = sumDigits(g + d);

    final e1 = sumDigits(e + d);
    final e2 = sumDigits(f + d);
    final x1 = sumDigits(m + l);
    final x2 = sumDigits(n + k);
    final xx = sumDigits(x1 + x2);

    return [
      MatrixPoint(dx: 0.132, dy: 0.4981, label: '$a'), // A – 0 лет
      MatrixPoint(dx: 0.486, dy: 0.15, label: '$b'), // Б – 20 лет
      MatrixPoint(dx: 0.825, dy: 0.500, label: '$c'), // В – 40 лет
      MatrixPoint(dx: 0.4872, dy: 0.848, label: '$g'), // Г – 60 лет
      MatrixPoint(dx: 0.486, dy: 0.500, label: '$d'), // Д – центр

      MatrixPoint(dx: 0.236, dy: 0.253, label: '$e'), // Е – 10 лет
      MatrixPoint(dx: 0.725, dy: 0.254, label: '$f'), // Ж – 30 лет
      MatrixPoint(dx: 0.726, dy: 0.744, label: '$i'), // З – 50 лет
      MatrixPoint(dx: 0.236, dy: 0.744, label: '$h'), // И – 70 лет

      MatrixPoint(dx: 0.642, dy: 0.593, label: '$k'), // К – $
      MatrixPoint(dx: 0.58, dy: 0.662, label: '$l'), // Л – ❤️
      MatrixPoint(dx: 0.412, dy: 0.440, label: '$m'), // М – мужская линия
      MatrixPoint(dx: 0.412, dy: 0.582, label: '$n'), // Н – женская линия

      // MatrixPoint(dx: 0.65, dy: 0.27, label: '$e1'),
      // MatrixPoint(dx: 0.70, dy: 0.36, label: '$e2'),
      // MatrixPoint(dx: 0.54, dy: 0.56, label: '$x1'),
      // MatrixPoint(dx: 0.60, dy: 0.60, label: '$x2'),
      // MatrixPoint(dx: 0.58, dy: 0.63, label: '$xx'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final config = ConfigMatrix(isMobile, isTablet);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SelectableText(
            "Матрица Судьбы",
            style: TextStyle(
              fontFamily: "Inter",
              fontWeight: FontWeight.w600,
              fontSize: 28,
            ),
          ),
          ResponsiveRowColumn(
            layout: isMobile || isTablet
                ? ResponsiveRowColumnType.COLUMN
                : ResponsiveRowColumnType.ROW,
            rowMainAxisAlignment: MainAxisAlignment.start,
            columnMainAxisAlignment: MainAxisAlignment.start,
            columnCrossAxisAlignment: CrossAxisAlignment.start,
            rowCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResponsiveRowColumnItem(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 250,
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Введите имя",
                        labelStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
              ResponsiveRowColumnItem(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 250,
                    child: TextField(
                      controller: dateController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(8),
                        DateTextFormatter(), // Кастомная маска
                      ],
                      decoration: const InputDecoration(
                        labelText: "Введите дату дд/мм/гггг",
                        labelStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
              ResponsiveRowColumnItem(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: handleSubmit,
                    child: const Text("Подтвердить"),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isMobile ? 350 : (isTablet ? 500 : 700),
                maxHeight: isMobile ? 350 : (isTablet ? 500 : 700),
              ),
              child: DestinyMatrix(points: points),
            ),
          ),
        ],
      ),
    );
  }
}

class DestinyMatrix extends StatelessWidget {
  final List<MatrixPoint> points;

  const DestinyMatrix({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;

            // Пропорциональный размер шрифта (напр., 2% от ширины)
            final fontSize = width * 0.03; // подберите коэффициент

            return Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/img/matrix/matrix.png',
                    fit: BoxFit.contain,
                  ),
                ),
                ...points.map(
                  (point) => Positioned(
                    left: width * point.dx,
                    top: height * point.dy,
                    child: Text(
                      point.label,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class MatrixPoint {
  final double dx; // 0.0–1.0 по ширине
  final double dy; // 0.0–1.0 по высоте
  final String label;

  MatrixPoint({required this.dx, required this.dy, required this.label});
}

class DateTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (text.length >= 3 && text.length <= 4) {
      text = text.replaceFirstMapped(
          RegExp(r'^(\d{2})(\d+)'), (m) => '${m[1]}/${m[2]}');
    } else if (text.length > 4 && text.length <= 8) {
      text = text.replaceFirstMapped(
          RegExp(r'^(\d{2})(\d{2})(\d+)'), (m) => '${m[1]}/${m[2]}/${m[3]}');
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
