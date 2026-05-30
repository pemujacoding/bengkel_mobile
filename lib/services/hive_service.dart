import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String cartBox = 'cartBox';
  static const String notificationBox =
      'notificationBox'; // Box baru untuk notifikasi

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(cartBox);
    await Hive.openBox(notificationBox);
    await Hive.openBox('progress_box');
    await Hive.openBox('catatan_mekanik_box');
  }

  static Box getNotificationBox() {
    return Hive.box(notificationBox);
  }
}
