import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'register.dart';
import 'lawyprofiles.dart';

class AppColors {
  static const tombolLogin = Color.fromRGBO(255, 0, 0, 1.0); // Merah solid
  static const hitam = Colors.black;
}

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({Key? key}) : super(key: key);

  Future<void> _handleLogin(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8000/api/login'),
        body: json.encode({
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LawyerProfilePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Login gagal. Cek kembali email dan password Anda.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan. Silakan coba lagi nanti.')),
      );
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Atur ke tengah
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FractionallySizedBox(
                widthFactor: 0.5,
                child: Image.asset('assets/images/logo.png'),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Atur ke tengah
                  children: [
                    Text(
                      'Login ke akun anda',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 30),
                    _buildInputBox('Email', screenWidth, emailController),
                    SizedBox(height: 30),
                    _buildInputBox('Password', screenWidth, passwordController,
                        isPassword: true),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        _handleLogin(context);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.tombolLogin,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 25,
                            color: AppColors.hitam,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    RichText(
                      text: TextSpan(
                        text: 'Belum memiliki akun? ',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.hitam,
                        ),
                        children: [
                          TextSpan(
                            text: 'Register',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              fontStyle: FontStyle.italic,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterScreen()),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputBox(
      String labelText, double screenWidth, TextEditingController controller,
      {bool isPassword = false}) {
    return Container(
      width: screenWidth * 0.8,
      height: 80, // Menyesuaikan tinggi input box
      alignment: Alignment.center, // Letakkan input di tengah
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: TextStyle(fontSize: 20), // Memperbesar font input box
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: labelText,
          hintStyle: TextStyle(fontSize: 20), // Memperbesar font teks petunjuk
        ),
      ),
    );
  }
}
