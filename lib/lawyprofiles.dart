import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'userProfiles.dart';

class Lawyer {
  final String name;
  final String pendidikan;
  final String semester;
  final String statuskelulusan;
  // final String img;
  // final String harga;

  Lawyer({
    required this.name,
    required this.pendidikan,
    required this.semester,
    required this.statuskelulusan,
    // required this.img,
    // required this.harga,
  });

  factory Lawyer.fromJson(Map<String, dynamic> json) {
    return Lawyer(
      name: json['name'],
      pendidikan: json['pendidikan'],
      semester: json['semester'],
      statuskelulusan: json['statuskelulusan'],
      // img: json['img'],
      // harga: json['harga'],
    );
  }
}

class User {
  final String name;

  User({required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
    );
  }
}

class LawyerProfilePage extends StatefulWidget {
  @override
  _LawyerProfilePageState createState() => _LawyerProfilePageState();
}

class _LawyerProfilePageState extends State<LawyerProfilePage> {
  late Future<List<Lawyer>> _futureLawyers;
  late User user; // Tambahkan variabel user

  @override
  void initState() {
    super.initState();
    _futureLawyers = fetchLawyers();
    user = User(
        name:
            'User'); // Inisialisasi user, Anda perlu mengambil nama pengguna yang sebenarnya dari backend
  }

  Future<List<Lawyer>> fetchLawyers() async {
    final response =
        await http.get(Uri.parse('http://localhost:8000/api/lawyers'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> lawyerData = data['lawyers'];
      return lawyerData.map((json) => Lawyer.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load lawyers');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<Lawyer>>(
        future: _futureLawyers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final lawyers = snapshot.data!;
            return ListView.builder(
              itemCount: lawyers.length,
              itemBuilder: (context, index) {
                final lawyer = lawyers[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 40,
                        child: ClipOval(
                            // child: Image.network(
                            //   // lawyer.img,
                            //   fit: BoxFit.cover,
                            //   width: 100,
                            //   height: 100,
                            // ),
                            ),
                      ),
                      title: Text(lawyer.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Welcome ${user.name}'),
                          Text(lawyer.pendidikan),
                          Text(lawyer.semester),
                          Text(lawyer.statuskelulusan),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            // child: Text(lawyer.harga),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.chat),
                        onPressed: () {
                          // Navigate to chat page
                          // You can add navigation logic here
                        },
                      ),
                      onTap: () {
                        // Handle tapping on a lawyer profile
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromARGB(
            255, 238, 17, 1), // Atur warna latar belakang menjadi merah
        padding: EdgeInsets.zero, // Hapus padding default
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            LawyerProfilePage()), // Navigasi ke halaman hh.dart
                  );
                },
                child: Image.asset(
                  'images/home.png', // Ganti 'images/home.png' dengan path gambar Anda
                  width: 35, // Ganti nilai sesuai dengan lebar yang diinginkan
                  height:
                      35, // Ganti nilai sesuai dengan tinggi yang diinginkan
                  fit: BoxFit
                      .contain, // Mengatur bagaimana gambar diatur dalam kotak yang diberikan
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
                  'images/chat.png', // Ganti 'images/home.png' dengan path gambar Anda
                  width: 50, // Ganti nilai sesuai dengan lebar yang diinginkan
                  height:
                      50, // Ganti nilai sesuai dengan tinggi yang diinginkan
                  fit: BoxFit
                      .contain, // Mengatur bagaimana gambar diatur dalam kotak yang diberikan
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
                  'images/notif.png', // Ganti 'images/home.png' dengan path gambar Anda
                  width: 35, // Ganti nilai sesuai dengan lebar yang diinginkan
                  height:
                      35, // Ganti nilai sesuai dengan tinggi yang diinginkan
                  fit: BoxFit
                      .contain, // Mengatur bagaimana gambar diatur dalam kotak yang diberikan
                ),
              ),
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserProfile()),
                  );
                },
                child: Image.asset(
                  'images/profile.png', // Ganti 'images/home.png' dengan path gambar Anda
                  width: 35, // Ganti nilai sesuai dengan lebar yang diinginkan
                  height:
                      35, // Ganti nilai sesuai dengan tinggi yang diinginkan
                  fit: BoxFit
                      .contain, // Mengatur bagaimana gambar diatur dalam kotak yang diberikan
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
