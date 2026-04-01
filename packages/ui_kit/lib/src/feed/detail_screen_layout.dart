import 'package:app_lib_theme/theme.dart';
import 'package:flutter/material.dart';

/// Detail screen with SliverAppBar hero image, scrollable body, and
/// optional bottom action bar.
class DetailScreenLayout extends StatelessWidget {
  const DetailScreenLayout({
    required this.body,
    this.heroImage,
    this.title,
    this.expandedHeight = 300.0,
    this.bottomBar,
    this.actions,
    super.key,
  });

  /// The scrollable body content.
  final Widget body;

  /// Hero image shown in the SliverAppBar.
  final Widget? heroImage;

  /// Title shown in the app bar when collapsed.
  final String? title;

  /// Height of the expanded SliverAppBar.
  final double expandedHeight;

  /// Optional bottom action bar (e.g. a button row).
  final Widget? bottomBar;

  /// Optional app bar actions.
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: heroImage != null ? expandedHeight : null,
            pinned: true,
            title: title != null ? Text(title!) : null,
            actions: actions,
            flexibleSpace: heroImage != null
                ? FlexibleSpaceBar(
                    background: heroImage,
                  )
                : null,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.md),
            sliver: SliverToBoxAdapter(child: body),
          ),
        ],
      ),
      bottomNavigationBar: bottomBar,
    );
  }
}
