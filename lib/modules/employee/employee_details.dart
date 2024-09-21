import 'package:employee_crud/modules/dashboard/dtos/employee_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EmployeeDetails extends StatelessWidget {
  final EmployeesResponse details;
  const EmployeeDetails({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Employee Details",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }
}
