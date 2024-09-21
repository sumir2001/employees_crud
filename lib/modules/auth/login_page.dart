import 'package:employee_crud/modules/auth/dtos/login_reg_request.dart';
import 'package:employee_crud/modules/auth/register_page.dart';
import 'package:employee_crud/modules/auth/services/auth_service.dart';
import 'package:employee_crud/modules/dashboard/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:toastification/toastification.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _storage = GetStorage();

  bool _isLoading = false;

  Future<void> _login() async {
    final isFormValid = _formKey.currentState?.validate() ?? false;

    final request = LoginRequest(
      username: _usernameController.text.trim(),
      password: _passwordController.text,
    );

    if (isFormValid) {
      setState(() {
        _isLoading = true;
      });

      final response = await AuthService.login(request);
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
          final decodedToken = Jwt.parseJwt(r.data!);
          DateTime? expiryDate = Jwt.getExpiryDate(r.data!);

          await _storage.write('token', r.data);
          await _storage.write('expiryDate', expiryDate?.toIso8601String());
          await _storage.write('name', decodedToken['name']);

          toastification.show(
              context: context,
              type: ToastificationType.success,
              title: const Text('Successfully logged in'),
              autoCloseDuration: const Duration(seconds: 4),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(255, 100, 206, 128),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                  spreadRadius: 0,
                )
              ],
              primaryColor: Color.fromARGB(255, 100, 206, 128));

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(username: decodedToken['name'])),
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
                  'assets/images/background1.png',
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
                            "Sign In",
                            style: TextStyle(
                                fontSize: 36, fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            "Please enter your username and password to continue",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Username',
                                hintText: 'Please enter your username'),
                            controller: _usernameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Password',
                                hintText: 'Please enter your password'),
                            obscureText: true,
                            controller: _passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
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
                                      _login();
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
                                : const Text('Login'),
                          ),
                          const SizedBox(height: 4),
                          Center(
                            child: TextButton(
                                child: const Text(
                                  'Dont have an account? Register',
                                  textAlign: TextAlign.center,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterPage()),
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
