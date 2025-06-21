class RumahSakit {
  final int? id;
  final String nama;
  final String alamat;
  final String telepon;
  final String tipe;
  final double latitude;
  final double longitude;

  RumahSakit({
    this.id,
    required this.nama,
    required this.alamat,
    required this.telepon,
    required this.tipe,
    required this.latitude,
    required this.longitude,
  });

  factory RumahSakit.fromJson(Map<String, dynamic> json) {
    return RumahSakit(
      id: json['id'],
      nama: json['nama'],
      alamat: json['alamat'],
      telepon: json['telepon'],
      tipe: json['tipe'],
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'alamat': alamat,
      'telepon': telepon,
      'tipe': tipe,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}