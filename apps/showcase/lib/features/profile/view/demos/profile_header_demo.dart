import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../sample_data/sample_data.dart';

class ProfileHeaderDemo extends StatelessWidget {
  const ProfileHeaderDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ProfileHeader')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ProfileHeader(
              displayName: SampleData.userName,
              bio: SampleData.userBio,
              stats: const [
                ProfileStat(label: 'Followers', count: 1200),
                ProfileStat(label: 'Posts', count: 342),
                ProfileStat(label: 'Following', count: 180),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'ProfileHeader displays a user avatar, name, bio, and stat counters.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
