import 'package:flutter/material.dart';

class CustomDatePickerDialog extends StatefulWidget {
  final DateTime initialDate;

  const CustomDatePickerDialog({Key? key, required this.initialDate}) : super(key: key);

  @override
  State<CustomDatePickerDialog> createState() => _CustomDatePickerDialogState();
}

class _CustomDatePickerDialogState extends State<CustomDatePickerDialog> {
  late DateTime tempPickedDate;

  @override
  void initState() {
    super.initState();
    tempPickedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    final datePickerTheme = Theme.of(context).datePickerTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      backgroundColor: datePickerTheme.backgroundColor ?? Colors.white,
      title: Text(
        'Выберите дату рождения',
        style: TextStyle(
          color: datePickerTheme.headerForegroundColor ?? Colors.black,
        ),
      ),
      content: SizedBox(
        height: 400,
        width: 400,
        child: Column(
          children: [
            Expanded(
              child: CalendarDatePicker(
                initialDate: tempPickedDate,
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                onDateChanged: (date) {
                  setState(() {
                    tempPickedDate = date;
                  });
                },
                currentDate: DateTime.now(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: WidgetStatePropertyAll(
                        datePickerTheme.headerForegroundColor ?? Colors.black),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Отмена'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: datePickerTheme.todayForegroundColor?.resolve({}) ?? colorScheme.primary,
                    foregroundColor: datePickerTheme.backgroundColor ?? Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).pop(tempPickedDate),
                  child: const Text('Подтвердить'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
