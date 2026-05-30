import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'pelanggan_controller.dart'; // 💡 Sesuaikan dengan path file PelangganController kamu

class CatatanServiceController extends GetxController {
  final _progressBox = Hive.box('progress_box');
  final _catatanBox = Hive.box('catatan_mekanik_box');

  var daftarProgress = <Map<String, dynamic>>[].obs;
  var daftarCatatanMekanik = <Map<String, dynamic>>[].obs;

  // 💡 Hubungkan ke PelangganController untuk mendeteksi siapa yang sedang login
  final PelangganController _pelangganController =
      Get.find<PelangganController>();

  // Fungsi pembantu untuk mengambil ID Pelanggan yang sedang aktif login secara aman
  int get _idPelangganAktif => _pelangganController.currentUser.value?.id ?? 0;

  @override
  void onInit() {
    super.onInit();
    muatProgress();
    muatCatatanMekanik();
  }

  // ==================== LOKAL CRUD PROGRESS ====================
  void muatProgress() {
    final List<Map<String, dynamic>> sementara = [];
    for (var key in _progressBox.keys) {
      final data = _progressBox.get(key);

      // 💡 FILTER: Hanya ambil data yang id_pelanggan-nya cocok dengan yang sedang login
      if (data != null && data['id_pelanggan'] == _idPelangganAktif) {
        sementara.add({
          'id': key,
          'tanggal': data['tanggal'] ?? '',
          'progress': data['progress'] ?? '0',
        });
      }
    }
    sementara.sort((a, b) => b['tanggal'].compareTo(a['tanggal']));
    daftarProgress.assignAll(sementara);
  }

  void tambahProgress(String nilaiProgress) async {
    final String id = 'prog_${DateTime.now().millisecondsSinceEpoch}';
    await _progressBox.put(id, {
      'id_pelanggan': _idPelangganAktif, // 💡 Simpan ID pelanggan aktif
      'tanggal': DateTime.now().toIso8601String().split('T')[0],
      'progress': nilaiProgress,
    });
    muatProgress();
    Get.snackbar("Sukses", "Progress service berhasil ditambahkan!");
  }

  void ubahProgress(String id, String nilaiProgress, String tanggalLama) async {
    await _progressBox.put(id, {
      'id_pelanggan':
          _idPelangganAktif, // 💡 Pastikan ikut disertakan saat update
      'tanggal': tanggalLama,
      'progress': nilaiProgress,
    });
    muatProgress();
    Get.snackbar("Sukses", "Progress berhasil diperbarui!");
  }

  void hapusProgress(String id) async {
    await _progressBox.delete(id);
    muatProgress();
    Get.snackbar("Terhapus", "Data progress berhasil dihapus.");
  }

  // ==================== LOKAL CRUD CATATAN MEKANIK ====================
  void muatCatatanMekanik() {
    final List<Map<String, dynamic>> sementara = [];
    for (var key in _catatanBox.keys) {
      final data = _catatanBox.get(key);

      // 💡 FILTER: Hanya ambil catatan milik user yang sedang aktif login
      if (data != null && data['id_pelanggan'] == _idPelangganAktif) {
        sementara.add({
          'id': key,
          'tanggal': data['tanggal'] ?? '',
          'catatan': data['catatan'] ?? '',
        });
      }
    }
    sementara.sort((a, b) => b['tanggal'].compareTo(a['tanggal']));
    daftarCatatanMekanik.assignAll(sementara);
  }

  void tambahCatatan(String isiCatatan) async {
    final String id = 'cat_${DateTime.now().millisecondsSinceEpoch}';
    await _catatanBox.put(id, {
      'id_pelanggan': _idPelangganAktif, // 💡 Simpan ID pelanggan aktif
      'tanggal': DateTime.now().toIso8601String().split('T')[0],
      'catatan': isiCatatan,
    });
    muatCatatanMekanik();
    Get.snackbar("Sukses", "Catatan mekanik berhasil disimpan!");
  }

  void ubahCatatan(String id, String isiCatatan, String tanggalLama) async {
    await _catatanBox.put(id, {
      'id_pelanggan':
          _idPelangganAktif, // 💡 Pastikan ikut disertakan saat update
      'tanggal': tanggalLama,
      'catatan': isiCatatan,
    });
    muatCatatanMekanik();
    Get.snackbar("Sukses", "Catatan mekanik berhasil diperbarui!");
  }

  void hapusCatatan(String id) async {
    await _catatanBox.delete(id);
    muatCatatanMekanik();
    Get.snackbar("Terhapus", "Catatan mekanik berhasil dihapus.");
  }
}
