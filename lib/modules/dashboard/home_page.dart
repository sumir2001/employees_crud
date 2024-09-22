import 'package:employee_crud/modules/auth/dtos/error_response.dart';
import 'package:employee_crud/modules/auth/login_page.dart';
import 'package:employee_crud/modules/dashboard/dtos/employee_response.dart';
import 'package:employee_crud/modules/dashboard/services/dashboard_service.dart';
import 'package:employee_crud/modules/employee/add_employee.dart';
import 'package:employee_crud/modules/employee/employee_details.dart';
import 'package:employee_crud/modules/widgets/loading_container.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' as fp;

typedef AllEmployeesResponse = fp.Either<ErrorResponse, EmployeesResponse>;

class HomePage extends StatefulWidget {
  final String username;
  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<EmployeesResponse?> _employeesFuture;

  Future<EmployeesResponse?> _getEmployees() async {
    final response = await DashboardService.getEmployees();

    var x = response.match((l) {}, (r) {
      return r;
    });
    return x;
  }

  @override
  void initState() {
    super.initState();
    _employeesFuture = _getEmployees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
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
          padding: const EdgeInsets.only(
              top: 20.0, right: 10.0, left: 10.0, bottom: 45.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back, ${widget.username}',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 6,
              ),
              const Text(
                'View all the employees and their details',
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(130, 101, 160, 1),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 6,
                        offset: const Offset(0, 4))
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(113, 234, 225, 245),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.people,
                        size: 26,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Total Employees",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Center(
                          child: FutureBuilder<EmployeesResponse?>(
                            future: _employeesFuture,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final employeesResponse = snapshot.data;
                                final employeeCount =
                                    employeesResponse?.data?.length;
                                return Text(
                                  '$employeeCount',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 24),
                                );
                              } else {
                                return const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                "All employees",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: FutureBuilder<AllEmployeesResponse?>(
                  future: DashboardService.getEmployees(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Loader(
                          description: "Loading all employees ...");
                    }

                    if (snapshot.hasData) {
                      final data = snapshot.data!;

                      return data.match((l) {
                        return Text(
                            l.message ?? 'Could not fetch any employees',
                            style: const TextStyle(color: Colors.red));
                      },
                          (r) => SingleChildScrollView(
                                child: Column(
                                  children: [
                                    if (r.data!.isEmpty)
                                      const Text("No employees added"),
                                    ...r.data!.map((e) {
                                      return Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 14, horizontal: 16),
                                        margin:
                                            const EdgeInsets.only(bottom: 12),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey.shade300,
                                                blurRadius: 6,
                                                offset: const Offset(0, 4))
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor:
                                                  const Color(0xFF8265a0),
                                              child: Text(
                                                '${e.firstName!.substring(0, 1).toUpperCase()}${e.lastName!.substring(0, 1).toUpperCase()}',
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 16,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${e.firstName!} ${e.lastName!}",
                                                ),
                                                const SizedBox(
                                                  height: 6,
                                                ),
                                                Text(
                                                  e.email!,
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey.shade800),
                                                ),
                                              ],
                                            ),
                                            const Spacer(),
                                            Material(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            EmployeeDetails(
                                                                id: e.id!)),
                                                  );
                                                },
                                                child: Ink(
                                                  child: Container(
                                                    width: 36,
                                                    height: 36,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade100,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                    ),
                                                    child: const Icon(
                                                      Icons.arrow_forward_ios,
                                                      size: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ));
                    }

                    return const Text("Something went wrong");
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEmployee()),
          );
        },
        backgroundColor: const Color(0xFF8265a0),
        child: const Icon(Icons.add),
      ),
    );
  }
}
