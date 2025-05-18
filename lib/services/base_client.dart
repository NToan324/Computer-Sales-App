// lib/services/base_client.dart
import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:computer_sales_app/services/app_exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseClient {
  static const String baseUrl = 'http://localhost:3000/';
  static const int timeOutDuration = 30;
  late Dio dio;

  BaseClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: timeOutDuration),
        receiveTimeout: const Duration(seconds: timeOutDuration),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('accessToken');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
    ));

    dio.options.validateStatus = (status) {
      if (status != null) {
        return status >= 200 && status < 300;
      }
      return false;
    };
  }

  Future<dynamic> _handleDioException(DioException e) async {
    if (e.response != null) {
      return _processResponse(e.response!);
    } else {
      throw FetchDataException('An error occurred', e.requestOptions.path);
    }
  }

  // GET Request
  Future<dynamic> get(String api) async {
    final uri = Uri.parse('$baseUrl$api');
    try {
      final response = await dio.get(uri.toString());
      return response.data;
    } on SocketException {
      throw FetchDataException('No Internet connection', api);
    } on TimeoutException {
      throw ApiNotRespondingException('API timeout', uri.toString());
    } on DioException catch (e) {
      return _handleDioException(e);
    }
  }

  // POST Request
  Future<dynamic> post(String api, Map<String, dynamic> body) async {
    final uri = Uri.parse('$baseUrl$api');
    try {
      final response = await dio.post(uri.toString(), data: body);
      return response.data;
    } on SocketException {
      throw FetchDataException('No Internet connection', api);
    } on TimeoutException {
      throw ApiNotRespondingException('API timeout', uri.toString());
    } on DioException catch (e) {
      return _handleDioException(e);
    }
  }

  // PUT Request
  Future<dynamic> put(String api, Map<String, dynamic> body) async {
    final uri = Uri.parse('$baseUrl$api');
    try {
      final response = await dio.put(uri.toString(), data: body);
      return response.data;
    } on SocketException {
      throw FetchDataException('No Internet connection', api);
    } on TimeoutException {
      throw ApiNotRespondingException('API timeout', uri.toString());
    } on DioException catch (e) {
      return _handleDioException(e);
    }
  }

  // DELETE Request
  Future<dynamic> delete(String api) async {
    final uri = Uri.parse('$baseUrl$api');
    try {
      final response = await dio.delete(uri.toString());
      return response.data;
    } on SocketException {
      throw FetchDataException('No Internet connection', api);
    } on TimeoutException {
      throw ApiNotRespondingException('API timeout', uri.toString());
    } on DioException catch (e) {
      return _handleDioException(e);
    }
  }

  // PATCH Request
  Future<dynamic> patch(String api, Map<String, dynamic> body) async {
    final uri = Uri.parse('$baseUrl$api');
    try {
      final response = await dio.patch(uri.toString(), data: body);
      return response.data;
    } on SocketException {
      throw FetchDataException('No Internet connection', api);
    } on TimeoutException {
      throw ApiNotRespondingException('API timeout', uri.toString());
    } on DioException catch (e) {
      return _handleDioException(e);
    }
  }
  // Trong BaseClient
  Future<dynamic> upload(String api, FormData data) async {
    final uri = Uri.parse('$baseUrl$api');
    try {
      final options = Options(
        headers: {'Accept': 'application/json', 'Content-Type': 'multipart/form-data'},
      );
      final response = await dio.post(uri.toString(), data: data, options: options);
      return response.data;
    } on SocketException {
      throw FetchDataException('No Internet connection', api);
    } on TimeoutException {
      throw ApiNotRespondingException('API timeout', uri.toString());
    } on DioException catch (e) {
      if (e.response != null) {
        return _processResponse(e.response!);
      } else {
        throw FetchDataException('Network error', uri.toString());
      }
    }
  }
  // Xử lý phản hồi dựa trên mã trạng thái
  dynamic _processResponse(Response response) {
    switch (response.statusCode) {
      case 400:
        final message = _parseErrorMessage(response.data);
        print('Error Dio: $message');
        throw BadRequestException(message, response.requestOptions.path);
      case 401:
        final message = _parseErrorMessage(response.data);
        throw UnAuthorizedException(message, response.requestOptions.path);
      case 403:
        final message = _parseErrorMessage(response.data);
        throw UnAuthorizedException(message, response.requestOptions.path);
      case 500:
        final message = _parseErrorMessage(response.data);
        print('Server error: $message, Response: ${response.data}');
        throw FetchDataException('Error occurred: ${response.statusCode}',
            response.requestOptions.uri.toString());
      default:
        throw FetchDataException(
            'Something went wrong', response.requestOptions.uri.toString());
    }
  }

  // Phân tích thông báo lỗi từ phản hồi
  String _parseErrorMessage(dynamic data) {
    if (data is String) {
      return data;
    }
    if (data is Map) {
      if (data['message'] is String) {
        return data['message'];
      }
      if (data['error'] is Map && data['error']['message'] is String) {
        return data['error']['message'];
      }
      if (data['error'] is String) {
        return data['error'];
      }
    }

    return 'Unexpected error occurred';
  }
}
