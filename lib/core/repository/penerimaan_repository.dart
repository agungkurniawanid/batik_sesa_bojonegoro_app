import 'package:batik_sesa_bojonegoro_app/core/model/penerimaan_model.dart';
import 'package:firebase_database/firebase_database.dart';

class PenerimaanRepository {
  final DatabaseReference _dbRef;

  PenerimaanRepository() : _dbRef = FirebaseDatabase.instance.ref('penerimaan');

  Future<String> addPenerimaan(PenerimaanModel penerimaan) async {
    try {
      final newRef = _dbRef.push();
      await newRef.set(penerimaan.copyWith(id: newRef.key).toJson());
      return newRef.key!;
    } catch (e) {
      throw Exception('Failed to add penerimaan: $e');
    }
  }

  Future<void> updatePenerimaan(PenerimaanModel penerimaan) async {
    try {
      if (penerimaan.id.isEmpty) throw Exception('Invalid penerimaan ID');
      await _dbRef.child(penerimaan.id).update(penerimaan.toJson());
    } catch (e) {
      throw Exception('Failed to update penerimaan: $e');
    }
  }

  Future<void> deletePenerimaan(String id) async {
    try {
      if (id.isEmpty) throw Exception('Invalid penerimaan ID');
      await _dbRef.child(id).remove();
    } catch (e) {
      throw Exception('Failed to delete penerimaan: $e');
    }
  }

  Stream<List<PenerimaanModel>> getPenerimaanStream() {
    final stream = _dbRef.onValue;
    return stream.map((event) {
      if (!event.snapshot.exists || event.snapshot.value == null) {
        return <PenerimaanModel>[];
      }
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      return data.entries.map((entry) {
        final valueMap = Map<String, dynamic>.from(entry.value as Map);
        return PenerimaanModel.fromMap(valueMap, entry.key);
      }).toList();
    });
  }

  Future<PenerimaanModel?> getPenerimaanById(String id) async {
    try {
      if (id.isEmpty) return null;
      final snapshot = await _dbRef.child(id).get();
      if (!snapshot.exists || snapshot.value == null) return null;

      final valueMap = Map<String, dynamic>.from(snapshot.value as Map);
      return PenerimaanModel.fromMap(valueMap, snapshot.key!);
    } catch (e) {
      throw Exception('Failed to get penerimaan: $e');
    }
  }
}
