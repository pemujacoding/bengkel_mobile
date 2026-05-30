import 'package:get/get.dart';
import '../controllers/pelanggan_controller.dart';
import '../models/pelanggan_model.dart';
import '../models/kendaraan_model.dart';
import '../services/api_service.dart';

class KendaraanController extends GetxController {
  final PelangganController pelangganCtrl = Get.find<PelangganController>();

  var isLoading = true.obs;
  var kendaraanList = <Kendaraan>[].obs;

  @override
  void onInit() {
    super.onInit();
    Pelanggan? user = pelangganCtrl.currentUser.value;

    if (user != null) {
      fetchKendaraan(user.id);
    } else {
      isLoading(false);
      Get.snackbar(
        "Peringatan",
        "Data pengguna tidak ditemukan, silahkan login ulang.",
      );
    }
  }

  void fetchKendaraan(int pelangganId) async {
    try {
      isLoading(true);
      var kendaraan = await ApiService.fetchKendaraanByPelanggan(pelangganId);
      kendaraanList.assignAll(kendaraan);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}
