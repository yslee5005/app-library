import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../sample_data/sample_data.dart';

class ProfileEditFormDemo extends StatelessWidget {
  const ProfileEditFormDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ProfileEditForm')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ProfileEditForm(
          initialName: SampleData.userName,
          initialBio: SampleData.userBio,
          onSave: (name, bio) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Saved: $name')));
          },
        ),
      ),
    );
  }
}
