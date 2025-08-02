import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/environment.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  factory ApiException.fromResponse(http.Response response) {
    try {
      final error = jsonDecode(response.body);
      return ApiException(
        message: error['message'] ?? '알 수 없는 오류가 발생했습니다',
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ApiException(
        message: '알 수 없는 오류가 발생했습니다',
        statusCode: response.statusCode,
      );
    }
  }
}

abstract class BaseApiService {
  static String get baseUrl => Environment.apiBaseUrl;
  static Duration get timeoutDuration => Environment.apiTimeout;

  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static void _logRequest(String method, String url, {Map<String, dynamic>? body, Map<String, String>? queryParams}) {
    if (Environment.isDebugMode) {
      print('[API DEBUG] ===== $method REQUEST =====');
      print('[API DEBUG] URL: $url');
      if (queryParams != null && queryParams.isNotEmpty) {
        print('[API DEBUG] Query Parameters: $queryParams');
      }
      print('[API DEBUG] Headers: $headers');
      if (body != null) {
        print('[API DEBUG] Body: ${jsonEncode(body)}');
      }
      print('[API DEBUG] ==========================');
    }
  }

  static void _logResponse(String method, String url, http.Response response) {
    if (Environment.isDebugMode) {
      print('[API DEBUG] ===== $method RESPONSE =====');
      print('[API DEBUG] URL: $url');
      print('[API DEBUG] Status Code: ${response.statusCode}');
      print('[API DEBUG] Headers: ${response.headers}');
      if (response.body.isNotEmpty) {
        try {
          final prettyJson = jsonEncode(jsonDecode(response.body));
          print('[API DEBUG] Body: $prettyJson');
        } catch (e) {
          print('[API DEBUG] Body (raw): ${response.body}');
        }
      } else {
        print('[API DEBUG] Body: (empty)');
      }
      print('[API DEBUG] ============================');
    }
  }
  
  static Future<T> get<T>(
    String endpoint,
    T Function(dynamic) fromJson, {
    Map<String, String>? queryParameters,
  }) async {
    try {
      Uri uri = Uri.parse('$baseUrl$endpoint');
      if (queryParameters != null) {
        uri = uri.replace(queryParameters: queryParameters);
      }
      
      _logRequest('GET', uri.toString(), queryParams: queryParameters);
      
      final response = await http
          .get(uri, headers: headers)
          .timeout(timeoutDuration);

      _logResponse('GET', uri.toString(), response);
      
      return await _handleResponse(response, fromJson);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: '네트워크 오류가 발생했습니다: ${e.toString()}');
    }
  }

  static Future<T> post<T>(
    String endpoint,
    Map<String, dynamic> body,
    T Function(dynamic) fromJson, {
    List<int> successCodes = const [200, 204],
  }) async {
    try {
      final url = '$baseUrl$endpoint';
      
      _logRequest('POST', url, body: body);
      
      final response = await http
          .post(
            Uri.parse(url),
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(timeoutDuration);

      _logResponse('POST', url, response);
      
      return await _handleResponse(response, fromJson, successCodes: successCodes);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: '네트워크 오류가 발생했습니다: ${e.toString()}');
    }
  }

  static Future<void> postVoid(
    String endpoint,
    Map<String, dynamic> body, {
    List<int> successCodes = const [200, 204],
  }) async {
    try {
      final url = '$baseUrl$endpoint';
      
      _logRequest('POST', url, body: body);
      
      final response = await http
          .post(
            Uri.parse(url),
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(timeoutDuration);

      _logResponse('POST', url, response);
      
      if (!successCodes.contains(response.statusCode)) {
        throw ApiException.fromResponse(response);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: '네트워크 오류가 발생했습니다: ${e.toString()}');
    }
  }

  static Future<T> put<T>(
    String endpoint,
    Map<String, dynamic> body,
    T Function(dynamic) fromJson,
  ) async {
    try {
      final url = '$baseUrl$endpoint';
      
      _logRequest('PUT', url, body: body);
      
      final response = await http
          .put(
            Uri.parse(url),
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(timeoutDuration);

      _logResponse('PUT', url, response);
      
      return await _handleResponse(response, fromJson);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: '네트워크 오류가 발생했습니다: ${e.toString()}');
    }
  }

  static Future<void> delete(String endpoint) async {
    try {
      final url = '$baseUrl$endpoint';
      
      _logRequest('DELETE', url);
      
      final response = await http
          .delete(Uri.parse(url), headers: headers)
          .timeout(timeoutDuration);

      _logResponse('DELETE', url, response);
      
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException.fromResponse(response);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: '네트워크 오류가 발생했습니다: ${e.toString()}');
    }
  }

  static Future<T> _handleResponse<T>(
    http.Response response,
    T Function(dynamic) fromJson, {
    List<int> successCodes = const [200],
  }) async {
    if (successCodes.contains(response.statusCode)) {
      if (response.body.isNotEmpty) {
        final data = jsonDecode(response.body);
        return fromJson(data);
      } else {
        // 빈 응답의 경우 빈 맵을 전달
        return fromJson({});
      }
    } else {
      throw ApiException.fromResponse(response);
    }
  }
}