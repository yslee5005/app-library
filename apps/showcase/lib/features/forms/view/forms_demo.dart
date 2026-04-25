import 'package:flutter/material.dart';

import 'demos/app_button_demo.dart';
import 'demos/app_text_field_demo.dart';
import 'demos/date_time_picker_demo.dart';
import 'demos/form_section_demo.dart';
import 'demos/image_picker_demo.dart';
import 'demos/rating_bar_demo.dart';

class FormsDemo extends StatelessWidget {
  const FormsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forms')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.text_fields),
            title: const Text('AppTextField'),
            subtitle: const Text('Text fields: normal, password, multiline'),
            trailing: const Icon(Icons.chevron_right),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const AppTextFieldDemo(),
                  ),
                ),
          ),
          ListTile(
            leading: const Icon(Icons.smart_button),
            title: const Text('AppButton'),
            subtitle: const Text(
              'Primary, secondary, outline, loading, disabled',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const AppButtonDemo(),
                  ),
                ),
          ),
          ListTile(
            leading: const Icon(Icons.segment),
            title: const Text('FormSection'),
            subtitle: const Text('Grouped form fields with title'),
            trailing: const Icon(Icons.chevron_right),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const FormSectionDemo(),
                  ),
                ),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('AppDateTimePicker'),
            subtitle: const Text('Date and time selection'),
            trailing: const Icon(Icons.chevron_right),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const DateTimePickerDemo(),
                  ),
                ),
          ),
          ListTile(
            leading: const Icon(Icons.add_a_photo),
            title: const Text('AppImagePicker'),
            subtitle: const Text('Camera or gallery image selection'),
            trailing: const Icon(Icons.chevron_right),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const ImagePickerDemo(),
                  ),
                ),
          ),
          ListTile(
            leading: const Icon(Icons.star_half),
            title: const Text('AppRatingBar'),
            subtitle: const Text('Star rating input'),
            trailing: const Icon(Icons.chevron_right),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const RatingBarDemo(),
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
