import 'package:bengkel/controllers/notification_controller.dart';
import 'package:bengkel/pages/catatan_mekanik.dart';
import 'package:bengkel/pages/dokumentasi_page.dart';
import 'package:bengkel/pages/notification_page.dart';
import 'package:bengkel/pages/progress_service_page.dart';
import 'package:bengkel/pages/sparepart_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pelanggan_controller.dart';

class HomePage extends StatelessWidget {
  final PelangganController pelangganCtrl = Get.find<PelangganController>();
  final NotificationController notifCtrl = Get.put(NotificationController());
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 2,
        title: Obx(() {
          final user = pelangganCtrl.currentUser.value;
          String namaTampil = user != null ? user.username : 'Tamu';
          return Text(
            'Halo, $namaTampil',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          );
        }),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // ==================== TOMBOL LONCENG SAKTI ====================
          Obx(
            () => Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {
                    // Tandai sudah dibaca dan pindah ke halaman daftar notifikasi
                    notifCtrl.markAllAsRead();
                    Get.to(() => const NotificationPage());
                  },
                ),
                // Jika ada notifikasi belum dibaca, tampilkan lingkaran merah
                if (notifCtrl.unreadCount.value > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        "${notifCtrl.unreadCount.value}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildFeatureButton(
            title: "Sparepart",
            subtitle: "Lihat semua list sparepart tersedia",
            colors: [Colors.blue, Colors.lightBlue],
            icon: (Icons.settings),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SparepartPage()),
              );
            },
          ),
          _buildFeatureButton(
            title: "Foto",
            subtitle: "Ambil foto kondisi kendaraan",
            colors: [Colors.blue, Colors.lightBlue],
            icon: (Icons.camera),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DokumentasiPage(),
                ),
              );
            },
          ),
          _buildFeatureButton(
            title: "Catatan Mekanik",
            subtitle: "Catat saran dan feedback mekanik",
            colors: [Colors.blue, Colors.lightBlue],
            icon: (Icons.checklist),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CatatanMekanikPage(),
                ),
              );
            },
          ),
          _buildFeatureButton(
            title: "Progress Service",
            subtitle: "Catat progress service saat ini",
            colors: [Colors.blue, Colors.lightBlue],
            icon: (Icons.queue),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProgressServicePage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureButton({
    required String title,
    required String subtitle,
    required List<Color> colors,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Gambar/Icon Transparan di Latar Belakang
          Positioned(
            right: -10,
            bottom: -10,
            child: Icon(icon, size: 100, color: Colors.white.withOpacity(0.2)),
          ),
          // Konten Teks
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // InkWell diletakkan paling atas agar bisa diklik
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: onTap,
              ),
            ),
          ),
          // InkWell untuk klik efek
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: onTap,
            ),
          ),
        ],
      ),
    );
  }
}
