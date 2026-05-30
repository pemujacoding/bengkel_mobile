import 'package:get/get.dart';
import '../services/api_service.dart';
import '../models/riwayat_service_model.dart';

class RiwayatServiceController extends GetxController {
  var isLoading = false.obs;
  var riwayatList = <RiwayatService>[].obs;

  void fetchRiwayatByKendaraan(int kendaraanId) async {
    try {
      isLoading(true);
      var riwayat = await ApiService.fetchRiwayatService(kendaraanId);
      riwayatList.assignAll(riwayat);
    } catch (e) {
      Get.snackbar("Error Riwayat", e.toString());
    } finally {
      isLoading(false);
    }
  }
}
