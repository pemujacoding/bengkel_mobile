import 'package:bengkel/controllers/pelanggan_controller.dart';
import 'package:bengkel/models/jadwal_service_model.dart';
import 'package:get/get.dart';
import '../services/api_jadwal_service.dart';
import '../services/notification_service.dart';

class JadwalServiceController extends GetxController {
  var isLoading = false.obs;
  var jadwalList = <JadwalService>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  final PelangganController _pelangganController =
      Get.find<PelangganController>();
  int get _idPelangganAktif => _pelangganController.currentUser.value?.id ?? 0;

  void fetchJadwal(int id) async {
    try {
      isLoading(true);
      var jadwalService = await APIJadwalService.fetchJadwalServiceByKendaraan(
        id,
      );
      jadwalList.assignAll(jadwalService);
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat jadwal: $e");
    } finally {
      isLoading(false);
    }
  }

  // === JadwalServiceController ===

  // Tambah Jadwal
  void tambahJadwal(
    Map<String, dynamic> data,
    DateTime tanggalService,
    int kendaraanId,
  ) async {
    try {
      isLoading(true); // [cite: 17]
      bool success = await APIJadwalService.createJadwal(data); // [cite: 18]
      if (success) {
        Get.back(); // [cite: 18]
        Get.snackbar(
          "Sukses",
          "Jadwal service berhasil ditambahkan!",
        ); // [cite: 19]

        int notifId = tanggalService.hashCode; // [cite: 19]

        await NotificationService.scheduleNotification(
          id: notifId,
          idPelangganAktif: _idPelangganAktif,
          title: "Pengingat Service Bengkel 🛠️",
          body: "Hari ini Anda memiliki jadwal service untuk: ${data['judul']}",
          scheduledDate: tanggalService,
        ); // [cite: 19]

        // SINKRONISASI JAUH LEBIH AMAN: Menggunakan ID mutlak dari UI
        fetchJadwal(kendaraanId);
      } else {
        Get.snackbar(
          "Gagal",
          "Gagal menyimpan jadwal ke server.",
        ); // [cite: 21]
      }
    } catch (e) {
      Get.snackbar("Error", e.toString()); // [cite: 22]
    } finally {
      isLoading(false); // [cite: 23]
    }
  }

  // Ubah Jadwal
  void editJadwal(
    int id,
    Map<String, dynamic> data,
    DateTime tanggalBaru,
    int kendaraanId,
  ) async {
    // 💡 Tambah parameter kendaraanId
    try {
      isLoading(true); // [cite: 23]
      bool success = await APIJadwalService.updateJadwal(
        id,
        data,
      ); // [cite: 24]
      if (success) {
        Get.back(); // [cite: 24]
        Get.snackbar(
          "Sukses",
          "Jadwal service berhasil diperbarui!",
        ); // [cite: 25]

        await NotificationService.cancelNotification(id); // [cite: 25]
        await NotificationService.scheduleNotification(
          id: id,
          idPelangganAktif: _idPelangganAktif,
          title: "Pengingat Service Bengkel 🛠️",
          body: "Hari ini Anda memiliki jadwal service untuk: ${data['judul']}",
          scheduledDate: tanggalBaru,
        ); // [cite: 25]

        // SINKRONISASI JAUH LEBIH AMAN
        fetchJadwal(kendaraanId);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString()); // [cite: 27]
    } finally {
      isLoading(false); // [cite: 28]
    }
  }

  // Hapus Jadwal
  void hapusJadwal(int id, int idKendaraan) async {
    try {
      bool success = await APIJadwalService.deleteJadwal(id);
      if (success) {
        await NotificationService.cancelNotification(id);
        jadwalList.removeWhere((item) => item.id == id);
        Get.snackbar("Sukses", "Jadwal service berhasil dihapus.");
      } else {
        Get.snackbar("Gagal", "Gagal menghapus jadwal di server.");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
