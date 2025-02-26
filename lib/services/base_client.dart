import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:computer_sales_app/services/app_exceptions.dart';
import 'package:dio/dio.dart';

class BaseClient {
  static const int TIME_OUT_DURATION = 30;
  //GET
  Future<dynamic> get(String baseUrl, String api) async {
    var uri = Uri.parse(baseUrl + api); //http://localhost:3000/api
    final dio = Dio();
    try {
      var response = await dio
          .get(uri.toString())
          .timeout(const Duration(seconds: TIME_OUT_DURATION));
      return _processReponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      print('TimeoutException');
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    }
  }

  //POST
  Future<dynamic> post(String baseUrl, String api, dynamic payloadObj) async {
    var uri = Uri.parse(baseUrl + api); //http://localhost:3000/api
    final dio = Dio();
    var payload = json.encode(payloadObj);
    try {
      var response = await dio
          .post(uri.toString(), data: payload)
          .timeout(const Duration(seconds: TIME_OUT_DURATION));
      // var response = await http
      //     .post(uri, body: payload)
      //     .timeout(const Duration(seconds: TIME_OUT_DURATION));
      return _processReponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    }
  }

  //DELETE
  Future<dynamic> delete(String baseUrl, String api, {String? id}) async {
    var uri = Uri.parse('$baseUrl$api${id != null ? '/$id' : ''}');
    final dio = Dio();
    try {
      var response = await dio
          .delete(uri.toString())
          .timeout(const Duration(seconds: TIME_OUT_DURATION));
      // var response = await http
      //     .delete(uri)
      //     .timeout(const Duration(seconds: TIME_OUT_DURATION));
      return _processReponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    }
  }

  //OTHERS

  dynamic _processReponse(Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = response.data;
        return responseJson;
      case 400:
        throw BadRequestException(
            utf8.decode(response.data), response.requestOptions.path);
      case 500:
        throw FetchDataException('Error occured: ${response.statusCode}',
            response.requestOptions.uri.toString());
      default:
    }
  }
}
