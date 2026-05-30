import 'package:get/get.dart';
import '../models/sparepart_digunakan_model.dart';
import '../services/api_service.dart';

class SparepartDigunakanController extends GetxController {
  var isLoading = true.obs;
  var spareparDigunakantList = <SparepartDigunakan>[].obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is int) {
      int idRiwayat = Get.arguments;
      fetchSparepartDigunakan(idRiwayat);
    } else {
      isLoading(false);
      print("Peringatan: ID Riwayat tidak dikirim lewat Get.arguments");
    }
  }

  void fetchSparepartDigunakan(int id) async {
    try {
      isLoading(true);
      var spareparDigunakan = await ApiService.fetchSparepartByRiwayat(id);
      spareparDigunakantList.assignAll(spareparDigunakan);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}
