import 'dart:convert';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const String _kEsp32BaseUrl = 'http://192.168.4.1';

/// API 1: ESP32_Status
/// Method: GET http://192.168.4.1/api/status
class ESP32StatusCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.urlRequest(
      'GET',
      '$_kEsp32BaseUrl/api/status',
    );
  }

  static bool? wifi(dynamic response) {
    if (response is Map) return response['wifi'] as bool?;
    return null;
  }

  static String? ssid(dynamic response) {
    if (response is Map) return response['ssid']?.toString();
    return null;
  }

  static String? ip(dynamic response) {
    if (response is Map) return response['ip']?.toString();
    return null;
  }

  static int? grade(dynamic response) {
    if (response is Map && response['grade'] != null) {
      return int.tryParse(response['grade'].toString());
    }
    return null;
  }

  static int? project(dynamic response) {
    if (response is Map && response['project'] != null) {
      return int.tryParse(response['project'].toString());
    }
    return null;
  }

  static bool? running(dynamic response) {
    if (response is Map) return response['running'] as bool?;
    return null;
  }

  static String? projectName(dynamic response) {
    if (response is Map) return response['projectName']?.toString();
    return null;
  }
}

/// API 2: ESP32_Select
/// Method: POST http://192.168.4.1/api/select
/// Body: {"grade": [grade], "project": [project]}
class ESP32SelectCall {
  static Future<ApiCallResponse> call({
    required int grade,
    required int project,
  }) async {
    final body = json.encode({
      'grade': grade,
      'project': project,
    });

    return ApiManager.urlRequest(
      'POST',
      '$_kEsp32BaseUrl/api/select',
      body: body,
    );
  }

  static bool? ok(dynamic response) {
    if (response is Map) return response['ok'] as bool?;
    return null;
  }
}

/// API 3: ESP32_Execute
/// Method: POST http://192.168.4.1/api/execute
/// Header: Content-Type: application/json, No body.
class ESP32ExecuteCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.urlRequest(
      'POST',
      '$_kEsp32BaseUrl/api/execute',
      body: '{}',
    );
  }

  static bool? ok(dynamic response) {
    if (response is Map) return response['ok'] as bool?;
    return null;
  }

  static bool? running(dynamic response) {
    if (response is Map) return response['running'] as bool?;
    return null;
  }
}

/// API 4: ESP32_Stop
/// Method: POST http://192.168.4.1/api/stop
/// Header: Content-Type: application/json, No body.
class ESP32StopCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.urlRequest(
      'POST',
      '$_kEsp32BaseUrl/api/stop',
      body: '{}',
    );
  }

  static bool? ok(dynamic response) {
    if (response is Map) return response['ok'] as bool?;
    return null;
  }

  static bool? running(dynamic response) {
    if (response is Map) return response['running'] as bool?;
    return null;
  }
}
