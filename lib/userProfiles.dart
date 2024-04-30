import 'package:flutter/material.dart';

// void main() {
//   runApp(UserProfile());
// }

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
        ),
        body: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text('Gian Vilcan Patra'),
              subtitle: Text('g.n@gmail.com'),
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
            ),
          ],
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
                    // Tambahkan logika untuk menavigasi ke halaman yang diinginkan
                  },
                  child: Image.asset(
                    'images/home.png', // Ganti 'images/home.png' dengan path gambar Anda
                    width:
                        35, // Ganti nilai sesuai dengan lebar yang diinginkan
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
                    width:
                        50, // Ganti nilai sesuai dengan lebar yang diinginkan
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
                    width:
                        35, // Ganti nilai sesuai dengan lebar yang diinginkan
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
                    'images/profile.png', // Ganti 'images/home.png' dengan path gambar Anda
                    width:
                        35, // Ganti nilai sesuai dengan lebar yang diinginkan
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
      ),
    );
  }
}
