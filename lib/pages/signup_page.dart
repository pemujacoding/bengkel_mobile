import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pelanggan_controller.dart';

class SignupPage extends StatelessWidget {
  final PelangganController pelangganController =
      Get.find<PelangganController>();

  // Menggunakan controller terpisah untuk menampung input registrasi
  final TextEditingController namaController = TextEditingController();
  final TextEditingController telpController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.app_registration,
                color: Colors.blueAccent,
                size: 80,
              ),
              const SizedBox(height: 10),
              const Text(
                "Buat Akun Baru",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Text(
                "Lengkapi data diri Anda untuk mendaftar",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 30),

              // 1. Input Nama Lengkap
              TextField(
                controller: namaController,
                decoration: _buildInputDecoration(
                  "Nama Lengkap",
                  Icons.badge_outlined,
                ),
              ),
              const SizedBox(height: 16),

              // 2. Input Nomor Telepon
              TextField(
                controller: telpController,
                keyboardType: TextInputType.phone,
                decoration: _buildInputDecoration(
                  "No. Telepon",
                  Icons.phone_android_outlined,
                ),
              ),
              const SizedBox(height: 16),

              // 3. Input Alamat Rumah
              TextField(
                controller: alamatController,
                maxLines: 2,
                decoration: _buildInputDecoration(
                  "Alamat Rumah",
                  Icons.home_outlined,
                ),
              ),
              const SizedBox(height: 16),

              // 4. Input Username
              TextField(
                controller: userController,
                decoration: _buildInputDecoration(
                  "Username",
                  Icons.person_outline,
                ),
              ),
              const SizedBox(height: 16),

              // 5. Input Password
              TextField(
                controller: passController,
                obscureText: true,
                decoration: _buildInputDecoration(
                  "Password",
                  Icons.lock_outline,
                ),
              ),
              const SizedBox(height: 30),

              // Tombol Proses Daftar
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () async {
                    // Validasi sederhana agar form tidak kosong
                    if (namaController.text.isEmpty ||
                        telpController.text.isEmpty ||
                        alamatController.text.isEmpty ||
                        userController.text.isEmpty ||
                        passController.text.isEmpty) {
                      Get.snackbar('Peringatan', 'Semua data wajib diisi!');
                      return;
                    }

                    // Pengecekan ketersediaan username ke API
                    bool usernameTerpakai = await pelangganController
                        .isUsernameTaken(userController.text);

                    if (usernameTerpakai) {
                      Get.snackbar(
                        'Gagal',
                        'Username sudah digunakan, cari nama lain!',
                      );
                    } else {
                      // Bungkus data menjadi objek Map untuk dikirim ke registerUser
                      Map<String, dynamic> dataBaru = {
                        "nama": namaController.text,
                        "no_telp": telpController.text,
                        "alamat": alamatController.text,
                        "username": userController.text,
                        "password": passController
                            .text, // Nanti otomatis ter-hash di controller
                      };

                      pelangganController.registerUser(dataBaru);
                    }
                  },
                  child: const Text(
                    'DAFTAR SEKARANG',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper agar tidak menulis ulang kode hiasan textfield
  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      floatingLabelStyle: const TextStyle(color: Colors.blueAccent),
      prefixIcon: Icon(icon, color: Colors.blueAccent),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
      ),
    );
  }
}
