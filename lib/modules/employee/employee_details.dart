import 'package:employee_crud/modules/auth/dtos/error_response.dart';
import 'package:employee_crud/modules/dashboard/dtos/employee_response.dart';
import 'package:employee_crud/modules/dashboard/home_page.dart';
import 'package:employee_crud/modules/employee/services/employee_service.dart';
import 'package:employee_crud/modules/widgets/detail_row.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' as fp;
import 'package:get_storage/get_storage.dart';
import 'package:loggy/loggy.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

typedef EmployeeDetailResponse = fp.Either<ErrorResponse, EmployeesResponse>;

class EmployeeDetails extends StatefulWidget {
  final int id;
  const EmployeeDetails({super.key, required this.id});

  @override
  State<EmployeeDetails> createState() => _EmployeeDetailsState();
}

class _EmployeeDetailsState extends State<EmployeeDetails> {
  final _storage = GetStorage();
  bool _isLoading = false;

  Future<void> _deleteEmployee(int id) async {
    final response =
        await EmployeeService.deleteEmployee(_storage.read('token'), id);
    response.match(
      (l) => setState(() {
        toastification.show(
            context: context,
            type: ToastificationType.error,
            title: Text('Error: ${l.message}'),
            autoCloseDuration: const Duration(seconds: 4),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(226, 68, 68, 0.416),
                blurRadius: 6,
                offset: Offset(0, 2),
                spreadRadius: 0,
              )
            ],
            primaryColor: const Color.fromARGB(184, 226, 68, 68));
        _isLoading = false;
      }),
      (r) async {
        final username = await _storage.read('name');
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    username: username,
                  )),
        );

        toastification.show(
          context: context,
          type: ToastificationType.success,
          title: const Text('Successfully deleted the employee'),
          autoCloseDuration: const Duration(seconds: 4),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFF8265a0),
              blurRadius: 6,
              offset: Offset(0, 2),
              spreadRadius: 0,
            )
          ],
          primaryColor: const Color(0xFF8265a0),
        );

        _isLoading = false;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Employee Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 6,
              ),
              const Text(
                'View all the employees details and update',
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: FutureBuilder<EmployeeDetailResponse?>(
                  future: EmployeeService.getEmployeeById(
                      _storage.read('token'), widget.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Loading details .....");
                    }
                    if (snapshot.hasError) {
                      // Log the error
                      logError("Error fetching employee details",
                          snapshot.error, snapshot.stackTrace);
                      return Text("Error: ${snapshot.error}");
                    }
                    if (snapshot.hasData) {
                      final data = snapshot.data!;

                      return data.match((l) {
                        return const Text("Could not fetch any employees");
                      }, (r) {
                        final employee = r.data![0];
                        return Column(
                          children: [
                            DetailRow(
                                label: "First Name",
                                details: employee.firstName!),
                            const SizedBox(
                              height: 8,
                            ),
                            DetailRow(
                                label: "Last Name",
                                details: employee.lastName!),
                            const SizedBox(
                              height: 8,
                            ),
                            DetailRow(
                                label: "Gender", details: employee.gender!),
                            const SizedBox(
                              height: 8,
                            ),
                            DetailRow(label: "Email", details: employee.email!),
                            const SizedBox(
                              height: 8,
                            ),
                            DetailRow(
                                label: "Phone number",
                                details:
                                    "${employee.countryCode!} ${employee.phone!}"),
                            const SizedBox(
                              height: 8,
                            ),
                            DetailRow(
                                label: "Department",
                                details: employee.firstName!),
                            const SizedBox(
                              height: 8,
                            ),
                            DetailRow(
                                label: "Salary",
                                details: NumberFormat.currency(
                                        symbol: '\K', decimalDigits: 2)
                                    .format(employee.salary)),
                            const SizedBox(
                              height: 8,
                            ),
                            DetailRow(
                                label: "Full time",
                                details: employee.isFulltime!
                                    ? "Full time"
                                    : "Not Full time"),
                            const SizedBox(
                              height: 8,
                            ),
                            DetailRow(
                                label: "Created At",
                                details: DateFormat.yMMMd().format(
                                    DateTime.parse(employee.createdAt!))),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 40)),
                              onPressed: _isLoading ? null : () {},
                              child: _isLoading
                                  ? const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(),
                                        ),
                                        SizedBox(width: 10),
                                        Text('Loading...'),
                                      ],
                                    )
                                  : const Text('Update Employee'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 40),
                              ),
                              onPressed: _isLoading
                                  ? null
                                  : () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Confirm Delete'),
                                            content: const Text(
                                                'Are you sure you want to delete this employee?'),
                                            actions: [
                                              TextButton(
                                                child: const Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: const Text('Delete'),
                                                onPressed: () {
                                                  _deleteEmployee(employee.id!);
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                              child: _isLoading
                                  ? const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(),
                                        ),
                                        SizedBox(width: 10),
                                        Text('Loading...'),
                                      ],
                                    )
                                  : const Text('Delete Employee'),
                            )
                          ],
                        );
                      });
                    }
                    return const Text("Something went wrong");
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
