import 'package:firebase_database/firebase_database.dart';

class PenerimaanModel {
  final String id;
  final String tanggal;
  final String transaksi;
  final String pembeli;
  final num kuantitas;
  final String satuan;
  final num hargaSatuan;
  final num total;
  final String? keterangan;

  PenerimaanModel({
    required this.id,
    required this.tanggal,
    required this.transaksi,
    required this.pembeli,
    required this.kuantitas,
    required this.satuan,
    required this.hargaSatuan,
    required this.total,
    this.keterangan,
  });

  // Konstruktor dari DataSnapshot Firebase
  factory PenerimaanModel.fromSnapshot(DataSnapshot snapshot) {
    final data = snapshot.value as Map<dynamic, dynamic>? ?? {};

    return PenerimaanModel(
      id: snapshot.key ?? '',
      tanggal: data['tanggal']?.toString() ?? '',
      transaksi: data['transaksi']?.toString() ?? '',
      pembeli: data['pembeli']?.toString() ?? '',
      kuantitas: (data['kuantitas'] as num?) ?? 0,
      satuan: data['satuan']?.toString() ?? '',
      hargaSatuan: (data['hargaSatuan'] as num?) ?? 0,
      total: (data['total'] as num?) ?? 0,
      keterangan: data['keterangan']?.toString(),
    );
  }

  // Konstruktor dari Map<String, dynamic>
  factory PenerimaanModel.fromMap(Map<String, dynamic> map, String id) {
    return PenerimaanModel(
      id: id,
      tanggal: map['tanggal']?.toString() ?? '',
      transaksi: map['transaksi']?.toString() ?? '',
      pembeli: map['pembeli']?.toString() ?? '',
      kuantitas: (map['kuantitas'] as num?) ?? 0,
      satuan: map['satuan']?.toString() ?? '',
      hargaSatuan: (map['hargaSatuan'] as num?) ?? 0,
      total: (map['total'] as num?) ?? 0,
      keterangan: map['keterangan']?.toString(),
    );
  }

  // Konversi ke JSON
  Map<String, dynamic> toJson() {
    return {
      'tanggal': tanggal,
      'transaksi': transaksi,
      'pembeli': pembeli,
      'kuantitas': kuantitas,
      'satuan': satuan,
      'hargaSatuan': hargaSatuan,
      'total': total,
      if (keterangan != null) 'keterangan': keterangan,
    };
  }
}

extension PenerimaanExtension on PenerimaanModel {
  PenerimaanModel copyWith({
    String? id,
    String? tanggal,
    String? transaksi,
    String? pembeli,
    num? kuantitas,
    String? satuan,
    num? hargaSatuan,
    num? total,
    String? keterangan,
  }) {
    return PenerimaanModel(
      id: id ?? this.id,
      tanggal: tanggal ?? this.tanggal,
      transaksi: transaksi ?? this.transaksi,
      pembeli: pembeli ?? this.pembeli,
      kuantitas: kuantitas ?? this.kuantitas,
      satuan: satuan ?? this.satuan,
      hargaSatuan: hargaSatuan ?? this.hargaSatuan,
      total: total ?? this.total,
      keterangan: keterangan ?? this.keterangan,
    );
  }
}

extension PenerimaanListExtension on Iterable<PenerimaanModel> {
  PenerimaanModel? firstWhereOrNull(bool Function(PenerimaanModel) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

// Add this data class at the top of your file
class StatsData {
  final num totalAmount;
  final int transactionCount;
  final int monthlyGrowth;
  final int transactionGrowth;

  StatsData({
    required this.totalAmount,
    required this.transactionCount,
    required this.monthlyGrowth,
    required this.transactionGrowth,
  });
}
