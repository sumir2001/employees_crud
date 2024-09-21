import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:employee_crud/http.dart';
import 'package:employee_crud/modules/auth/dtos/error_response.dart';
import 'package:employee_crud/modules/dashboard/dtos/employee_response.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loggy/loggy.dart';

class DashboardService {
  static Future<Either<ErrorResponse, EmployeesResponse>> getEmployees(
      String token) async {
    try {
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final response = await Http.dioClient.get<String>(
        "/employees",
        options: Options(headers: headers),
      );
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
    } catch (exception, stacktrace) {
      logError("Could not fetch employees", exception, stacktrace);
      return Left(ErrorResponse as ErrorResponse);
    }
  }
}
