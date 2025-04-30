import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:computer_sales_app/services/app_exceptions.dart';
import 'package:dio/dio.dart';

class BaseClient {
  static const String baseUrl = 'http://localhost:3000/';
  static const int timeOutDuration = 30;

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: timeOutDuration),
      receiveTimeout: const Duration(seconds: timeOutDuration),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  // GET
  Future<dynamic> get(String api) async {
    try {
      final response = await dio.get(api);
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', api);
    } on TimeoutException {
      throw ApiNotRespondingException('API not responded in time', api);
    }
  }

  // POST
  Future<dynamic> post(String api, dynamic payloadObj) async {
    try {
      final response = await dio.post(api, data: json.encode(payloadObj));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', api);
    } on TimeoutException {
      throw ApiNotRespondingException('API not responded in time', api);
    }
  }

  // PUT
  Future<dynamic> put(String api, dynamic payloadObj) async {
    try {
      final response = await dio.put(api, data: json.encode(payloadObj));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', api);
    } on TimeoutException {
      throw ApiNotRespondingException('API not responded in time', api);
    }
  }

  // PATCH
  Future<dynamic> patch(String api, dynamic payloadObj) async {
    try {
      final response = await dio.patch(api, data: json.encode(payloadObj));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', api);
    } on TimeoutException {
      throw ApiNotRespondingException('API not responded in time', api);
    }
  }

  // DELETE
  Future<dynamic> delete(String api, {String? id}) async {
    final fullPath = id != null ? '$api/$id' : api;
    try {
      final response = await dio.delete(fullPath);
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', fullPath);
    } on TimeoutException {
      throw ApiNotRespondingException('API not responded in time', fullPath);
    }
  }

  // RESPONSE HANDLER
  dynamic _processResponse(Response response) {
    final statusCode = response.statusCode ?? 0;

    switch (statusCode) {
      case 200:
      case 201:
        return response.data;
      case 400:
        final message = _parseErrorMessage(response.data);
        throw BadRequestException(message, response.requestOptions.path);
      case 401:
      case 403:
        final message = _parseErrorMessage(response.data);
        throw UnAuthorizedException(message, response.requestOptions.path);
      case 500:
      default:
        throw FetchDataException(
          'Error occurred: $statusCode',
          response.requestOptions.uri.toString(),
        );
    }
  }

  String _parseErrorMessage(dynamic data) {
    if (data is String) return data;
    if (data is Map && data['message'] != null) return data['message'];
    return 'Unexpected error';
  }
}
