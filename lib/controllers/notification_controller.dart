import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/hive_service.dart';
import 'pelanggan_controller.dart'; // 💡 Import file PelangganController kamu

class NotificationController extends GetxController {
  var unreadCount = 0.obs;
  var notificationList = <dynamic>[].obs;
  final Box _box = HiveService.getNotificationBox();

  final PelangganController _pelangganController =
      Get.find<PelangganController>();
  int get _idPelangganAktif => _pelangganController.currentUser.value?.id ?? 0;

  @override
  void onInit() {
    super.onInit();
    getNotifications();

    // Dengarkan perubahan Box Hive secara realtime.
    _box.listenable().addListener(() {
      getNotifications();
    });
  }

  void getNotifications() {
    // 1. 💡 FILTER: Hanya ambil data dari Hive yang id_pelanggan-nya cocok dengan yang sedang login
    final rawData = _box.values.where((item) {
      return item != null && item['id_pelanggan'] == _idPelangganAktif;
    }).toList();

    // 2. Urutkan dari yang paling baru
    notificationList.assignAll(rawData.reversed.toList());

    // 3. Hitung berapa data milik user ini yang 'isRead' nya masih false
    int count = rawData.where((item) => item['isRead'] == false).length;
    unreadCount.value = count;
  }

  // Fungsi untuk menandai semua notifikasi milik user ini sudah dibaca
  void markAllAsRead() async {
    for (var key in _box.keys) {
      var item = _box.get(key);

      // 💡 FILTER TAMBAHAN: Pastikan hanya mengubah data milik user yang sedang login
      if (item != null &&
          item['id_pelanggan'] == _idPelangganAktif &&
          item['isRead'] == false) {
        item['isRead'] = true;
        await _box.put(key, item);
      }
    }
    getNotifications();
  }

  // Fungsi hapus satu notifikasi dari riwayat
  void deleteNotif(int id) async {
    await _box.delete(id);
    // getNotifications(); // Otomatis terpanggil oleh listener di onInit
  }
}
