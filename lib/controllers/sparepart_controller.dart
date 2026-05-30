import 'package:get/get.dart';
import '../models/sparepart_model.dart';
import '../services/api_service.dart';

class SparepartController extends GetxController {
  var isLoading = true.obs;
  var sparepartList = <Sparepart>[].obs;

  @override
  void onInit() {
    fetchSparepart();
    super.onInit();
  }

  void fetchSparepart() async {
    try {
      isLoading(true);
      var products = await ApiService.fetchAllSpareparts();
      sparepartList.assignAll(products);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}
