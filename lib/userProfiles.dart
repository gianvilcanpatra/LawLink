import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'lawyprofiles.dart';
import 'berandachat.dart';
import 'login.dart';
import 'dart:convert';

class UserProfile extends StatefulWidget {
  final String authToken;

  UserProfile({required this.authToken});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/api/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.authToken}',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          userData = json.decode(response.body);
        });
      } else {
        print('Failed to load user data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('User Profile'),
          backgroundColor: Colors.red,
        ),
        body: userData == null
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    title: Text('Nama: ${userData!['name']}'),
                    subtitle: Text('Email: ${userData!['email']}'),
                    trailing: Icon(Icons.edit),
                  ),
                  ListTile(
                    leading: Icon(Icons.track_changes),
                    title: Text('Riwayat Transaksi'),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.lock),
                    title: Text('Ubah kata sandi'),
                  ),
                  ListTile(
                    leading: Icon(Icons.info),
                    title: Text('Pusat bantuan informasi'),
                  ),
                  ListTile(
                    leading: Icon(Icons.delete),
                    title: Text('Hapus akun'),
                  ),
                  ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text('Keluar akun'),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                  ),
                ],
              ),
        bottomNavigationBar: BottomAppBar(
          color: Color.fromARGB(255, 238, 17, 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LawyerProfilePage()),
                    );
                  },
                  child: Image.asset(
                    'images/home.png',
                    width: 35,
                    height: 35,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LawyerChatPage()),
                    );
                  },
                  child: Image.asset(
                    'images/chat.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    // Tambahkan logika untuk menavigasi ke halaman yang diinginkan
                  },
                  child: Image.asset(
                    'images/notif.png',
                    width: 35,
                    height: 35,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    // Tambahkan logika untuk menavigasi ke halaman yang diinginkan
                  },
                  child: Image.asset(
                    'images/profile.png',
                    width: 35,
                    height: 35,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}