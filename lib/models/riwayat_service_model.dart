class RiwayatService {
  final int id;
  final int idKendaraan;
  final int idMekanik;
  final String tanggal;
  final String keluhan;
  final String pelayanan;
  final String status;

  RiwayatService({
    required this.id,
    required this.idKendaraan,
    required this.idMekanik,
    required this.tanggal,
    required this.keluhan,
    required this.pelayanan,
    required this.status,
  });

  factory RiwayatService.fromJson(Map<String, dynamic> json) {
    return RiwayatService(
      id: json['id'] as int,
      idKendaraan: json['id_kendaraan'] as int,
      idMekanik: json['id_mekanik'] as int,
      tanggal: json['tanggal'] as String,
      keluhan: json['keluhan'] as String,
      pelayanan: json['pelayanan'] as String,
      status: json['status'] as String,
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'id': id,
      'id_kendaraan': idKendaraan,
      'id_mekanik': idMekanik,
      'tanggal': tanggal,
      'keluhan': keluhan,
      'pelayanan': pelayanan,
      'status': status,
    };
  }
}
