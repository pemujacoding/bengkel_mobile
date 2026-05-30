import 'package:flutter/material.dart';
import '../models/sparepart_model.dart';

class DetailViewPage extends StatelessWidget {
  final Sparepart sparepart;

  const DetailViewPage({super.key, required this.sparepart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Detail Sparepart',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Gambar Sparepart (Besar di Bagian Atas)
            Hero(
              tag:
                  'sparepart-${sparepart.id}', // Efek animasi smooth saat pindah halaman
              child: Image.network(
                sparepart.gambar,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: double.infinity,
                  height: 300,
                  color: Colors.grey.shade200,
                  child: const Icon(
                    Icons.broken_image,
                    size: 80,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),

            // 2. Konten Detail Informasi
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row untuk Kategori Badge & Stok Info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          sparepart.kategori.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      Text(
                        'Tersedia: ${sparepart.stok} Pcs',
                        style: TextStyle(
                          color: sparepart.stok > 0
                              ? Colors.green.shade700
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Nama Sparepart
                  Text(
                    sparepart.nama,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Harga Tertera
                  Text(
                    'Rp ${sparepart.harga.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Divider(thickness: 1),
                  ),

                  // Judul Deskripsi
                  const Text(
                    'Deskripsi Produk',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Teks Deskripsi (Jika di modelmu belum ada field deskripsi, bisa pakai teks default sementara ini)
                  const Text(
                    'Komponen sparepart original berkualitas tinggi yang didesain khusus untuk performa mesin motor optimal dan tahan lama. Sangat direkomendasikan untuk penggantian berkala guna menjaga kenyamanan berkendara Anda.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar sebagai area tombol Pesan/Gunakan
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Tombol Bookmark / Hubungi (Variasi Tambahan)
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(15),
              ),
              child: IconButton(
                icon: const Icon(Icons.chat_outlined, color: Colors.black87),
                onPressed: () {
                  // Tambahkan aksi chat atau tanya mekanik jika ada nanti
                },
              ),
            ),
            const SizedBox(width: 16),
            // Tombol Utama
            Expanded(
              child: SizedBox(
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 2,
                  ),
                  onPressed: sparepart.stok > 0
                      ? () {
                          // Logika ketika suku cadang dipilih untuk diservice
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${sparepart.nama} dipilih!'),
                            ),
                          );
                        }
                      : null, // Tombol mati otomatis kalau stok habis (0)
                  child: Text(
                    sparepart.stok > 0 ? 'PILIH SPAREPART' : 'STOK HABIS',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
