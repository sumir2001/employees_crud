import 'dart:convert';
import 'package:employee_crud/http.dart';
import 'package:employee_crud/modules/auth/dtos/error_response.dart';
import 'package:employee_crud/modules/auth/dtos/login_reg_request.dart';
import 'package:employee_crud/modules/auth/dtos/login_response.dart';
import 'package:employee_crud/modules/auth/dtos/register_response.dart';
import 'package:fpdart/fpdart.dart';
import 'package:loggy/loggy.dart';

class AuthService {
  static Future<Either<ErrorResponse, LoginResponse>> login(
      LoginRequest request) async {
    try {
      final response = await Http.dioClient
          .post<String>("login", data: jsonEncode(request.toJson()));
      if (response.statusCode == 200) {
        return Right(LoginResponse.fromJson(jsonDecode(response.data!)));
      } else {
        return Left(ErrorResponse.fromJson(jsonDecode(response.data!)));
      }
    } catch (e, stacktrace) {
      logError("login error", e, stacktrace);
      return Left(ErrorResponse as ErrorResponse);
    }
  }

  static Future<Either<ErrorResponse, RegisterResponse>> register(
      LoginRequest request) async {
    try {
      final response = await Http.dioClient
          .post<String>("register", data: jsonEncode(request.toJson()));
      if (response.statusCode == 201) {
        return Right(RegisterResponse.fromJson(jsonDecode(response.data!)));
      } else {
        return Left(ErrorResponse.fromJson(jsonDecode(response.data!)));
      }
    } catch (e, stacktrace) {
      logError("register error", e, stacktrace);
      return Left(ErrorResponse as ErrorResponse);
    }
  }
}
