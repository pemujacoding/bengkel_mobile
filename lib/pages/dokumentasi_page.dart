import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/dokumentasi_controller.dart';

class DokumentasiPage extends StatelessWidget {
  const DokumentasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DokumentasiController controller = Get.put(DokumentasiController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Dokumentasi Kendaraan",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Obx(
              () => Text(
                "Foto Kondisi Kendaraan (${controller.daftarFotoLokal.length} Foto)",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // AREA TAMPILAN BANYAK FOTO (GRID VIEW)
            Expanded(
              child: Obx(() {
                if (controller.daftarFotoLokal.isEmpty) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            size: 48,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Belum ada foto. Silakan ambil foto di bawah!",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Jika sudah ada isinya, tampilkan dalam bentuk Grid 2 Kolom
                return GridView.builder(
                  itemCount: controller.daftarFotoLokal.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Menampilkan 2 foto per baris
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1, // Kotak simetris (1:1)
                  ),
                  itemBuilder: (context, index) {
                    final fotoFile = controller.daftarFotoLokal[index];
                    return Stack(
                      children: [
                        // Foto Dokumentasi
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                            image: DecorationImage(
                              image: FileImage(fotoFile),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Tombol Hapus Pojok Kanan Atas Foto
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => controller.hapusFotoAt(index),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }),
            ),

            const SizedBox(height: 16),

            // TOMBOL AKSI SEPERTI SEBELUMNYA
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () => controller.ambilFoto(ImageSource.camera),
                    icon: const Icon(Icons.camera),
                    label: const Text("Kamera"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () => controller.ambilFoto(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text("Galeri"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
