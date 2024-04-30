import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login.dart';
import 'styles.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> register(BuildContext context) async {
    final Uri uri = Uri.parse(
        'http://localhost:8000/api/register'); // Ganti dengan URL Laravel API Anda

    try {
      final response = await http.post(
        uri,
        body: json.encode({
          'name': nameController.text.trim(),
          // 'username': usernameController.text.trim(),
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 201) {
        // Registrasi berhasil
        print('Registrasi berhasil!');
        print(json.decode(response.body)['message']);

        // Tampilkan pesan berhasil dan arahkan ke halaman login
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registrasi berhasil')),
        );

        // Navigasi ke halaman login setelah registrasi berhasil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        // Registrasi gagal
        print('Registrasi gagal.');
        print(json.decode(response.body));

        // Tampilkan pesan gagal jika ada
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registrasi gagal')),
        );
      }
    } catch (e) {
      print('Error: $e');
      // Tampilkan pesan error jika ada
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100.0, bottom: 20.0),
              child: FractionallySizedBox(
                widthFactor: 0.5,
                child: Image.asset('assets/images/logo.png'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Text(
                    'Daftar akun anda sekarang',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  // SizedBox(height: 20),
                  // _buildInputBox('Nama Anda', nameController),
                  SizedBox(height: 10),
                  _buildInputBox('name', nameController),
                  SizedBox(height: 10),
                  _buildInputBox('Email', emailController),
                  SizedBox(height: 10),
                  _buildInputBox('Password', passwordController,
                      isPassword: true),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      register(context);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text(
                        'Daftar',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  RichText(
                    text: TextSpan(
                      text: 'Sudah memiliki akun? ',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
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
    );
  }

  Widget _buildInputBox(String labelText, TextEditingController controller,
      {bool isPassword = false}) {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: labelText,
        ),
      ),
    );
  }
}
