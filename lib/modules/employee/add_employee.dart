import 'package:employee_crud/modules/dashboard/home_page.dart';
import 'package:employee_crud/modules/employee/dtos/employeeRequest.dart';
import 'package:employee_crud/modules/employee/services/employee_service.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:toastification/toastification.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({super.key});

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  final _storage = GetStorage();
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _countryCodeController = TextEditingController();
  final _salaryController = TextEditingController();

  bool _isFulltime = false;
  bool _isLoading = false;
  var _selectedGender = 'Male';
  final RegExp _emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9\-\_]+(\.[a-zA-Z]+)*$");

  Future<void> _addEmployee() async {
    final request = EmployeeRequest(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        countryCode: "+${_countryCodeController.text}",
        phone: _phoneController.text,
        salary: int.tryParse(_salaryController.text),
        gender: _selectedGender,
        isFulltime: _isFulltime);

    final response =
        await EmployeeService.createEmployee(_storage.read('token'), request);
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
          title: const Text('Successfully added the employee'),
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
        _firstNameController.clear();
        _lastNameController.clear();
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Add New Employee",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  const Text(
                    'To add new employee fill in the form below',
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                    ),
                    controller: _firstNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                    ),
                    controller: _lastNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a last name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Text('Select gender',
                      style:
                          TextStyle(fontSize: 16, color: Colors.grey.shade700)),
                  Row(
                    children: [
                      Row(
                        children: [
                          Radio<String>(
                              value: "Male",
                              groupValue: _selectedGender,
                              onChanged: (vl) {
                                setState(() {
                                  _selectedGender = vl ?? "Male";
                                });
                              }),
                          const Text('Male')
                        ],
                      ),
                      Row(
                        children: [
                          Radio<String>(
                              value: "Female",
                              groupValue: _selectedGender,
                              onChanged: (vl) {
                                setState(() {
                                  _selectedGender = vl ?? "Female";
                                });
                              }),
                          const Text('Female')
                        ],
                      ),
                      Row(
                        children: [
                          Radio<String>(
                              value: "Other",
                              groupValue: _selectedGender,
                              onChanged: (vl) {
                                setState(() {
                                  _selectedGender = vl ?? "Other";
                                });
                              }),
                          const Text('Other')
                        ],
                      )
                    ],
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text("Email address"),
                    ),
                    controller: _emailController,
                    validator: (value) {
                      if (value == null) {
                        return "Email address cannot be empty";
                      } else if (!_emailRegExp.hasMatch(value.trim())) {
                        return "Please enter a valid email address";
                      } else {
                        return null;
                      }
                    },
                    textCapitalization: TextCapitalization.none,
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Country Code'),
                    keyboardType: TextInputType.number,
                    controller: _countryCodeController,
                    maxLength: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter country code';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text('Phone Number'),
                    ),
                    keyboardType: TextInputType.number,
                    controller: _phoneController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please  enter a phone number";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Salary'),
                    controller: _salaryController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter employee salary';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Text("Select if employee is full time or not",
                      style:
                          TextStyle(fontSize: 16, color: Colors.grey.shade700)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _isFulltime,
                        onChanged: (value) {
                          setState(() {
                            _isFulltime = value!;
                          });
                        },
                      ),
                      const Text('Full-time'),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 40)),
                    onPressed: _isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              _addEmployee();
                            }
                          },
                    child: _isLoading
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                        : const Text('Add employee'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
