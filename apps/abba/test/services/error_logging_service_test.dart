import 'package:abba/services/error_logging_service.dart';
import 'package:flutter_test/flutter_test.dart';

/// Unit tests for [ErrorLoggingService.maskSensitive].
///
/// These tests exercise the Sentry `beforeSend` masking rules to make sure
/// PII and prayer transcript content never leak into Sentry events.
void main() {
  group('ErrorLoggingService.maskSensitive', () {
    test('masks email addresses', () {
      final out = ErrorLoggingService.maskSensitive(
        'Contact foo.bar+baz@example.com for more info',
      );
      expect(out, contains('[EMAIL]'));
      expect(out, isNot(contains('foo.bar+baz@example.com')));
    });

    test('masks E.164 phone numbers', () {
      final out = ErrorLoggingService.maskSensitive('Call +821012345678 now');
      expect(out, contains('[PHONE]'));
      expect(out, isNot(contains('+821012345678')));
    });

    test('masks hyphen-separated KR/US phone numbers', () {
      final out = ErrorLoggingService.maskSensitive('Reach 010-1234-5678');
      expect(out, contains('[PHONE]'));
      expect(out, isNot(contains('010-1234-5678')));
    });

    test('masks JWT-like tokens', () {
      final out = ErrorLoggingService.maskSensitive(
        'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxIn0.dozjgNryP',
      );
      expect(out, contains('[JWT]'));
      expect(out, isNot(contains('eyJhbGciOiJIUzI1NiJ9')));
    });

    test('masks long Korean runs as [TRANSCRIPT]', () {
      const prayer =
          '주님 오늘 하루도 감사합니다. 가족들을 지켜주시고 건강과 평안을 주소서. '
          '하나님 제 기도를 들어주세요.';
      final out = ErrorLoggingService.maskSensitive(prayer);
      expect(out, contains('[TRANSCRIPT]'));
      expect(out, isNot(contains('가족들을 지켜주시고')));
    });

    test('keeps short Korean strings intact', () {
      // Under 50 chars — likely UI labels, not transcripts.
      const short = '안녕하세요 반갑습니다';
      final out = ErrorLoggingService.maskSensitive(short);
      expect(out, equals(short));
    });

    test('masks URL query params but keeps host + path', () {
      final out = ErrorLoggingService.maskSensitive(
        'GET https://api.example.com/v1/auth?token=abc&secret=xyz failed',
      );
      expect(out, contains('https://api.example.com/v1/auth'));
      expect(out, contains('[PARAMS_REDACTED]'));
      expect(out, isNot(contains('token=abc')));
    });

    test('truncates messages over 500 chars with [TRUNCATED] suffix', () {
      final long = 'A' * 600;
      final out = ErrorLoggingService.maskSensitive(long);
      expect(out.length, lessThanOrEqualTo(530));
      expect(out, endsWith('[TRUNCATED]'));
    });

    test('leaves ordinary English error messages unchanged', () {
      const msg = 'NetworkException: request timed out after 30s';
      final out = ErrorLoggingService.maskSensitive(msg);
      expect(out, equals(msg));
    });

    test('applies multiple rules in one pass', () {
      final out = ErrorLoggingService.maskSensitive(
        'User foo@bar.com with phone 010-1111-2222 called API',
      );
      expect(out, contains('[EMAIL]'));
      expect(out, contains('[PHONE]'));
    });
  });
}
