import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lawlink/login.dart';

class AppColors {
  static const tombolLogin = Color.fromRGBO(255, 0, 0, 1.0); // Merah solid
  static const hitam = Colors.black;
}

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 100.0,
                  bottom: 20.0), // Sesuaikan padding atas dan bawah gambar
              child: FractionallySizedBox(
                widthFactor:
                    0.5, // Menyesuaikan lebar gambar relatif terhadap layar
                child: Image.asset('assets/images/logo.png'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0), // Sesuaikan padding horizontal
              child: Column(
                children: [
                  Text(
                    'Daftar akun anda sekarang',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                      height: 20), // Memberikan jarak antara teks dan input box
                  _buildInputBox('Nama Anda', screenWidth),
                  SizedBox(height: 10), // Memberikan jarak antara input box
                  _buildInputBox('Username', screenWidth),
                  SizedBox(height: 10), // Memberikan jarak antara input box
                  _buildInputBox('Email', screenWidth),
                  SizedBox(height: 10), // Memberikan jarak antara input box
                  _buildInputBox('Password', screenWidth, isPassword: true),
                  SizedBox(height: 10), // Memberikan jarak antara input box
                  _buildInputBox('Konfirmasi Password', screenWidth,
                      isPassword: true),
                  SizedBox(
                      height:
                          20), // Memberikan jarak antara input box dan tombol login
                  ElevatedButton(
                    onPressed: () {
                      // Aksi yang dijalankan saat tombol ditekan
                    },
                    style: ElevatedButton.styleFrom(
                      primary: AppColors
                          .tombolLogin, // Warna latar belakang dari styles.dart
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text(
                        'Daftar',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight:
                              FontWeight.bold, // Menjadikan teks menjadi bold
                          color: AppColors
                              .hitam, // Menggunakan warna hitam dari styles.dart
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      height: 30), // Memberikan jarak antara tombol dan teks
                  // Widget teks dengan beberapa gaya
                  RichText(
                    text: TextSpan(
                      text: 'Sudah memiliki akun? ',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.hitam,
                      ),
                      children: [
                        TextSpan(
                            text: 'Login',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue, // Warna biru
                              fontStyle: FontStyle.italic, // Gaya miring
                              decoration:
                                  TextDecoration.underline, // Garis bawah
                            ),
                            // Definisikan aksi yang akan dilakukan ketika teks "Login" ditekan
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                );
                              }),
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

  Widget _buildInputBox(String labelText, double screenWidth,
      {bool isPassword = false}) {
    return Container(
      width: 800, // Mengatur lebar box agar memenuhi lebar layar
      height: 40, // Mengatur tinggi box sesuai keinginan Anda
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Color(0xFFD9D9D9), // Warna latar belakang abu-abu
        borderRadius: BorderRadius.circular(10), // Corner smoothing
      ),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: labelText, // Menggunakan labelText sebagai hintText
        ),
      ),
    );
  }
}
