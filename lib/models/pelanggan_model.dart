class Pelanggan {
  final int id;
  final String nama;
  final String noTelp;
  final String alamat;
  final String username;
  String password;

  Pelanggan({
    required this.id,
    required this.nama,
    required this.noTelp,
    required this.alamat,
    required this.username,
    required this.password,
  });

  factory Pelanggan.fromJson(Map<String, dynamic> json) {
    return Pelanggan(
      id: json['id'] as int,
      nama: json['nama'] as String,
      noTelp: json['no_telp'] as String,
      alamat: json['alamat'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'no_telp': noTelp,
      'alamat': alamat,
      'username': username,
      'password': password,
    };
  }
}
