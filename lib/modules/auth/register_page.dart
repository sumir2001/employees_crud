import 'package:employee_crud/modules/auth/dtos/login_reg_request.dart';
import 'package:employee_crud/modules/auth/login_page.dart';
import 'package:employee_crud/modules/auth/services/auth_service.dart';
import 'package:employee_crud/modules/dashboard/home_page.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _register() async {
    final isFormValid = _formKey.currentState?.validate() ?? false;

    final request = LoginRequest(
      username: _usernameController.text,
      password: _passwordController.text,
    );

    if (isFormValid) {
      setState(() {
        _isLoading = true;
      });

      final response = await AuthService.register(request);
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
          // print("data ${r.data!.username ?? 'No username'}");
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(
                    username: r.data!.username ?? '', id: r.data!.id ?? 0)),
          );

          toastification.show(
            context: context,
            type: ToastificationType.success,
            title: const Text('Successfully registered'),
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
          _usernameController.clear();
          _passwordController.clear();
        },
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        maintainBottomViewPadding: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                child: Image.asset(
                  'assets/images/background2.png',
                  fit: BoxFit.cover,
                  height: 320,
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Sign Up",
                            style: TextStyle(
                                fontSize: 36, fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            "Please enter your username and password to register",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Username',
                                hintText: 'Please enter a username'),
                            controller: _usernameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a username';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Password',
                                hintText: 'Please enter a password'),
                            obscureText: true,
                            controller: _passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 40)),
                            onPressed: _isLoading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      _register();
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
                                      SizedBox(
                                          width:
                                              10), // add some space between the circle and the text
                                      Text('Loading...'),
                                    ],
                                  )
                                : const Text('Register'),
                          ),
                          const SizedBox(height: 4),
                          Center(
                            child: TextButton(
                                child: const Text(
                                  'Already have an account? Login',
                                  textAlign: TextAlign.center,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage()),
                                  );
                                }),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
