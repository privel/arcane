import 'package:flutter/material.dart';

class DatePickerProvider extends ChangeNotifier {
  bool _showPicker = false;
  DateTime? _selectedDate;

  bool get showPicker => _showPicker;
  DateTime? get selectedDate => _selectedDate;

  void togglePicker() {
    _showPicker = !_showPicker;
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void closePicker() {
    _showPicker = false;
    notifyListeners();
  }
}
