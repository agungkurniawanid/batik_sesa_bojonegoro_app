import 'dart:convert';

class Kain {
  final String id;
  final String kategori;
  final String nama;
  final String lebar;
  final String? finish; // Untuk katun & rayon
  final String? motif;  // Untuk dobby
  final num? harga;    // Harga umum
  final num? hargaRoll; // Harga khusus sutra
  final num? hargaEcer; // Harga khusus sutra
  final String satuan;

  Kain({
    required this.id,
    required this.kategori,
    required this.nama,
    required this.lebar,
    this.finish,
    this.motif,
    this.harga,
    this.hargaRoll,
    this.hargaEcer,
    required this.satuan,
  });

  Map<String, dynamic> toMap() {
    return {
      'kategori': kategori,
      'nama': nama,
      'lebar': lebar,
      'finish': finish,
      'motif': motif,
      'harga': harga,
      'hargaRoll': hargaRoll,
      'hargaEcer': hargaEcer,
      'satuan': satuan,
    };
  }

  factory Kain.fromMap(Map<String, dynamic> map, String id) {
    return Kain(
      id: id,
      kategori: map['kategori'] ?? '',
      nama: map['nama'] ?? '',
      lebar: map['lebar'] ?? '',
      finish: map['finish'],
      motif: map['motif'],
      harga: map['harga'],
      hargaRoll: map['hargaRoll'],
      hargaEcer: map['hargaEcer'],
      satuan: map['satuan'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Kain.fromJson(String source, String id) =>
      Kain.fromMap(json.decode(source), id);
}
