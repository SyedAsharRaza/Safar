import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'api_exception.dart';

/// Thin HTTP client for the Bahawalpur Safar API.
///
/// Holds the anonymous session token and unwraps the `{ success, data }`
/// envelope every endpoint returns, so callers deal in plain maps.
class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  String? _token;

  /// True once an anonymous session exists.
  bool get hasSession => _token != null;

  String? get token => _token;

  void setToken(String? token) => _token = token;

  /// Tracks whether we have completed a call yet, so the first one gets the
  /// longer cold-start allowance.
  bool _warmedUp = false;

  Map<String, String> _headers({bool json = true}) => {
        if (json) 'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    final cleaned = path.startsWith('/') ? path : '/$path';
    final uri = Uri.parse('${ApiConfig.baseUrl}$cleaned');
    if (query == null || query.isEmpty) return uri;
    return uri.replace(
      queryParameters: {
        ...uri.queryParameters,
        for (final e in query.entries)
          if (e.value != null) e.key: '${e.value}',
      },
    );
  }

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? query,
  }) =>
      _send(() => _client.get(_uri(path, query), headers: _headers()));

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
  }) =>
      _send(() => _client.post(
            _uri(path),
            headers: _headers(),
            body: jsonEncode(body ?? const {}),
          ));

  Future<Map<String, dynamic>> delete(String path) =>
      _send(() => _client.delete(_uri(path), headers: _headers()));

  Future<Map<String, dynamic>> _send(
    Future<http.Response> Function() request,
  ) async {
    final timeout =
        _warmedUp ? ApiConfig.timeout : ApiConfig.coldStartTimeout;

    late http.Response response;
    try {
      response = await request().timeout(timeout);
      _warmedUp = true;
    } on TimeoutException {
      throw ApiException.timeout();
    } catch (_) {
      throw ApiException.network();
    }

    Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw ApiException(
        'The server returned an unexpected response.',
        statusCode: response.statusCode,
      );
    }

    if (decoded['success'] == true) {
      return {
        'data': decoded['data'] ?? const <String, dynamic>{},
        'meta': decoded['meta'],
      };
    }

    final error = decoded['error'] as Map<String, dynamic>? ?? const {};
    throw ApiException(
      error['message'] as String? ?? 'Something went wrong.',
      statusCode: response.statusCode,
      code: error['code'] as String?,
    );
  }

  void dispose() => _client.close();
}
