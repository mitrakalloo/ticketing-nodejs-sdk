import 'dart:convert';
import 'package:http/http.dart' as http;
import '../errors/errors.dart';
import 'constants.dart';

class APIAdapter {
  final String _originalKey;
  String _currentKey;
  final bool _sandbox;
  final Duration timeout;

  APIAdapter(
    String apiKey, {
    bool sandbox = false,
    this.timeout = const Duration(seconds: 10),
  })  : _originalKey = apiKey,
        _currentKey = apiKey,
        _sandbox = sandbox;

  String get key => _currentKey;

  set key(String newKey) {
    _currentKey = newKey;
  }

  bool get sandbox => _sandbox;

  String get base => _sandbox
      ? "https://qa.ticketingevents.com/v3"
      : "https://api.ticketingevents.com/v3";

  String get media => _sandbox
      ? "https://qa.ticketingevents.com/media"
      : "https://api.ticketingevents.com/media";

  void reset() {
    key = _originalKey;
  }

  Map<String, String> _buildHeaders([Map<String, String>? additionalHeaders]) {
    final headers = {
      'X-API-Key': _currentKey,
      'X-Client-Version': Constants.clientVersion,
      'Content-Type': 'application/json',
    };
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }
    return headers;
  }

  Uri _buildUri(String path, [Map<String, dynamic>? params]) {
    final baseUri = Uri.parse('$base$path');
    if (params != null && params.isNotEmpty) {
      return baseUri.replace(
        queryParameters: params.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );
    }
    return baseUri;
  }

  Future<http.Response> get(
    String url, [
    Map<String, dynamic>? params,
    Map<String, String>? headers,
  ]) async {
    return _request('GET', url, params: params, headers: headers);
  }

  Future<http.Response> post(
    String url, [
    Map<String, dynamic>? data,
    Map<String, String>? headers,
  ]) async {
    return _request('POST', url, data: data, headers: headers);
  }

  Future<http.Response> put(
    String url, [
    Map<String, dynamic>? data,
    Map<String, String>? headers,
  ]) async {
    return _request('PUT', url, data: data, headers: headers);
  }

  Future<http.Response> delete(
    String url, [
    Map<String, dynamic>? params,
    Map<String, String>? headers,
  ]) async {
    return _request('DELETE', url, params: params, headers: headers);
  }

  Future<http.Response> _request(
    String method,
    String url, {
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    Map<String, dynamic>? data,
  }) async {
    final uri = _buildUri(url, params);
    final requestHeaders = _buildHeaders(headers);

    try {
      http.Response response;
      
      switch (method) {
        case 'GET':
          response = await http
              .get(uri, headers: requestHeaders)
              .timeout(timeout);
          break;
        case 'POST':
          response = await http
              .post(
                uri,
                headers: requestHeaders,
                body: data != null ? jsonEncode(data) : null,
              )
              .timeout(timeout);
          break;
        case 'PUT':
          response = await http
              .put(
                uri,
                headers: requestHeaders,
                body: data != null ? jsonEncode(data) : null,
              )
              .timeout(timeout);
          break;
        case 'DELETE':
          response = await http
              .delete(uri, headers: requestHeaders)
              .timeout(timeout);
          break;
        default:
          throw UnsupportedOperationError(
            400,
            'Unsupported HTTP method: $method',
          );
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response;
      } else {
        _handleError(response);
        // This line should never be reached
        throw TickeTingError(response.statusCode, 'Unknown error occurred');
      }
    } catch (e) {
      if (e is TickeTingError) {
        rethrow;
      }
      throw TickeTingError(0, 'Request failed: $e');
    }
  }

  void _handleError(http.Response response) {
    final statusCode = response.statusCode;
    String errorMessage;

    try {
      final errorData = jsonDecode(response.body);
      errorMessage = errorData['error'] ?? response.body;
    } catch (_) {
      errorMessage = response.body;
    }

    if (statusCode == 401) {
      throw UnauthorisedError(statusCode, errorMessage);
    } else {
      throw TickeTingError(statusCode, errorMessage);
    }
  }
}
