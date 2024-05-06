import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String dropdownValue = 'Opsi 1'; // default value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    height: 120,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/icons/profile.png'),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Saul Goodman, S.H.',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Hukum Perusahaan, Hukum Perdata',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'S1 Ilmu Hukum Universitas Indonesia',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pengalaman 5 Tahun',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 120),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Biaya Konsultasi',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '\Rp. 15.000', // Harga dapat disesuaikan sesuai kebutuhan
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Durasi Konsultasi',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '\60 Menit', // Harga dapat disesuaikan sesuai kebutuhan
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Potongan Harga',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '\Rp. -', // Harga dapat disesuaikan sesuai kebutuhan
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Pembayaran',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\Rp. 15.000', // Harga dapat disesuaikan sesuai kebutuhan
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Divider(
              color: const Color.fromARGB(255, 0, 0, 0),
              thickness: 1.0,
              height: 120, // tinggi garis
              indent: 0, // jarak dari kiri
              endIndent: 0, // jarak dari kanan
            ),
            SizedBox(height: 0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/icons/bank.png', // Ganti dengan path ke asset ikon kamu
                        width: 24, // Sesuaikan dengan ukuran ikon kamu
                        height: 24, // Sesuaikan dengan ukuran ikon kamu
                      ),
                      SizedBox(
                          width: 8), // Beri sedikit jarak antara ikon dan teks
                      Text(
                        'ATM/Bank Transfer', // Ubah teks sesuai kebutuhan
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.arrow_drop_down),
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'Metode Pembayaran',
                        child: Text('Metode Pembayaran'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/icons/wallet.png', // Ganti dengan path ke asset ikon kamu
                        width: 24, // Sesuaikan dengan ukuran ikon kamu
                        height: 24, // Sesuaikan dengan ukuran ikon kamu
                      ),
                      SizedBox(
                          width: 8), // Beri sedikit jarak antara ikon dan teks
                      Text(
                        'E-Wallet', // Ubah teks sesuai kebutuhan
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.arrow_drop_down),
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'Metode Pembayaran',
                        child: Text('Metode Pembayaran'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/icons/qris.png', // Ganti dengan path ke asset ikon kamu
                        width: 24, // Sesuaikan dengan ukuran ikon kamu
                        height: 24, // Sesuaikan dengan ukuran ikon kamu
                      ),
                      SizedBox(
                          width: 8), // Beri sedikit jarak antara ikon dan teks
                      Text(
                        'QRIS', // Ubah teks sesuai kebutuhan
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.arrow_drop_down),
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'Metode Pembayaran',
                        child: Text('Metode Pembayaran'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
