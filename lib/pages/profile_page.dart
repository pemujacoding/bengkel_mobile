import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pelanggan_controller.dart';

class ProfilePage extends StatelessWidget {
  final PelangganController pelangganCtrl = Get.find<PelangganController>();

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 2,
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          // 🚪 TOMBOL LOGOUT (Membasmi sisa state lama dengan aman)
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            onPressed: () => _tampilkanDialogKonfirmasi(
              context: context,
              title: "Logout Akun",
              content: "Apakah Anda yakin ingin keluar dari aplikasi?",
              confirmText: "Keluar",
              confirmColor: Colors.orange,
              onConfirm: () => pelangganCtrl.logout(),
            ),
          ),
        ],
      ),
      // Obx Utama untuk memantau status Loading global dari controller
      body: Obx(() {
        if (pelangganCtrl.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.blueAccent),
          );
        }

        final user = pelangganCtrl.currentUser.value;

        // Cegah error jika sewaktu-waktu data user kosong/null
        if (user == null) {
          return const Center(child: Text("Gagal memuat data pengguna."));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              // Avatar Icon Besar
              const Icon(
                Icons.account_circle_rounded,
                size: 100,
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 12),

              // Username Utama
              Text(
                user.username,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "ID Pelanggan: #${user.id}",
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 24),

              // =======================================================
              // CARD DISPLAY DATA LENGKAP PELANGGAN (READ)
              // =======================================================
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildProfileItem(
                        Icons.person,
                        "Nama Lengkap",
                        user.nama,
                      ),
                      const Divider(),
                      _buildProfileItem(
                        Icons.phone,
                        "Nomor Telepon",
                        user.noTelp,
                      ),
                      const Divider(),
                      _buildProfileItem(
                        Icons.location_on,
                        "Alamat Rumah",
                        user.alamat,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // =======================================================
              // ACTION BUTTONS (UPDATE & DELETE)
              // =======================================================

              // 1. Tombol Edit Profil (UPDATE)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.edit_note_rounded),
                  label: const Text(
                    "EDIT PROFIL SAYA",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => _tampilkanBottomSheetEdit(context, user),
                ),
              ),
              const SizedBox(height: 12),

              // 2. Tombol Hapus Akun (DELETE)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.delete_forever_rounded),
                  label: const Text(
                    "HAPUS AKUN PERMANEN",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => _tampilkanDialogKonfirmasi(
                    context: context,
                    title: "Hapus Akun Anda?",
                    content:
                        "Tindakan ini permanen. Semua riwayat, catatan lokal, dan data Anda di server akan dihapus dari aplikasi.",
                    confirmText: "Ya, Hapus",
                    confirmColor: Colors.red,
                    onConfirm: () => pelangganCtrl.hapusAkun(user.id),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // ===========================================================================
  // WIDGET HELPER: Komponen Baris Data Profil
  // ===========================================================================
  Widget _buildProfileItem(IconData icon, String judul, String isi) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent.shade200, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  judul,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  isi.isNotEmpty ? isi : "-",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // FORM BOTTOM SHEET: Input Pembaruan Data (UPDATE)
  // ===========================================================================
  void _tampilkanBottomSheetEdit(BuildContext context, dynamic user) {
    // Controller teks diisi otomatis dengan data lama user saat ini
    final namaController = TextEditingController(text: user.nama);
    final teleponController = TextEditingController(text: user.noTelp);
    final alamatController = TextEditingController(text: user.alamat);

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Perbarui Profil Lokal & Server",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: "Nama Lengkap",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: teleponController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Nomor Telepon",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: alamatController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: "Alamat Rumah",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (namaController.text.trim().isEmpty ||
                        teleponController.text.trim().isEmpty ||
                        alamatController.text.trim().isEmpty) {
                      Get.snackbar(
                        "Peringatan",
                        "Semua kolom data wajib diisi!",
                      );
                      return;
                    }

                    // Susun Map data baru untuk dikirim ke API PelangganService
                    Map<String, dynamic> dataUpdate = {
                      "username": user
                          .username, // Tetap sertakan field bawaan model jika diperlukan API
                      "nama": namaController.text.trim(),
                      "no_telp": teleponController.text.trim(),
                      "alamat": alamatController.text.trim(),
                    };

                    // Jalankan fungsi edit dari PelangganController kamu
                    pelangganCtrl.editProfile(user.id, dataUpdate);
                    Get.back(); // Tutup form bottom sheet
                  },
                  child: const Text(
                    "SIMPAN PERUBAHAN",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  // ===========================================================================
  // DIALOG HELPER: Dialog Konfirmasi Aksi Krusial
  // ===========================================================================
  void _tampilkanDialogKonfirmasi({
    required BuildContext context,
    required String title,
    required String content,
    required String confirmText,
    required Color confirmColor,
    required VoidCallback onConfirm,
  }) {
    Get.defaultDialog(
      title: title,
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Text(
          content,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
        ),
      ),
      textCancel: "Batal",
      textConfirm: confirmText,
      confirmTextColor: Colors.white,
      buttonColor: confirmColor,
      onConfirm: () {
        Get.back(); // Tutup dialog
        onConfirm(); // Jalankan aksi asli
      },
    );
  }
}
