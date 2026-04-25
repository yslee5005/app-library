import 'dart:async';

import 'package:app_lib_theme/theme.dart';
import 'package:flutter/material.dart';

/// A search bar with search icon, clear button, and debounced [onChanged].
///
/// The callback fires after [debounceDuration] of inactivity (default 300 ms).
class AppSearchBar extends StatefulWidget {
  const AppSearchBar({
    this.onChanged,
    this.onSubmitted,
    this.hint = 'Search',
    this.debounceDuration = const Duration(milliseconds: 300),
    this.autofocus = false,
    this.controller,
    super.key,
  });

  /// Called with the current text after the debounce period.
  final ValueChanged<String>? onChanged;

  /// Called when the user presses the search/done key.
  final ValueChanged<String>? onSubmitted;

  /// Placeholder text shown when the field is empty.
  final String hint;

  /// How long to wait after the last keystroke before firing [onChanged].
  final Duration debounceDuration;

  /// Whether to focus the field automatically.
  final bool autofocus;

  /// Optional external controller.
  final TextEditingController? controller;

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  late final TextEditingController _controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(widget.debounceDuration, () {
      widget.onChanged?.call(value);
    });
  }

  void _clear() {
    _controller.clear();
    _debounce?.cancel();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: _controller,
      autofocus: widget.autofocus,
      onChanged: _onChanged,
      onSubmitted: widget.onSubmitted,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: widget.hint,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            if (_controller.text.isEmpty) return const SizedBox.shrink();
            return IconButton(icon: const Icon(Icons.clear), onPressed: _clear);
          },
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest.withAlpha(80),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),
    );
  }
}
