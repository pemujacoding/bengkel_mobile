import 'sparepart_model.dart';

class SparepartDigunakan {
  final int id;
  final int idRiwayat;
  final int idSparepart;
  final int jumlah;
  final Sparepart sparepart;

  SparepartDigunakan({
    required this.id,
    required this.idRiwayat,
    required this.idSparepart,
    required this.jumlah,
    required this.sparepart,
  });

  factory SparepartDigunakan.fromJson(Map<String, dynamic> json) {
    return SparepartDigunakan(
      id: json['id'] as int,
      idRiwayat: json['id_riwayat'] as int,
      idSparepart: json['id_sparepart'] as int,
      jumlah: json['jumlah'] as int,
      sparepart: Sparepart.fromJson(json['sparepart'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_riwayat': idRiwayat,
      'id_sparepart': idSparepart,
      'jumlah': jumlah,
      'sparepart': sparepart.toJson(),
    };
  }
}
