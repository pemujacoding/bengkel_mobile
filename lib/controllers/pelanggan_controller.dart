import 'dart:io';

import 'package:bengkel/controllers/catatan_service_controller.dart';
import 'package:bengkel/controllers/dokumentasi_controller.dart';
import 'package:bengkel/pages/login_page.dart';
import 'package:bengkel/pages/main_wrapper.dart';
import 'package:bengkel/services/api_pelanggan_service.dart';
import 'package:bengkel/services/hive_service.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../models/pelanggan_model.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class PelangganController extends GetxController {
  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  var currentUser = Rxn<Pelanggan>();

  static const String baseUrl =
      'https://bengkel-226557433828.us-central1.run.app/data';

  // =========================
  // LOAD PROFILE
  // =========================
  Future<void> loadUserProfile(int id) async {
    try {
      isLoading(true);

      final response = await http.get(Uri.parse('$baseUrl/pelanggan/$id'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        currentUser.value = Pelanggan.fromJson(data);
      } else {
        Get.snackbar('Error', 'Gagal memuat profil data dari server');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  // =========================
  // HASH PASSWORD
  // =========================
  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  // =========================
  // REGISTER
  // =========================
  void registerUser(Map<String, dynamic> data) async {
    try {
      isLoading(true);

      if (data.containsKey('password')) {
        String plainPassword = data['password'];
        data['password'] = _hashPassword(plainPassword);
      }

      bool success = await PelangganService.createUser(data);

      if (success) {
        Get.snackbar(
          'Sukses',
          'Akun berhasil dibuat! Silahkan login.',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
        );

        Get.offAll(() => LoginPage());
      } else {
        Get.snackbar('Gagal', 'Gagal mendaftarkan akun');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  // =========================
  // EDIT PROFILE
  // =========================
  void editProfile(int id, Map<String, dynamic> data) async {
    try {
      isLoading(true);

      bool success = await PelangganService.updateUser(id, data);

      if (success) {
        Get.snackbar('Sukses', 'Profil berhasil diperbarui!');

        loadUserProfile(id);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  // =========================
  // DELETE ACCOUNT
  // =========================
  // =========================
  // DELETE ACCOUNT
  // =========================
  void hapusAkun(int id) async {
    try {
      isLoading(true);
      bool success = await PelangganService.deleteUser(id);

      if (success) {
        final progressBox = Hive.box('progress_box');
        final keysProgress = progressBox.keys
            .where((k) => progressBox.get(k)['id_pelanggan'] == id)
            .toList();
        for (var key in keysProgress) {
          await progressBox.delete(key);
        }

        final catatanBox = Hive.box('catatan_mekanik_box');
        final keysCatatan = catatanBox.keys
            .where((k) => catatanBox.get(k)['id_pelanggan'] == id)
            .toList();
        for (var key in keysCatatan) {
          await catatanBox.delete(key);
        }

        final notifBox = HiveService.getNotificationBox();
        final keysNotif = notifBox.keys
            .where((k) => notifBox.get(k)['id_pelanggan'] == id)
            .toList();
        for (var key in keysNotif) {
          await notifBox.delete(key);
        }

        final appDir = await getApplicationDocumentsDirectory();
        final userFolder = Directory('${appDir.path}/pelanggan_$id');
        if (await userFolder.exists()) {
          await userFolder.delete(recursive: true);
        }

        currentUser.value = null;
        isLoggedIn.value = false;

        Get.offAll(() => LoginPage());
        Get.snackbar(
          'Sukses',
          'Akun dan seluruh data lokal berhasil dihapus secara permanen',
        );
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  // =========================
  // LOGIN
  // =========================
  void login(String usernameInput, String passwordInput) async {
    try {
      isLoading(true);

      final response = await http.get(Uri.parse('$baseUrl/pelanggan'));

      if (response.statusCode == 200) {
        List data = json.decode(response.body);

        List<Pelanggan> semuaPelanggan = data
            .map((json) => Pelanggan.fromJson(json))
            .toList();

        String hashedInputPassword = _hashPassword(passwordInput);

        final userDitemukan = semuaPelanggan.firstWhereOrNull(
          (user) =>
              user.username == usernameInput &&
              user.password == hashedInputPassword,
        );

        if (userDitemukan != null) {
          currentUser.value = userDitemukan;
          isLoggedIn.value = true;

          if (Get.isRegistered<CatatanServiceController>()) {
            Get.find<CatatanServiceController>().muatProgress();
            Get.find<CatatanServiceController>().muatCatatanMekanik();
          }
          if (Get.isRegistered<DokumentasiController>()) {
            Get.find<DokumentasiController>()
                .muatFotoSesuaiUser(); // Fungsi muat foto dari tutorial sebelumnya
          }

          Get.offAll(() => MainWrapper());

          Get.snackbar('Sukses', 'Selamat datang, ${userDitemukan.nama}!');
        } else {
          Get.snackbar('Gagal Login', 'Username atau password salah.');
        }
      } else {
        Get.snackbar('Error', 'Gagal terhubung ke server');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  // =========================
  // CHECK USERNAME
  // =========================
  Future<bool> isUsernameTaken(String usernameInput) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/pelanggan'));

      if (response.statusCode == 200) {
        List data = json.decode(response.body);

        bool adaYangSama = data.any(
          (user) => user['username'] == usernameInput,
        );

        return adaYangSama;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  // =========================
  // LOGOUT
  // =========================
  void logout() {
    isLoggedIn.value = false;
    currentUser.value = null;

    Get.offAll(() => LoginPage());
  }
}
