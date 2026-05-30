import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/catatan_service_controller.dart';

class CatatanMekanikPage extends StatelessWidget {
  const CatatanMekanikPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CatatanServiceController controller = Get.put(
      CatatanServiceController(),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Catatan Mekanik",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.daftarCatatanMekanik.isEmpty) {
            return const Center(child: Text("Belum ada catatan dari mekanik."));
          }
          return ListView.builder(
            itemCount: controller.daftarCatatanMekanik.length,
            itemBuilder: (context, index) {
              final item = controller.daftarCatatanMekanik[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                color: Colors.blue.shade50,
                child: ListTile(
                  title: Text(
                    item['tanggal'],
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Text(
                      item['catatan'],
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 💡 TOMBOL EDIT CATATAN MEKANIK
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () => _dialogInputCatatan(
                          context,
                          controller,
                          existingData: item,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => controller.hapusCatatan(item['id']),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(Icons.note_add, color: Colors.white),
        onPressed: () => _dialogInputCatatan(context, controller),
      ),
    );
  }

  // 💡 DIALOG EDIT & TAMBAH CATATAN DIJADIKAN SATU FUNGSI PINTAR
  void _dialogInputCatatan(
    BuildContext context,
    CatatanServiceController controller, {
    Map<String, dynamic>? existingData,
  }) {
    final inputController = TextEditingController(
      text: existingData != null ? existingData['catatan'] : '',
    );
    Get.defaultDialog(
      title: existingData == null ? "Tambah Catatan Baru" : "Ubah Catatan",
      content: TextField(
        controller: inputController,
        maxLines: 3,
        decoration: const InputDecoration(
          hintText: "Tulis temuan mekanik atau daftar part di sini...",
        ),
      ),
      textConfirm: existingData == null ? "Simpan" : "Perbarui",
      confirmTextColor: Colors.white,
      onConfirm: () {
        if (inputController.text.isNotEmpty) {
          if (existingData == null) {
            controller.tambahCatatan(inputController.text);
          } else {
            controller.ubahCatatan(
              existingData['id'],
              inputController.text,
              existingData['tanggal'],
            );
          }
          Get.back();
        }
      },
    );
  }
}
