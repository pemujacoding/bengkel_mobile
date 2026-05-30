import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notification_controller.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationController notifCtrl = Get.find<NotificationController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Pemberitahuan",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (notifCtrl.notificationList.isEmpty) {
          return const Center(
            child: Text(
              "Belum ada riwayat pemberitahuan.",
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: notifCtrl.notificationList.length,
          itemBuilder: (context, index) {
            final item = notifCtrl.notificationList[index];
            DateTime tgl = DateTime.parse(item['tanggal']);

            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.black12,
                  child: Icon(Icons.build, color: Colors.black),
                ),
                title: Text(
                  item['title'] ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(item['body'] ?? ''),
                    const SizedBox(height: 6),
                    Text(
                      "${tgl.day}-${tgl.month}-${tgl.year} | Jam 10:00 WIB",
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                  onPressed: () => notifCtrl.deleteNotif(item['id']),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
