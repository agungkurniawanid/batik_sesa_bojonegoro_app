class Karyawan {
  final String id;
  final String nama;
  final String alamat;
  final String status;
  final String nomorTelepon;

  Karyawan({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.status,
    required this.nomorTelepon,
  });

  // Factory constructor untuk membuat instance dari Map (data Firebase)
  factory Karyawan.fromMap(Map<String, dynamic> map, String id) {
    return Karyawan(
      id: id,
      nama: map['nama'] ?? '',
      alamat: map['alamat'] ?? '',
      status: map['status'] ?? '',
      nomorTelepon: map['nomorTelepon'] ?? '',
    );
  }

  // Method untuk mengubah instance menjadi Map (untuk menyimpan ke Firebase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'alamat': alamat,
      'status': status,
      'nomorTelepon': nomorTelepon,
    };
  }
}


class Gaji {
  final String id;
  final String karyawanId;
  final String bulan;
  final String tahun;
  final int jumlahKain;
  final int totalGaji;

  Gaji({
    required this.id,
    required this.karyawanId,
    required this.bulan,
    required this.tahun,
    required this.jumlahKain,
    required this.totalGaji,
  });

  factory Gaji.fromMap(Map<String, dynamic> map, String id) {
    return Gaji(
      id: id,
      karyawanId: map['karyawanId'] ?? '',
      bulan: map['bulan'] ?? '',
      tahun: map['tahun'] ?? '',
      jumlahKain: map['jumlahKain'] ?? 0,
      totalGaji: map['totalGaji'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'karyawanId': karyawanId,
      'bulan': bulan,
      'tahun': tahun,
      'jumlahKain': jumlahKain,
      'totalGaji': totalGaji,
    };
  }
}