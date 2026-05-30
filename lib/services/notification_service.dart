import 'package:bengkel/services/hive_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(initSettings);

    // 1. Minta izin memunculkan notifikasi standar (Pop-up/Banner)
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    // 2. 💡 SOLUSI ERROR: Minta izin spesifik untuk Alarm Tepat Waktu (Exact Alarm)
    // await _notificationsPlugin
    //     .resolvePlatformSpecificImplementation<
    //       AndroidFlutterLocalNotificationsPlugin
    //     >()
    //     ?.requestExactAlarmsPermission(); // ✨ Ini akan meminta izin khusus ke sistem Android
  }

  static Future<void> scheduleNotification({
    required int id,
    required int idPelangganAktif,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    // 1. Ambil waktu sekarang di timezone lokal
    final now = tz.TZDateTime.now(tz.local);

    // 2. Set rencana pengingat pada jam 10:00 pagi di tanggal tersebut
    tz.TZDateTime tzDate = tz.TZDateTime(
      tz.local,
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
      10,
      00,
    );

    // 💡 SOLUSI BUG WAKTU: Jika tanggalnya hari ini dan jam 10 pagi sudah lewat,
    // alihkan ke waktu sekarang + 5 detik agar notifikasi tidak hang/gagal terjadwal.
    if (tzDate.isBefore(now)) {
      if (scheduledDate.year == now.year &&
          scheduledDate.month == now.month &&
          scheduledDate.day == now.day) {
        tzDate = now.add(const Duration(seconds: 5));
      } else {
        // Jika tanggal yang dipilih memang sudah lewat hari (masa lalu), jangan jadwalkan
        return;
      }
    }

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'bengkel_reminders',
          'Pengingat Service',
          importance: Importance.max,
          priority: Priority.high,
        );

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzDate,
      const NotificationDetails(android: androidDetails),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      //androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    // ==================== SIMPAN KE HIVE ====================
    final notifBox = HiveService.getNotificationBox();
    final dataNotif = {
      "id": id,
      "id_pelanggan": idPelangganAktif,
      "title": title,
      "body": body,
      "tanggal": scheduledDate.toIso8601String(),
      "isRead": false,
    };

    // Konsisten menggunakan ID Jadwal sebagai Key
    await notifBox.put(id, dataNotif);
  }

  // Batalkan notifikasi di Android sekaligus hapus dari Hive
  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);

    // Ikut hapus data di Hive agar sinkron saat hapus/edit
    final notifBox = HiveService.getNotificationBox();
    if (notifBox.containsKey(id)) {
      await notifBox.delete(id);
    }
  }
}
