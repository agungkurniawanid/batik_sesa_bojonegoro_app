import 'package:firebase_database/firebase_database.dart';
import '../model/keperluan_model.dart';

class KeperluanRepository {
  KeperluanRepository(this._database);
  final FirebaseDatabase _database;

  static const _bahanBakuPath = 'bahan_baku_tradisional';
  static const _pewarnaBatikPath = 'pewarna_batik_modern';

  DatabaseReference get _bahanBakuRef => _database.ref(_bahanBakuPath);
  DatabaseReference get _pewarnaBatikRef => _database.ref(_pewarnaBatikPath);

  // Bahan Baku Tradisional
  Stream<List<BahanBakuTradisional>> watchBahanBakuTradisional() {
    return _bahanBakuRef.onValue.map((event) {
      if (!event.snapshot.exists || event.snapshot.value == null) return [];
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      return data.entries.map((entry) {
        final valueMap = Map<String, dynamic>.from(entry.value as Map);
        return BahanBakuTradisional.fromMap(valueMap, entry.key);
      }).toList();
    });
  }

  Future<void> addBahanBakuTradisional(BahanBakuTradisional bahan) {
    return _bahanBakuRef.push().set(bahan.toMap());
  }

  Future<void> updateBahanBakuTradisional(BahanBakuTradisional bahan) {
    return _bahanBakuRef.child(bahan.id).update(bahan.toMap());
  }

  Future<void> deleteBahanBakuTradisional(String id) {
    return _bahanBakuRef.child(id).remove();
  }

  // Pewarna Batik Modern
  Stream<List<PewarnaBatikModern>> watchPewarnaBatikModern() {
    return _pewarnaBatikRef.onValue.map((event) {
      if (!event.snapshot.exists || event.snapshot.value == null) return [];
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      return data.entries.map((entry) {
        final valueMap = Map<String, dynamic>.from(entry.value as Map);
        return PewarnaBatikModern.fromMap(valueMap, entry.key);
      }).toList();
    });
  }

  Future<void> addPewarnaBatikModern(PewarnaBatikModern pewarna) {
    return _pewarnaBatikRef.push().set(pewarna.toMap());
  }

  Future<void> updatePewarnaBatikModern(PewarnaBatikModern pewarna) {
    return _pewarnaBatikRef.child(pewarna.id).update(pewarna.toMap());
  }

  Future<void> deletePewarnaBatikModern(String id) {
    return _pewarnaBatikRef.child(id).remove();
  }
}
