import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/catatan_service_controller.dart';

class ProgressServicePage extends StatelessWidget {
  const ProgressServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final CatatanServiceController controller = Get.put(
      CatatanServiceController(),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Progress Service",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.daftarProgress.isEmpty) {
            return const Center(
              child: Text("Belum ada riwayat update progress."),
            );
          }
          return ListView.builder(
            itemCount: controller.daftarProgress.length,
            itemBuilder: (context, index) {
              final item = controller.daftarProgress[index];
              double percent = (double.tryParse(item['progress']) ?? 0) / 100;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Tanggal: ${item['tanggal']}",
                            style: const TextStyle(color: Colors.grey),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // 💡 TOMBOL EDIT PROGRESS
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.orange,
                                  size: 20,
                                ),
                                onPressed: () => _dialogInputProgress(
                                  context,
                                  controller,
                                  existingData: item,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                onPressed: () =>
                                    controller.hapusProgress(item['id']),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: percent,
                              backgroundColor: Colors.grey.shade200,
                              color: Colors.blueAccent,
                              minHeight: 10,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "${item['progress']}%",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
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
        child: const Icon(Icons.speed, color: Colors.white),
        onPressed: () => _dialogInputProgress(context, controller),
      ),
    );
  }

  // 💡 DIALOG EDIT & TAMBAH PROGRESS DIJADIKAN SATU FUNGSI PINTAR
  void _dialogInputProgress(
    BuildContext context,
    CatatanServiceController controller, {
    Map<String, dynamic>? existingData,
  }) {
    final inputController = TextEditingController(
      text: existingData != null ? existingData['progress'] : '',
    );
    Get.defaultDialog(
      title: existingData == null ? "Update Progress (%)" : "Ubah Progress (%)",
      content: TextField(
        controller: inputController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          hintText: "Masukkan angka 0 - 100",
          suffixText: "%",
        ),
      ),
      textConfirm: existingData == null ? "Simpan" : "Perbarui",
      confirmTextColor: Colors.white,
      onConfirm: () {
        if (inputController.text.isNotEmpty) {
          if (existingData == null) {
            controller.tambahProgress(inputController.text);
          } else {
            controller.ubahProgress(
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
