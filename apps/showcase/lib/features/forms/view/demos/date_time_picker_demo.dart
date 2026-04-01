import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

class DateTimePickerDemo extends StatefulWidget {
  const DateTimePickerDemo({super.key});

  @override
  State<DateTimePickerDemo> createState() => _DateTimePickerDemoState();
}

class _DateTimePickerDemoState extends State<DateTimePickerDemo> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AppDateTimePicker')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppDateTimePicker(
              label: 'Select Date & Time',
              value: _selectedDate,
              onChanged: (dt) => setState(() => _selectedDate = dt),
            ),
            if (_selectedDate != null) ...[
              const SizedBox(height: 16),
              Text(
                'Selected: $_selectedDate',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
