import 'package:bengkel/pages/detail_riwayat_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/riwayat_service_controller.dart';
import '../models/kendaraan_model.dart';

class RiwayatServicePage extends StatelessWidget {
  final Kendaraan kendaraan;

  const RiwayatServicePage({super.key, required this.kendaraan});

  @override
  Widget build(BuildContext context) {
    // Inject Riwayat Controller
    final RiwayatServiceController riwayatCtrl = Get.put(
      RiwayatServiceController(),
    );

    // Langsung panggil data riwayat sesuai ID kendaraan saat halaman dibuka
    riwayatCtrl.fetchRiwayatByKendaraan(kendaraan.id);
    List<String> namaBulan = [
      "",
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember",
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Riwayat ${kendaraan.merk}",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (riwayatCtrl.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.blueAccent),
          );
        }

        if (riwayatCtrl.riwayatList.isEmpty) {
          return const Center(
            child: Text(
              "Kendaraan ini belum memiliki riwayat service.",
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: riwayatCtrl.riwayatList.length,
          itemBuilder: (context, index) {
            final riwayat = riwayatCtrl.riwayatList[index];
            DateTime tanggalParsingan = DateTime.parse(
              riwayat.tanggal,
            ).toLocal();
            String tanggalCantik =
                "${tanggalParsingan.day} ${namaBulan[tanggalParsingan.month]} ${tanggalParsingan.year}";
            String jamCantik =
                "${tanggalParsingan.hour.toString().padLeft(2, '0')}:${tanggalParsingan.minute.toString().padLeft(2, '0')}";
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Get.to(() => DetailRiwayatPage(riwayat: riwayat));
                },
                child: ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  title: Text(
                    "$tanggalCantik  |  $jamCantik WIB",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Keluhan: ${riwayat.keluhan ?? 'Service Berkala'}",
                  ),

                  trailing: Text(
                    riwayat.status,
                    style: TextStyle(
                      color: riwayat.status == 'selesai'
                          ? Colors.green
                          : Colors.orangeAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
