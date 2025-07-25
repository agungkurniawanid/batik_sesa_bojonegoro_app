import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/bahan_baku_model.dart';

class BahanBakuRepository {
  BahanBakuRepository(this._database);
  final FirebaseDatabase _database;

  static const _bahanBakuPath = 'bahanBaku';

  DatabaseReference get _bahanBakuRef => _database.ref(_bahanBakuPath);

  // Mendapatkan stream/aliran data bahan baku
  Stream<List<BahanBaku>> watchBahanBakuList() {
    final stream = _bahanBakuRef.onValue;
    return stream.map((event) {
      // Jika snapshot tidak ada atau nilainya null, kembalikan list kosong
      if (!event.snapshot.exists || event.snapshot.value == null) {
        return [];
      }
      // Konversi data dari Firebase menjadi Map
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);

      // Ubah setiap entri map menjadi objek BahanBaku
      return data.entries.map((entry) {
        final valueMap = Map<String, dynamic>.from(entry.value as Map);
        return BahanBaku.fromMap(valueMap, entry.key);
      }).toList();
    });
  }

  // Menambah bahan baku baru
  Future<void> addBahanBaku({
    required String nama,
    required num hargaBeli,
    required num ketersediaan,
    required String satuan,
  }) {
    // Membuat map data tanpa ID, karena ID akan menjadi key
    final Map<String, dynamic> newBahanBakuData = {
      'nama': nama,
      'hargaBeli': hargaBeli,
      'ketersediaan': ketersediaan,
      'satuan': satuan,
    };
    // push() akan membuat key unik, dan set() akan menyimpan datanya
    return _bahanBakuRef.push().set(newBahanBakuData);
  }

  // Memperbarui bahan baku
  Future<void> updateBahanBaku(BahanBaku bahanBaku) {
    // toMap() akan mengonversi objek menjadi map untuk diupdate
    return _bahanBakuRef.child(bahanBaku.id).update(bahanBaku.toMap());
  }

  // Menghapus bahan baku
  Future<void> deleteBahanBaku(String id) {
    return _bahanBakuRef.child(id).remove();
  }
}
