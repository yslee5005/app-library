import 'dart:io';

import 'package:app_lib_theme/theme.dart';
import 'package:flutter/material.dart';

/// Image source options for [AppImagePicker].
enum ImagePickerSource { camera, gallery }

/// A tappable widget that displays a placeholder or selected image thumbnail
/// and fires [onImageSelected] when the user picks an image.
///
/// This widget does **not** include the `image_picker` package itself. The
/// caller is responsible for handling the actual file selection via
/// [onPickRequested] and then updating the widget's [imageFile].
class AppImagePicker extends StatelessWidget {
  const AppImagePicker({
    required this.onPickRequested,
    this.imageFile,
    this.imageUrl,
    this.size = 120.0,
    this.placeholderIcon = Icons.add_a_photo,
    this.label,
    this.borderRadius,
    super.key,
  });

  /// Called when the user taps the picker. The callback receives the chosen
  /// source so the caller can launch camera or gallery.
  final ValueChanged<ImagePickerSource> onPickRequested;

  /// Currently selected local image file. Takes precedence over [imageUrl].
  final File? imageFile;

  /// Fallback network image URL shown when [imageFile] is null.
  final String? imageUrl;

  /// Size of the picker square.
  final double size;

  /// Icon shown when no image is selected.
  final IconData placeholderIcon;

  /// Optional label below the icon.
  final String? label;

  /// Border radius. Defaults to [AppRadius.lg].
  final BorderRadius? borderRadius;

  void _showSourceDialog(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder:
          (_) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () {
                    Navigator.pop(context);
                    onPickRequested(ImagePickerSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    onPickRequested(ImagePickerSource.gallery);
                  },
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = borderRadius ?? BorderRadius.circular(AppRadius.lg);

    Widget content;
    if (imageFile != null) {
      content = ClipRRect(
        borderRadius: radius,
        child: Image.file(
          imageFile!,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    } else if (imageUrl != null) {
      content = ClipRRect(
        borderRadius: radius,
        child: Image.network(
          imageUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholder(theme),
        ),
      );
    } else {
      content = _placeholder(theme);
    }

    return GestureDetector(
      onTap: () => _showSourceDialog(context),
      child: content,
    );
  }

  Widget _placeholder(ThemeData theme) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            placeholderIcon,
            size: size * 0.3,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          if (label != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              label!,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
