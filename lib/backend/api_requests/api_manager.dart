import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiCallResponse {
  const ApiCallResponse(
    this.jsonBody,
    this.headers,
    this.statusCode, {
    this.response,
    this.succeeded = false,
    this.errorDescription,
  });

  final dynamic jsonBody;
  final Map<String, String> headers;
  final int statusCode;
  final http.Response? response;
  final bool succeeded;
  final String? errorDescription;

  static ApiCallResponse failure({
    String? message,
    int statusCode = -1,
  }) {
    return ApiCallResponse(
      null,
      {},
      statusCode,
      succeeded: false,
      errorDescription: message ?? 'Network request failed',
    );
  }
}

class ApiManager {
  ApiManager._();

  static final ApiManager _instance = ApiManager._();
  static ApiManager get instance => _instance;

  static const Duration defaultTimeout = Duration(seconds: 3);

  static Future<ApiCallResponse> urlRequest(
    String callType,
    String apiUrl, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? params,
    String? body,
    Duration timeout = defaultTimeout,
  }) async {
    try {
      final uri = Uri.parse(apiUrl);
      final stringHeaders = headers?.map((k, v) => MapEntry(k, v.toString())) ?? {};

      http.Response response;
      if (callType.toUpperCase() == 'GET') {
        response = await http.get(uri, headers: stringHeaders).timeout(timeout);
      } else if (callType.toUpperCase() == 'POST') {
        response = await http
            .post(
              uri,
              headers: {
                'Content-Type': 'application/json',
                ...stringHeaders,
              },
              body: body,
            )
            .timeout(timeout);
      } else {
        throw UnsupportedError('Unsupported call type: $callType');
      }

      dynamic jsonBody;
      try {
        if (response.body.isNotEmpty) {
          jsonBody = json.decode(response.body);
        }
      } catch (_) {
        jsonBody = response.body;
      }

      final succeeded = response.statusCode >= 200 && response.statusCode < 300;

      return ApiCallResponse(
        jsonBody,
        response.headers,
        response.statusCode,
        response: response,
        succeeded: succeeded,
        errorDescription: succeeded ? null : 'HTTP ${response.statusCode}',
      );
    } on SocketException catch (e) {
      return ApiCallResponse.failure(
        message: 'ESP32 not reachable. Check Wi-Fi connection to VeriSmat-ESP32. (${e.message})',
      );
    } on TimeoutException {
      return ApiCallResponse.failure(
        message: 'Connection timed out. Ensure ESP32 is powered on and connected.',
      );
    } on http.ClientException catch (e) {
      return ApiCallResponse.failure(
        message: 'Network client error: ${e.message}',
      );
    } catch (e) {
      return ApiCallResponse.failure(
        message: 'Unexpected communication error: $e',
      );
    }
  }
}
