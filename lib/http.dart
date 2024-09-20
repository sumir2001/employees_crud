import 'package:dio/dio.dart';
import 'package:flutter_loggy_dio/flutter_loggy_dio.dart';

class Http {
  static String baseUrl = 'http://155.138.220.54:6000/';

  static Dio dioClient = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      validateStatus: (code) => true,
    ),
  )..interceptors.addAll([
      LoggyDioInterceptor(requestBody: true),
      // AuthorizationInterceptor(),
    ]);
}
