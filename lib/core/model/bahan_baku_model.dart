import 'package:flutter/foundation.dart';

@immutable
class BahanBaku {
  const BahanBaku({
    required this.id,
    required this.nama,
    required this.hargaBeli,
    required this.ketersediaan,
    required this.satuan,
  });

  final String id;
  final String nama;
  final num hargaBeli;
  final num ketersediaan;
  final String satuan;

  // Membuat objek BahanBaku dari Map (data JSON dari Firebase)
  factory BahanBaku.fromMap(Map<String, dynamic> data, String documentId) {
    return BahanBaku(
      id: documentId,
      nama: data['nama'] as String? ?? '',
      hargaBeli: data['hargaBeli'] as num? ?? 0,
      ketersediaan: data['ketersediaan'] as num? ?? 0,
      satuan: data['satuan'] as String? ?? '',
    );
  }

  // Mengubah objek BahanBaku menjadi Map untuk disimpan ke Firebase
  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'hargaBeli': hargaBeli,
      'ketersediaan': ketersediaan,
      'satuan': satuan,
    };
  }
}
