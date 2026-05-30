class Transaksi {
  final int id;
  final int idRiwayat;
  final double nominal;
  final String metode;
  final String status;

  Transaksi({
    required this.id,
    required this.idRiwayat,
    required this.nominal,
    required this.metode,
    required this.status,
  });

  factory Transaksi.fromJson(Map<String, dynamic> json) {
    return Transaksi(
      id: json['id'] as int,
      idRiwayat: json['id_riwayat'] as int,
      nominal: double.parse(json['nominal'].toString()),
      metode: json['metode'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_riwayat': idRiwayat,
      'nominal': nominal.toStringAsFixed(2),
      'metode': metode,
      'status': status,
    };
  }
}
