import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../error/app_exception.dart';

mixin HttpServiceMixin {
  final String baseUrl = 'https://mockend.com/api/repolyo/sendmoney-api';
  static const int defaultTimeoutSecs = 3;

  Future<http.Response> get(
    Uri uri, {
    String message = '',
    Duration timeout = const Duration(seconds: defaultTimeoutSecs),
  }) async {
    try {
      final response = await http.get(uri).timeout(timeout);
      _handleResponse(response);
      return response;
    } on TimeoutException {
      throw AppTimeoutException(message);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<http.Response> post(
    Uri uri, {
    String message = '',
    Map<String, String>? headers,
    Object? body,
    Duration timeout = const Duration(seconds: defaultTimeoutSecs),
  }) async {
    try {
      final response = await http
          .post(uri, headers: headers, body: body)
          .timeout(timeout);
      _handleResponse(response);
      return response;
    } on TimeoutException {
      throw AppTimeoutException(message);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  void _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return;
      case 400:
        throw BadRequestException(response.body);
      case 401:
      case 403:
        throw UnauthorisedException(response.body);
      case 404:
        throw NotFoundException("The requested resource was not found");
      default:
        throw FetchDataException(
          'Error occurred with status code: ${response.statusCode}',
        );
    }
  }
}
