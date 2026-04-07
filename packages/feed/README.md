# app_lib_feed

Social feed package for App Library.

## Features

- `FeedItem` model — post with likes, comments, saves
- `FeedComment` model — threaded comments with parentId
- `FeedRepository` abstract interface — CRUD for posts, comments, likes, saves, reports
- `MockFeedRepository` for development/testing

## Usage

```dart
import 'package:app_lib_feed/feed.dart';

final repo = MockFeedRepository();

// Create a post
final post = await repo.createPost(
  content: 'Hello world!',
  category: 'general',
);

// Like & comment
await repo.toggleLike(post.id);
await repo.createComment(postId: post.id, content: 'Nice post!');

// Get feed
final feed = await repo.getFeed(category: 'general');
```

## SQL Schema

See `sql/feed_schema.sql` for Supabase table definitions (posts, comments, likes, saves, reports).
