import 'package:bengkel/controllers/sparepart_controller.dart';
import 'package:bengkel/pages/detail_view_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Cukup import ini untuk GetX, hapus sub-import yang panjang

class SparepartPage extends StatelessWidget {
  const SparepartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SparepartController sparepartController = Get.put(
      SparepartController(),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 2,
        title: const Text(
          'Sparepart',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        // Menampilkan loading spinner jika sedang fetch data
        if (sparepartController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
            ),
          );
        }

        // Jika data dari API ternyata kosong
        if (sparepartController.sparepartList.isEmpty) {
          return const Center(
            child: Text(
              "Tidak ada sparepart tersedia.",
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        // Menampilkan list data jika sukses dimuat
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          itemCount: sparepartController.sparepartList.length,
          itemBuilder: (context, index) {
            final sparepart = sparepartController.sparepartList[index];

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                splashColor: Colors.blueAccent.withOpacity(0.1),
                highlightColor: Colors.blueAccent.withOpacity(0.05),
                onTap: () => Get.to(() => DetailViewPage(sparepart: sparepart)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          sparepart.gambar,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.broken_image,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sparepart.nama,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              sparepart.kategori.toUpperCase(),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Menampilkan mata uang Rupiah (Rp) karena data hargamu bertipe double lokal
                                Text(
                                  'Rp ${sparepart.harga.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Stok: ${sparepart.stok}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
}
