import 'package:flutter/material.dart';

class LifeChartProvider extends ChangeNotifier {
  String day = '';
  String month = '';
  String year = '';

  DateTime? selectedDate;
  bool isGraphVisible = false;

  void setDay(String value) {
    day = value;
    notifyListeners();
  }

  void setMonth(String value) {
    month = value;
    notifyListeners();
  }

  void setYear(String value) {
    year = value;
    notifyListeners();
  }

  void calculateFlChart(BuildContext context) {
    if (day.isEmpty || month.isEmpty || year.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, заполните все поля')),
      );
      return;
    }

    final int? dayInt = int.tryParse(day.trim());
    final int? monthInt = int.tryParse(month.trim());
    final int? yearInt = int.tryParse(year.trim());

    if (dayInt == null || monthInt == null || yearInt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите правильные числовые значения')),
      );
      return;
    }

    if (dayInt < 1 || dayInt > 31 || monthInt < 1 || monthInt > 12 || yearInt < 1000 || yearInt > 3000) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите корректные дату, месяц и год')),
      );
      return;
    }

    try {
      selectedDate = DateTime(yearInt, monthInt, dayInt);
      isGraphVisible = true;
      notifyListeners();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка при обработке даты')),
      );
    }
  }
}
