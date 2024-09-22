import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:employee_crud/http.dart';
import 'package:employee_crud/modules/auth/dtos/error_response.dart';
import 'package:employee_crud/modules/dashboard/dtos/employee_response.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loggy/loggy.dart';

class DashboardService {
  static Future<String?> getToken() async {
    final _storage = GetStorage();
    return await _storage.read('token');
  }

  static Future<Either<ErrorResponse, EmployeesResponse>> getEmployees() async {
    try {
      final token = await getToken();

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final response = await Http.dioClient.get<String>(
        "employees",
        options: Options(headers: headers),
      );

      if (response.statusCode == 401) {
        return Left(
          ErrorResponse(
              status: 401, message: "Token has expired, please login again"),
        );
      }

      if (response.statusCode == 200) {
        var employees = EmployeesResponse.fromJson(
          jsonDecode(response.data!),
        );
        return Right(employees);
      }

      return Left(
        ErrorResponse.fromJson(
          jsonDecode(response.data!),
        ),
      );
    } catch (e, stacktrace) {
      logError("Could not fetch employees", e, stacktrace);
      return Left(ErrorResponse as ErrorResponse);
    }
  }
}
