import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

class AppDialogDemo extends StatelessWidget {
  const AppDialogDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AppDialog')),
      body: Center(
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => AppDialog.show(
                context,
                title: 'Info',
                content: 'This is an informational dialog.',
                variant: AppDialogVariant.info,
                primaryLabel: 'OK',
              ),
              child: const Text('Info'),
            ),
            ElevatedButton(
              onPressed: () => AppDialog.show(
                context,
                title: 'Success',
                content: 'Operation completed successfully!',
                variant: AppDialogVariant.success,
                primaryLabel: 'Great',
              ),
              child: const Text('Success'),
            ),
            ElevatedButton(
              onPressed: () => AppDialog.show(
                context,
                title: 'Error',
                content: 'An error occurred.',
                variant: AppDialogVariant.error,
                primaryLabel: 'Dismiss',
              ),
              child: const Text('Error'),
            ),
            ElevatedButton(
              onPressed: () => AppDialog.show(
                context,
                title: 'Confirm',
                content: 'Are you sure you want to proceed?',
                variant: AppDialogVariant.confirm,
                primaryLabel: 'Yes',
                secondaryLabel: 'No',
              ),
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}
