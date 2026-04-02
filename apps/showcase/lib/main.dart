import 'package:app_lib_auth/auth.dart';
import 'package:app_lib_comments/comments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'mocks/mock_auth_repository.dart';
import 'mocks/mock_comment_repository.dart';

void main() {
  runApp(
    ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(MockAuthRepository()),
        commentRepositoryProvider.overrideWithValue(MockCommentRepository()),
      ],
      child: const ShowcaseApp(),
    ),
  );
}
