import 'package:flutter/material.dart';
import 'berandachat.dart';

class Lawyer {
  final String name;
  final String specialization;
  final String pengalaman;
  final String img;
  final String harga;

  Lawyer({
    required this.name,
    required this.specialization,
    required this.pengalaman,
    required this.img,
    required this.harga,
  });
}

class LawyerProfilePage extends StatelessWidget {
  final List<Lawyer> lawyers = [
    Lawyer(
      name: 'John Doe',
      specialization: 'Criminal Law',
      pengalaman: 'Pengalaman: 5 Tahun',
      img: 'images/w.jpeg',
      harga: 'Rp',
    ),
    Lawyer(
      name: 'Jane Smith',
      specialization: 'Family Law',
      pengalaman: 'Pengalaman: 5 Tahun',
      img: 'images/w.jpeg',
      harga: 'Rp',
    ),
    Lawyer(
      name: 'David Johnson',
      specialization: 'Corporate Law',
      pengalaman: 'Pengalaman: 5 Tahun',
      img: 'images/w.jpeg',
      harga: 'Rp',
    ),
    // Add more lawyers as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari kategori kasus anda',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
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
                          child: Image.network(
                            lawyer.img,
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          ),
                        ),
                      ),
                      title: Text(lawyer.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(lawyer.specialization),
                          Text(lawyer.pengalaman),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(lawyer.harga),
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
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromARGB(255, 238, 17, 1), // Atur warna latar belakang menjadi merah
        padding: EdgeInsets.zero, // Hapus padding default
        child : Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                // Tambahkan logika untuk menavigasi ke halaman yang diinginkan
              },
              child: Image.asset(
                'images/home.png', // Ganti 'images/home.png' dengan path gambar Anda
                width: 35, // Ganti nilai sesuai dengan lebar yang diinginkan
                height: 35, // Ganti nilai sesuai dengan tinggi yang diinginkan
                fit: BoxFit.contain, // Mengatur bagaimana gambar diatur dalam kotak yang diberikan
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
                'images/chat.png', // Ganti 'images/home.png' dengan path gambar Anda
                width: 50, // Ganti nilai sesuai dengan lebar yang diinginkan
                height: 50, // Ganti nilai sesuai dengan tinggi yang diinginkan
                fit: BoxFit.contain, // Mengatur bagaimana gambar diatur dalam kotak yang diberikan
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
                height: 35, // Ganti nilai sesuai dengan tinggi yang diinginkan
                fit: BoxFit.contain, // Mengatur bagaimana gambar diatur dalam kotak yang diberikan
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
                'images/profile.png', // Ganti 'images/home.png' dengan path gambar Anda
                width: 35, // Ganti nilai sesuai dengan lebar yang diinginkan
                height: 35, // Ganti nilai sesuai dengan tinggi yang diinginkan
                fit: BoxFit.contain, // Mengatur bagaimana gambar diatur dalam kotak yang diberikan
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }
}
