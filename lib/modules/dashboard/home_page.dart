import 'package:employee_crud/modules/auth/dtos/error_response.dart';
import 'package:employee_crud/modules/auth/login_page.dart';
import 'package:employee_crud/modules/dashboard/dtos/employee_response.dart';
import 'package:employee_crud/modules/dashboard/services/dashboard_service.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:fpdart/fpdart.dart' as fp;

typedef AllEmployeesResponse = fp.Either<ErrorResponse, EmployeesResponse>;

class HomePage extends StatefulWidget {
  final String username;
  final int id;
  const HomePage({super.key, required this.username, required this.id});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            // Add functionality to open the navigation drawer
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back, ${widget.username}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 6,
              ),
              const Text(
                'View all the employees and their details',
              ),
              // stat for all employee count
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: FutureBuilder<AllEmployeesResponse?>(
                    future:
                        DashboardService.getEmployees(_storage.read('token')),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text("Loading all employees");
                      }

                      if (snapshot.hasData) {
                        final data = snapshot.data!;

                        return data.match((l) {
                          return const Text("Could not fetch any employees");
                        },
                            (r) => SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      if (r.data!.isEmpty)
                                        const Text("No employees added"),
                                      ...r.data!
                                          .map((e) => Row(
                                                children: [
                                                  Text(e.firstName!),
                                                  Text(e.lastName!)
                                                ],
                                              ))
                                          .toList(),
                                    ],
                                  ),
                                ));
                      }

                      return const Text("Something went wrong");
                    }),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 129, 94, 165),
      ),
    );
  }
}
