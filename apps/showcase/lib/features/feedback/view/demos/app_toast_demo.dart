import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

class AppToastDemo extends StatelessWidget {
  const AppToastDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AppToast')),
      body: Center(
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => AppToast.show(
                context,
                message: 'Info toast message',
                variant: AppToastVariant.info,
              ),
              child: const Text('Info Toast'),
            ),
            ElevatedButton(
              onPressed: () => AppToast.show(
                context,
                message: 'Success toast message',
                variant: AppToastVariant.success,
              ),
              child: const Text('Success Toast'),
            ),
            ElevatedButton(
              onPressed: () => AppToast.show(
                context,
                message: 'Error toast message',
                variant: AppToastVariant.error,
              ),
              child: const Text('Error Toast'),
            ),
            ElevatedButton(
              onPressed: () => AppToast.show(
                context,
                message: 'Warning toast message',
                variant: AppToastVariant.warning,
              ),
              child: const Text('Warning Toast'),
            ),
          ],
        ),
      ),
    );
  }
}
