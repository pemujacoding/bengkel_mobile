class Sparepart {
  final int id;
  final String nama;
  final double harga;
  final String kategori;
  final String merk;
  final int stok;
  final String deskripsi;
  final String gambar;

  Sparepart({
    required this.id,
    required this.nama,
    required this.harga,
    required this.kategori,
    required this.merk,
    required this.stok,
    required this.deskripsi,
    required this.gambar,
  });

  factory Sparepart.fromJson(Map<String, dynamic> json) {
    return Sparepart(
      id: json['id'] as int,
      nama: json['nama'] as String,
      harga: double.parse(json['harga'].toString()),
      kategori: json['kategori'] as String,
      merk: json['merk'] as String,
      stok: json['stok'] as int,
      deskripsi: json['deskripsi'] as String,
      gambar: json['gambar'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'harga': harga.toStringAsFixed(2),
      'kategori': kategori,
      'merk': merk,
      'stok': stok,
      'deskripsi': deskripsi,
      'gambar': gambar,
    };
  }
}
