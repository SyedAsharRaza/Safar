/// A failure the UI can explain to a person.
///
/// Every failure mode carries wording a traveller can act on, because "an
/// error occurred" tells someone standing on a dark road nothing useful.
class ApiException implements Exception {
  const ApiException(
    this.message, {
    this.statusCode,
    this.code,
    this.isNetwork = false,
  });

  final String message;
  final int? statusCode;
  final String? code;
  final bool isNetwork;

  factory ApiException.network() => const ApiException(
        'Could not reach the server. Check your connection and try again.',
        isNetwork: true,
        code: 'NETWORK',
      );

  factory ApiException.timeout() => const ApiException(
        'The server took too long to respond. It may be waking up — try again.',
        isNetwork: true,
        code: 'TIMEOUT',
      );

  /// True when retrying might plausibly succeed.
  bool get isRetryable =>
      isNetwork || (statusCode != null && statusCode! >= 500);

  bool get isRateLimited => statusCode == 429;
  bool get isUnauthorized => statusCode == 401;

  @override
  String toString() => message;
}
