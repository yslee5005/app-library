import 'package:http/http.dart' as http;

import '../logger.dart';
import '../../domain/log_category.dart';

/// HTTP client wrapper that logs requests and responses.
///
/// Wraps an inner [http.Client] and logs:
/// - Request method + URL (debug level)
/// - Response status + elapsed time (info level)
/// - Errors (error level)
///
/// Usage:
/// ```dart
/// final client = LoggingHttpClient(
///   inner: http.Client(),
///   logger: myLogger,
/// );
/// ```
class LoggingHttpClient extends http.BaseClient {
  LoggingHttpClient({
    required http.Client inner,
    required Logger logger,
    this.category = LogCategory.api,
  })  : _inner = inner,
        _logger = logger;

  final http.Client _inner;
  final Logger _logger;
  final LogCategory category;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    _logger.debug(
      '→ ${request.method} ${request.url}',
      category: category,
    );

    final stopwatch = Stopwatch()..start();
    try {
      final response = await _inner.send(request);
      stopwatch.stop();

      _logger.info(
        '← ${response.statusCode} ${request.url} [${stopwatch.elapsedMilliseconds}ms]',
        category: category,
      );

      return response;
    } catch (e, st) {
      stopwatch.stop();
      _logger.error(
        '✗ ${request.method} ${request.url} [${stopwatch.elapsedMilliseconds}ms]',
        category: category,
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  @override
  void close() {
    _inner.close();
    super.close();
  }
}
