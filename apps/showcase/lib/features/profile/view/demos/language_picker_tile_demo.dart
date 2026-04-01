import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

class LanguagePickerTileDemo extends StatefulWidget {
  const LanguagePickerTileDemo({super.key});

  @override
  State<LanguagePickerTileDemo> createState() => _LanguagePickerTileDemoState();
}

class _LanguagePickerTileDemoState extends State<LanguagePickerTileDemo> {
  String _currentLanguage = 'en';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LanguagePickerTile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select language:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            LanguagePickerTile(
              currentLanguage: _currentLanguage,
              languages: const [
                LanguageOption(code: 'en', label: 'English'),
                LanguageOption(code: 'ko', label: 'Korean'),
                LanguageOption(code: 'ja', label: 'Japanese'),
              ],
              onChanged: (code) {
                setState(() => _currentLanguage = code);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Language: $code')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
