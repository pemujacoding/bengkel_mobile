import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/kendaraan_controller.dart';
import 'riwayat_service_page.dart';
import 'jadwal_service_page.dart'; // Jangan lupa import halaman jadwalnya ya

class KendaraanPage extends StatelessWidget {
  const KendaraanPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject KendaraanController
    final KendaraanController kendaraanCtrl = Get.put(KendaraanController());

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 2,
        title: const Text(
          'Garasi Motor Saya',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (kendaraanCtrl.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.blueAccent),
          );
        }

        if (kendaraanCtrl.kendaraanList.isEmpty) {
          return const Center(
            child: Text(
              "Belum ada kendaraan terdaftar.",
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: kendaraanCtrl.kendaraanList.length,
          itemBuilder: (context, index) {
            final kendaraan = kendaraanCtrl.kendaraanList[index];

            return Card(
              margin: const EdgeInsets.only(bottom: 14),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () {
                  // PANGGIL FUNGSI BOTTOM SHEET DI SINI
                  _showMenuBottomSheet(context, kendaraan);
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Lingkaran Icon Motor
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.motorcycle,
                          color: Colors.blueAccent,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Detail Teks Kendaraan
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              kendaraan.merk,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "No. Polisi: ${kendaraan.plat}",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  // ==================== FUNGSI BOTTOM SHEET TERPISAH ====================
  void _showMenuBottomSheet(BuildContext context, dynamic kendaraan) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Garis kecil estetik di atas bottom sheet
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Text(
              "Menu Kendaraan: ${kendaraan.merk}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // PILIHAN 1: RIWAYAT SERVICE
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green.withOpacity(0.1),
                child: const Icon(Icons.history, color: Colors.green),
              ),
              title: const Text(
                "Riwayat Service",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text("Lihat catatan service yang sudah selesai"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () {
                Get.back(); // Tutup bottom sheet
                Get.to(() => RiwayatServicePage(kendaraan: kendaraan));
              },
            ),
            const Divider(),

            // PILIHAN 2: KELOLA JADWAL SERVICE
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blueAccent.withOpacity(0.1),
                child: const Icon(
                  Icons.calendar_month,
                  color: Colors.blueAccent,
                ),
              ),
              title: const Text(
                "Jadwal Service",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                "Buat, edit, dan lihat jadwal service mendatang",
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () {
                Get.back(); // Tutup bottom sheet
                Get.to(() => JadwalServicePage(kendaraanId: kendaraan.id));
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
