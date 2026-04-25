import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/outputs/history_output.dart';
import '../domain/log_category.dart';
import '../domain/log_entry.dart';
import '../domain/log_level.dart';

/// In-app log viewer with level/category filtering, search, and export.
///
/// ```dart
/// Navigator.push(context, MaterialPageRoute(
///   builder: (_) => LogViewerScreen(history: historyOutput),
/// ));
/// ```
class LogViewerScreen extends StatefulWidget {
  const LogViewerScreen({super.key, required this.history, this.onShare});

  final HistoryOutput history;

  /// Called when user taps Share. If null, copies to clipboard.
  final void Function(String text)? onShare;

  @override
  State<LogViewerScreen> createState() => _LogViewerScreenState();
}

class _LogViewerScreenState extends State<LogViewerScreen> {
  LogLevel? _levelFilter;
  LogCategory? _categoryFilter;
  final _searchController = TextEditingController();
  bool _autoScroll = true;
  final _scrollController = ScrollController();

  List<LogEntry> get _filteredEntries => widget.history.where(
    level: _levelFilter,
    category: _categoryFilter,
    search: _searchController.text,
  );

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entries = _filteredEntries;

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D2D2D),
        title: Text(
          'Logs (${entries.length}/${widget.history.length})',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'monospace',
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Auto-scroll toggle
          IconButton(
            icon: Icon(
              _autoScroll ? Icons.vertical_align_bottom : Icons.pause,
              color: _autoScroll ? Colors.greenAccent : Colors.grey,
              size: 20,
            ),
            tooltip: _autoScroll ? 'Auto-scroll ON' : 'Auto-scroll OFF',
            onPressed: () => setState(() => _autoScroll = !_autoScroll),
          ),
          // Share/Copy
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white, size: 20),
            tooltip: 'Export logs',
            onPressed: _exportLogs,
          ),
          // Clear
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.redAccent,
              size: 20,
            ),
            tooltip: 'Clear logs',
            onPressed: () {
              widget.history.clear();
              setState(() {});
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            color: const Color(0xFF2D2D2D),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'monospace',
              ),
              decoration: InputDecoration(
                hintText: 'Search logs...',
                hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey[600],
                  size: 18,
                ),
                suffixIcon:
                    _searchController.text.isNotEmpty
                        ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: Colors.grey[600],
                            size: 18,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        )
                        : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color(0xFF3C3C3C),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                isDense: true,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          // Filter chips
          Container(
            color: const Color(0xFF2D2D2D),
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                // Level filters
                _buildLevelChip(null, 'ALL'),
                _buildLevelChip(LogLevel.error, 'ERR'),
                _buildLevelChip(LogLevel.warning, 'WARN'),
                _buildLevelChip(LogLevel.info, 'INFO'),
                _buildLevelChip(LogLevel.debug, 'DBG'),
                const SizedBox(width: 8),
                Container(width: 1, height: 24, color: Colors.grey[700]),
                const SizedBox(width: 8),
                // Category filters
                _buildCategoryChip(null, 'All'),
                ...LogCategory.values.map(
                  (c) => _buildCategoryChip(c, c.name.toUpperCase()),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFF3C3C3C)),
          // Log entries
          Expanded(
            child:
                entries.isEmpty
                    ? Center(
                      child: Text(
                        'No logs',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    )
                    : ListView.builder(
                      controller: _scrollController,
                      itemCount: entries.length,
                      padding: const EdgeInsets.only(bottom: 16),
                      itemBuilder: (context, index) {
                        final entry = entries[index];
                        return _LogEntryTile(
                          entry: entry,
                          onTap: () => _showDetail(entry),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelChip(LogLevel? level, String label) {
    final selected = _levelFilter == level;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: GestureDetector(
        onTap: () => setState(() => _levelFilter = level),
        child: Chip(
          label: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.grey[400],
              fontSize: 11,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          backgroundColor:
              selected ? _levelColor(level) : const Color(0xFF3C3C3C),
          padding: EdgeInsets.zero,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
      ),
    );
  }

  Widget _buildCategoryChip(LogCategory? category, String label) {
    final selected = _categoryFilter == category;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: GestureDetector(
        onTap: () => setState(() => _categoryFilter = category),
        child: Chip(
          label: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.grey[400],
              fontSize: 11,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          backgroundColor: selected ? Colors.blueGrey : const Color(0xFF3C3C3C),
          padding: EdgeInsets.zero,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
      ),
    );
  }

  void _exportLogs() {
    final text = widget.history.export(
      level: _levelFilter,
      category: _categoryFilter,
      search: _searchController.text,
    );

    if (widget.onShare != null) {
      widget.onShare!(text);
    } else {
      Clipboard.setData(ClipboardData(text: text));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logs copied to clipboard'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _showDetail(LogEntry entry) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2D2D2D),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder:
          (ctx) => DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.3,
            maxChildSize: 0.9,
            expand: false,
            builder:
                (ctx, scroll) => SingleChildScrollView(
                  controller: scroll,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[600],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _detailRow(
                        'Level',
                        entry.level.name.toUpperCase(),
                        _levelColor(entry.level),
                      ),
                      _detailRow(
                        'Category',
                        entry.category.name.toUpperCase(),
                        Colors.white,
                      ),
                      if (entry.tag != null)
                        _detailRow('Tag', entry.tag!, Colors.white),
                      _detailRow(
                        'Time',
                        entry.timestamp.toIso8601String(),
                        Colors.grey[400]!,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Message',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      SelectableText(
                        entry.message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'monospace',
                        ),
                      ),
                      if (entry.error != null) ...[
                        const SizedBox(height: 12),
                        const Text(
                          'Error',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        SelectableText(
                          entry.error.toString(),
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 13,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                      if (entry.stackTrace != null) ...[
                        const SizedBox(height: 12),
                        const Text(
                          'Stack Trace',
                          style: TextStyle(color: Colors.orange, fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        SelectableText(
                          entry.stackTrace.toString(),
                          style: TextStyle(
                            color: Colors.orange[200],
                            fontSize: 11,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
          ),
    );
  }

  Widget _detailRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Color _levelColor(LogLevel? level) => switch (level) {
    LogLevel.error => Colors.redAccent,
    LogLevel.warning => Colors.orangeAccent,
    LogLevel.info => Colors.greenAccent,
    LogLevel.debug => Colors.grey,
    null => Colors.blueGrey,
  };
}

// ---------------------------------------------------------------------------
// Single log entry tile
// ---------------------------------------------------------------------------
class _LogEntryTile extends StatelessWidget {
  final LogEntry entry;
  final VoidCallback onTap;

  const _LogEntryTile({required this.entry, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: _levelColor(entry.level), width: 3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: level badge + category + time
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: _levelColor(entry.level).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    entry.level.name.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      color: _levelColor(entry.level),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  entry.category.name,
                  style: TextStyle(
                    color: Colors.blueGrey[300],
                    fontSize: 11,
                    fontFamily: 'monospace',
                  ),
                ),
                const Spacer(),
                Text(
                  _formatTime(entry.timestamp),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 10,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            // Message (single line, truncated)
            Text(
              entry.message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontFamily: 'monospace',
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            // Error indicator
            if (entry.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  entry.error.toString(),
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 11,
                    fontFamily: 'monospace',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }

  static String _formatTime(DateTime time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    final s = time.second.toString().padLeft(2, '0');
    final ms = time.millisecond.toString().padLeft(3, '0');
    return '$h:$m:$s.$ms';
  }

  static Color _levelColor(LogLevel level) => switch (level) {
    LogLevel.error => Colors.redAccent,
    LogLevel.warning => Colors.orangeAccent,
    LogLevel.info => Colors.greenAccent,
    LogLevel.debug => Colors.grey,
  };
}
