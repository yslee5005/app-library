import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

class ImagePickerDemo extends StatelessWidget {
  const ImagePickerDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AppImagePicker')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: AppImagePicker(
          label: 'Choose Photo',
          onPickRequested: (source) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Pick from: ${source.name}')),
            );
          },
        ),
      ),
    );
  }
}
