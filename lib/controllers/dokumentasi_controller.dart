import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'pelanggan_controller.dart'; // 💡 Import controller pelanggan kamu

class DokumentasiController extends GetxController {
  var daftarFotoLokal = <File>[].obs;
  final ImagePicker _picker = ImagePicker();

  final PelangganController _pelangganController =
      Get.find<PelangganController>();
  int get _idPelangganAktif => _pelangganController.currentUser.value?.id ?? 0;

  Future<void> ambilFoto(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        // 1. Ambil direktori utama dokumen aplikasi
        final Directory appDir = await getApplicationDocumentsDirectory();

        // 2. 💡 Buat sub-folder spesifik berdasarkan ID Pelanggan yang sedang login
        final String userFolderPath = path.join(
          appDir.path,
          'pelanggan_$_idPelangganAktif',
        );
        final Directory userFolder = Directory(userFolderPath);

        // Jika foldernya belum ada di HP (baru pertama kali upload), buat secara otomatis
        if (!await userFolder.exists()) {
          await userFolder.create(recursive: true);
        }

        // 3. Gabungkan path folder khusus pelanggan dengan nama file gambar unik
        String fileName =
            'kendaraan_${DateTime.now().millisecondsSinceEpoch}${path.extension(pickedFile.path)}';
        String savedPath = path.join(userFolder.path, fileName);

        // 4. Salin file ke folder khusus pelanggan tersebut
        File fotoBaru = await File(pickedFile.path).copy(savedPath);

        daftarFotoLokal.add(fotoBaru);
        Get.snackbar("Sukses", "Foto berhasil didokumentasikan!");
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil foto: $e");
    }
  }

  // 💡 TIPS TAMBAHAN: Buat fungsi untuk memuat foto lama sesuai user yang login jika diperlukan halaman galeri dibuka kembali
  void muatFotoSesuaiUser() async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String userFolderPath = path.join(
        appDir.path,
        'pelanggan_$_idPelangganAktif',
      );
      final Directory userFolder = Directory(userFolderPath);

      if (await userFolder.exists()) {
        final List<FileSystemEntity> files = userFolder.listSync();
        daftarFotoLokal.assignAll(files.whereType<File>().toList());
      } else {
        daftarFotoLokal.clear();
      }
    } catch (e) {
      print("Gagal memuat daftar foto lokal: $e");
    }
  }

  void hapusFotoAt(int index) {
    try {
      if (daftarFotoLokal[index].existsSync()) {
        daftarFotoLokal[index].deleteSync();
      }
    } catch (e) {
      print(e);
    }
    daftarFotoLokal.removeAt(index);
  }
}
