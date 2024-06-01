import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'userProfiles.dart';
import 'detailLawyer.dart';
import 'providers/auth_provider.dart';

class Lawyer {
  final int id;
  final String name;
  final String pendidikan;
  final String semester;
  final String statuskelulusan;
  final String deskripsi;

  Lawyer({
    required this.id,
    required this.name,
    required this.pendidikan,
    required this.semester,
    required this.statuskelulusan,
    required this.deskripsi,
  });

  factory Lawyer.fromJson(Map<String, dynamic> json) {
    return Lawyer(
      id: json['id'],
      name: json['name'],
      pendidikan: json['pendidikan'],
      semester: json['semester'],
      statuskelulusan: json['statuskelulusan'],
      deskripsi: json['deskripsi'],
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
  late User user;

  @override
  void initState() {
    super.initState();
    _futureLawyers = fetchLawyers();
    user = User(name: 'User');
  }

  Future<List<Lawyer>> fetchLawyers() async {
    final response = await http.get(Uri.parse('http://localhost:8000/api/lawyers'));
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
    final authProvider = Provider.of<AuthProvider>(context);

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
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.chat),
                        onPressed: () {
                          // Navigate to chat page
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DetailLawyer(lawyer: lawyer)),
                        );
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
                  // Navigate to chat page
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
                  // Navigate to notification page
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfile(authToken: authProvider.token!),
                    ),
                  );
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
    );
  }
}
