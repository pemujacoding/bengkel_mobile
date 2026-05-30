class Kendaraan {
  final int id;
  final int idPelanggan;
  final String jenis;
  final String merk;
  final String plat;

  Kendaraan({
    required this.id,
    required this.idPelanggan,
    required this.jenis,
    required this.merk,
    required this.plat,
  });

  factory Kendaraan.fromJson(Map<String, dynamic> json) {
    return Kendaraan(
      id: json['id'] as int,
      idPelanggan: json['id_pelanggan'] as int,
      jenis: json['jenis'] as String,
      merk: json['merk'] as String,
      plat: json['plat'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_pelanggan': idPelanggan,
      'jenis': jenis,
      'merk': merk,
      'plat': plat,
    };
  }
}