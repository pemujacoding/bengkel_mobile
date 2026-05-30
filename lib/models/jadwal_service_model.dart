class JadwalService {
  final int id;
  final int idKendaraan;
  final String judul;
  final DateTime tanggal;
  final String deskripsi;

  JadwalService({
    required this.id,
    required this.idKendaraan,
    required this.judul,
    required this.tanggal,
    required this.deskripsi,
  });

  factory JadwalService.fromJson(Map<String, dynamic> json) {
    return JadwalService(
      id: json['id'] as int? ?? 0,
      idKendaraan: json['id_kendaraan'] as int? ?? 0,
      judul: json['judul'] as String? ?? '',
      tanggal: json['tanggal'] != null
          ? DateTime.tryParse(json['tanggal'].toString()) ?? DateTime.now()
          : DateTime.now(),
      deskripsi: json['deskripsi'] as String? ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_kendaraan': idKendaraan,
      'judul': judul,
      'tanggal':
          "${tanggal.year.toString().padLeft(4, '0')}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}", // Format YYYY-MM-DD
      'deskripsi': deskripsi,
    };
  }
}
