import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/riwayat_service_model.dart';
import '../controllers/sparepart_digunakan_controller.dart';

class DetailRiwayatPage extends StatelessWidget {
  final RiwayatService riwayat;

  const DetailRiwayatPage({super.key, required this.riwayat});

  @override
  Widget build(BuildContext context) {
    // Inject Controller Sparepart Digunakan
    final SparepartDigunakanController sparepartCtrl = Get.put(
      SparepartDigunakanController(),
    );

    // Panggil data sparepart berdasarkan ID riwayat service ini
    sparepartCtrl.fetchSparepartDigunakan(riwayat.id);

    // Format tanggal lokal (seperti trik kemarin)
    DateTime tanggalParsingan = DateTime.parse(riwayat.tanggal).toLocal();
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
    String tanggalCantik =
        "${tanggalParsingan.day} ${namaBulan[tanggalParsingan.month]} ${tanggalParsingan.year}";

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Rincian Service',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================== KARTU RINGKASAN SERVICE ====================
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          tanggalCantik,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: riwayat.status == 'selesai'
                                ? Colors.green.withOpacity(0.1)
                                : Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            riwayat.status.toUpperCase(),
                            style: TextStyle(
                              color: riwayat.status == 'selesai'
                                  ? Colors.green
                                  : Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    const Text(
                      'Keluhan:',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    Text(
                      riwayat.keluhan,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Tindakan Pelayanan:',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    Text(
                      riwayat.pelayanan,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ==================== DAFTAR SPAREPART YANG DIGUNAKAN ====================
            const Text(
              'Sparepart Yang Digunakan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),

            Obx(() {
              if (sparepartCtrl.isLoading.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(color: Colors.blueAccent),
                  ),
                );
              }

              if (sparepartCtrl.spareparDigunakantList.isEmpty) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        "Tidak ada penggantian sparepart pada service ini.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                );
              }

              // Hitung total biaya sparepart secara otomatis
              double totalBiayaSparepart = 0;
              for (var item in sparepartCtrl.spareparDigunakantList) {
                totalBiayaSparepart += item.sparepart.harga * item.jumlah;
              }

              return Column(
                children: [
                  // List item sparepart
                  ListView.builder(
                    shrinkWrap:
                        true, // Agar bisa masuk ke dalam SingleChildScrollView
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: sparepartCtrl.spareparDigunakantList.length,
                    itemBuilder: (context, index) {
                      final item = sparepartCtrl.spareparDigunakantList[index];
                      final sp = item.sparepart;
                      double subTotal = sp.harga * item.jumlah;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              sp.gambar,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => Container(
                                width: 50,
                                height: 50,
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.broken_image),
                              ),
                            ),
                          ),
                          title: Text(
                            sp.nama,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "Rp ${sp.harga.toStringAsFixed(0)} x ${item.jumlah}",
                          ),
                          trailing: Text(
                            "Rp ${subTotal.toStringAsFixed(0)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Ringkasan Total Biaya Sparepart di bagian paling bawah list
                  Card(
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Biaya Sparepart',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Rp ${totalBiayaSparepart.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Colors.greenAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
