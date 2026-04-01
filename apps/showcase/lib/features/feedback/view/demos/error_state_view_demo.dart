import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

class ErrorStateViewDemo extends StatelessWidget {
  const ErrorStateViewDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ErrorStateView')),
      body: Center(
        child: ErrorStateView(
          message: 'Something went wrong. Please try again.',
          onRetry: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Retry tapped')),
            );
          },
        ),
      ),
    );
  }
}
