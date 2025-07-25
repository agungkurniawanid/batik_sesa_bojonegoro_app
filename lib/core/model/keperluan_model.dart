import 'package:flutter/foundation.dart';

@immutable
class BahanBakuTradisional {
  const BahanBakuTradisional({
    required this.id,
    required this.kategori,
    required this.nama,
    required this.harga,
    required this.satuan,
    required this.keterangan,
  });

  final String id;
  final String kategori;
  final String nama;
  final int harga;
  final String satuan;
  final String keterangan;

  factory BahanBakuTradisional.fromMap(Map<String, dynamic> data, String documentId) {
    return BahanBakuTradisional(
      id: documentId,
      kategori: data['kategori'] as String? ?? '',
      nama: data['nama'] as String? ?? '',
      harga: data['harga'] as int? ?? 0,
      satuan: data['satuan'] as String? ?? '',
      keterangan: data['keterangan'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'kategori': kategori,
      'nama': nama,
      'harga': harga,
      'satuan': satuan,
      'keterangan': keterangan,
    };
  }
}

@immutable
class PewarnaBatikModern {
  const PewarnaBatikModern({
    required this.id,
    required this.kategori,
    required this.nama,
    required this.harga1kg,
    required this.harga05kg,
    required this.harga025kg,
    required this.harga1ons,
  });

  final String id;
  final String kategori;
  final String nama;
  final int harga1kg;
  final int harga05kg;
  final int harga025kg;
  final int harga1ons;

  factory PewarnaBatikModern.fromMap(Map<String, dynamic> data, String documentId) {
    return PewarnaBatikModern(
      id: documentId,
      kategori: data['kategori'] as String? ?? '',
      nama: data['nama'] as String? ?? '',
      harga1kg: data['harga1kg'] as int? ?? 0,
      harga05kg: data['harga05kg'] as int? ?? 0,
      harga025kg: data['harga025kg'] as int? ?? 0,
      harga1ons: data['harga1ons'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'kategori': kategori,
      'nama': nama,
      'harga1kg': harga1kg,
      'harga05kg': harga05kg,
      'harga025kg': harga025kg,
      'harga1ons': harga1ons,
    };
  }
}