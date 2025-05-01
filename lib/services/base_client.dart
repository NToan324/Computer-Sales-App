// lib/services/base_client.dart
import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:computer_sales_app/services/app_exceptions.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BaseClient {
 static const String baseUrl = 'http://localhost:3000/';
  static const int timeOutDuration = 30;

  late Dio dio;
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  BaseClient({Dio? dioParam}) {
    dio = dioParam ?? Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(seconds: timeOutDuration),
      receiveTimeout: Duration(seconds: timeOutDuration),
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final excludes = [
          'login',
          'signup',
          'forgot-password',
          'verify-otp',
        ];
        if(!excludes.any((path) => options.path.contains(path))) {
          final token = await _storage.read(key: 'access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        }
      },
      onError: (e, handler) async {
        if (e.response?.statusCode == 401) {
          // Xử lý refresh token nếu cần
        }
        handler.next(e);
      },
    ));
  }

  // GET Request
  Future<dynamic> get(String api) async {
    final uri = Uri.parse('$baseUrl$api');
    try {
      final response = await dio.get(uri.toString());
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', api);
    } on TimeoutException {
      throw ApiNotRespondingException('API timeout', uri.toString());
    }
  }

  // POST Request
  Future<dynamic> post(String api, Map<String, dynamic> body) async {
    final uri = Uri.parse('$baseUrl$api');
    try {
      final response = await dio.post(uri.toString(), data: body);
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', api);
    } on TimeoutException {
      throw ApiNotRespondingException('API timeout', uri.toString());
    }
  }

  // Handle response based on status code
  dynamic _processResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        return response.data;
      case 400:
        final message = _parseErrorMessage(response.data);
        throw BadRequestException(message, response.requestOptions.path);
      case 401:
      case 403:
        final message = _parseErrorMessage(response.data);
        throw UnAuthorizedException(message, response.requestOptions.path);
      case 500:
        throw FetchDataException('Error occurred: ${response.statusCode}',
            response.requestOptions.uri.toString());
      default:
        throw FetchDataException(
            'Something went wrong', response.requestOptions.uri.toString());
    }
  }

  String _parseErrorMessage(dynamic data) {
    if (data is String) return data;
    if (data is Map && data['message'] != null) return data['message'];
    return 'Unexpected error';
  }
}
