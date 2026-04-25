import 'package:flutter/material.dart';

/// A language option for [LanguagePickerTile].
class LanguageOption {
  const LanguageOption({required this.code, required this.label});

  /// Locale code (e.g. 'en', 'ko').
  final String code;

  /// Display label (e.g. 'English', '한국어').
  final String label;
}

/// ListTile showing the current language; taps to show a picker dialog.
class LanguagePickerTile extends StatelessWidget {
  const LanguagePickerTile({
    required this.currentLanguage,
    required this.languages,
    required this.onChanged,
    this.title = 'Language',
    this.icon,
    super.key,
  });

  /// Currently selected language code.
  final String currentLanguage;

  /// Available languages.
  final List<LanguageOption> languages;

  /// Called when a language is selected.
  final ValueChanged<String> onChanged;

  /// Tile title.
  final String title;

  /// Optional leading icon.
  final IconData? icon;

  String get _currentLabel {
    for (final lang in languages) {
      if (lang.code == currentLanguage) return lang.label;
    }
    return currentLanguage;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon ?? Icons.language),
      title: Text(title),
      subtitle: Text(_currentLabel),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showPicker(context),
    );
  }

  void _showPicker(BuildContext context) {
    showDialog<String>(
      context: context,
      builder:
          (context) => SimpleDialog(
            title: Text(title),
            children:
                languages.map((lang) {
                  return SimpleDialogOption(
                    onPressed: () {
                      Navigator.of(context).pop(lang.code);
                      onChanged(lang.code);
                    },
                    child: Row(
                      children: [
                        if (lang.code == currentLanguage)
                          Icon(
                            Icons.check,
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        else
                          const SizedBox(width: 20),
                        const SizedBox(width: 12),
                        Text(lang.label),
                      ],
                    ),
                  );
                }).toList(),
          ),
    );
  }
}
