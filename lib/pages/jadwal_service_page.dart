import 'package:bengkel/models/jadwal_service_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/jadwal_service_controller.dart';

class JadwalServicePage extends StatelessWidget {
  final int kendaraanId;
  const JadwalServicePage({super.key, required this.kendaraanId});

  @override
  Widget build(BuildContext context) {
    // Gunakan tag unik atau pastikan fetch dipanggil saat halaman dirender
    final JadwalServiceController controller = Get.put(
      JadwalServiceController(),
    );

    // Panggil fetch data secara mandiri berdasarkan ID mutlak dari konstruktor halaman
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchJadwal(kendaraanId);
    });

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Kelola Jadwal Service",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.blueAccent),
          );
        }

        if (controller.jadwalList.isEmpty) {
          return const Center(
            child: Text("Belum ada jadwal terdaftar. Buat sekarang!"),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.jadwalList.length,
          itemBuilder: (context, index) {
            final item = controller.jadwalList[index];
            DateTime date = DateTime.parse(item.tanggal.toString());

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const Icon(
                  Icons.calendar_today,
                  color: Colors.blueAccent,
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.judul,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${date.day}-${date.month}-${date.year}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text("Deskripsi: ${item.deskripsi}"),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      onPressed: () => _showJadwalForm(
                        context,
                        controller,
                        existingData: item,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () =>
                          controller.hapusJadwal(item.id, kendaraanId),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showJadwalForm(context, controller),
      ),
    );
  }

  // FORM INPUT DIALOG UNTUK TAMBAH / EDIT JADWAL
  void _showJadwalForm(
    BuildContext context,
    JadwalServiceController controller, {
    JadwalService? existingData, // Ubah dari dynamic ke model objek aslinya
  }) {
    // SINKRONISASI FIELD DATA INPUT
    final judulController = TextEditingController(
      text: existingData != null ? existingData.judul : '',
    );
    final deskripsiController = TextEditingController(
      text: existingData != null ? existingData.deskripsi : '',
    );

    DateTime selectedDate = existingData != null
        ? DateTime.parse(existingData.tanggal.toString())
        : DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                existingData == null
                    ? "Tambah Jadwal Baru"
                    : "Edit Jadwal Service",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // INPUTAN 1: JUDUL JADWAL
              TextField(
                controller: judulController,
                decoration: const InputDecoration(
                  labelText: "Judul Jadwal (Contoh: Service Rutin)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              // INPUTAN 2: DESKRIPSI KELUHAN
              TextField(
                controller: deskripsiController,
                decoration: const InputDecoration(
                  labelText: "Deskripsi Keluhan Kendaraan",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // TOMBOL PILIH TANGGAL
              StatefulBuilder(
                builder: (context, setModalState) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tanggal: ${selectedDate.day}-${selectedDate.month}-${selectedDate.year}",
                        style: const TextStyle(fontSize: 15),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            setModalState(() => selectedDate = picked);
                          }
                        },
                        child: const Text("Pilih Tanggal"),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50, // [cite: 70]
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ), // [cite: 71]
                  onPressed: () {
                    final dataBody = {
                      "id_kendaraan": kendaraanId,
                      "judul": judulController.text,
                      "tanggal": selectedDate.toIso8601String(),
                      "deskripsi": deskripsiController.text,
                      "status": "proses",
                    }; // [cite: 72, 73]

                    if (existingData == null) {
                      // 💡 Kirim kendaraanId ke parameter ketiga
                      controller.tambahJadwal(
                        dataBody,
                        selectedDate,
                        kendaraanId,
                      );
                    } else {
                      // 💡 Kirim kendaraanId ke parameter keempat
                      controller.editJadwal(
                        existingData.id,
                        dataBody,
                        selectedDate,
                        kendaraanId,
                      );
                    }
                  },
                  child: Text(
                    existingData == null ? "SIMPAN JADWAL" : "PERBARUI JADWAL",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ), // [cite: 76, 77]
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
