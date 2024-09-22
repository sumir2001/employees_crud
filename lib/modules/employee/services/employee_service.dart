import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:employee_crud/http.dart';
import 'package:employee_crud/modules/auth/dtos/error_response.dart';
import 'package:employee_crud/modules/dashboard/dtos/employee_response.dart';
import 'package:employee_crud/modules/employee/dtos/employeeRequest.dart';
import 'package:employee_crud/modules/employee/dtos/successResponse.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loggy/loggy.dart';

class EmployeeService {
  static Future<String?> getToken() async {
    final _storage = GetStorage();
    return await _storage.read('token');
  }

  static Future<Either<ErrorResponse, EmployeesResponse>> getEmployeeById(
      int id) async {
    try {
      final token = await getToken();

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final response = await Http.dioClient.get<String>(
        "employees/$id",
        options: Options(headers: headers),
      );

      if (response.statusCode == 401) {
        return Left(
          ErrorResponse(
              status: 401, message: "Token has expired, please login again"),
        );
      }

      if (response.statusCode == 200) {
        var employee = EmployeesResponse.fromJson(
          jsonDecode(response.data!),
        );
        return Right(employee);
      }
      return Left(
        ErrorResponse.fromJson(
          jsonDecode(response.data!),
        ),
      );
    } catch (e, stacktrace) {
      logError("Could not fetch employee details", e, stacktrace);
      return Left(ErrorResponse(message: 'Unknown error'));
    }
  }

  static Future<Either<ErrorResponse, EmployeeRequest>> createEmployee(
      EmployeeRequest request) async {
    try {
      final token = await getToken();

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final response = await Http.dioClient.post<String>(
        "employees",
        options: Options(headers: headers),
        data: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 401) {
        return Left(
          ErrorResponse(
              status: 401,
              message:
                  "Token has expired, please login again to create employee"),
        );
      }

      if (response.statusCode == 201) {
        return Right(EmployeeRequest.fromJson(jsonDecode(response.data!)));
      } else {
        return Left(ErrorResponse.fromJson(jsonDecode(response.data!)));
      }
    } catch (e, stacktrace) {
      logError("Employee create error", e, stacktrace);
      return Left(ErrorResponse as ErrorResponse);
    }
  }

  static Future<Either<ErrorResponse, EmployeeRequest>> updateEmployee(
      int id, EmployeeRequest request) async {
    try {
      final token = await getToken();

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final response = await Http.dioClient.put<String>(
        "employees/$id",
        options: Options(headers: headers),
        data: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 401) {
        return Left(
          ErrorResponse(
              status: 401,
              message:
                  "Token has expired, please login again to update employee"),
        );
      }

      if (response.statusCode == 200) {
        return Right(EmployeeRequest.fromJson(jsonDecode(response.data!)));
      } else {
        return Left(ErrorResponse.fromJson(jsonDecode(response.data!)));
      }
    } catch (e, stacktrace) {
      logError("Employee update error", e, stacktrace);
      return Left(ErrorResponse as ErrorResponse);
    }
  }

  static Future<Either<ErrorResponse, SuccessResponse>> deleteEmployee(
      int id) async {
    try {
      final token = await getToken();

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final response = await Http.dioClient.delete<String>(
        "employees/$id",
        options: Options(headers: headers),
      );

      if (response.statusCode == 401) {
        return Left(
          ErrorResponse(
              status: 401,
              message:
                  "Token has expired, please login again to delete delete"),
        );
      }

      if (response.statusCode == 200) {
        return Right(SuccessResponse.fromJson(jsonDecode(response.data!)));
      } else {
        return Left(ErrorResponse.fromJson(jsonDecode(response.data!)));
      }
    } catch (e, stacktrace) {
      logError("Error in deleting the employee", e, stacktrace);
      return Left(ErrorResponse as ErrorResponse);
    }
  }
}
