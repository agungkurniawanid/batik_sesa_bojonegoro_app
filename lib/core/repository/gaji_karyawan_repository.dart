import 'package:firebase_database/firebase_database.dart';
import 'package:batik_sesa_bojonegoro_app/core/model/gaji_karyawan_model.dart';

class KaryawanRepository {
  KaryawanRepository(this._database);
  final FirebaseDatabase _database;

  static const _path = 'karyawan';
  DatabaseReference get _ref => _database.ref(_path);

  Stream<List<Karyawan>> watchAll() {
    return _ref.onValue.map((event) {
      if (!event.snapshot.exists) {
        return [];
      }
      // Menangani kasus jika data adalah List (dari seeding) atau Map
      if (event.snapshot.value is List) {
        final list = List<Object?>.from(event.snapshot.value as List);
        list.removeWhere((element) => element == null);
        return list.asMap().entries.map((entry) {
          final valueMap = Map<String, dynamic>.from(entry.value as Map);
          return Karyawan.fromMap(valueMap, (entry.key + 1).toString());
        }).toList();
      } else {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        return data.entries.map((entry) {
          final valueMap = Map<String, dynamic>.from(entry.value as Map);
          return Karyawan.fromMap(valueMap, entry.key);
        }).toList();
      }
    });
  }

  Future<void> add(Karyawan karyawan) {
    return _ref.push().set(karyawan.toMap());
  }

  Future<void> update(Karyawan karyawan) {
    return _ref.child(karyawan.id).update(karyawan.toMap());
  }

  Future<void> delete(String karyawanId) async {
    final gajiRef = _database.ref(GajiRepository._path);

    final query = gajiRef.orderByChild('karyawanId').equalTo(karyawanId);
    final snapshot = await query.get();

    if (snapshot.exists) {
      final updates = <String, dynamic>{};
      for (final child in snapshot.children) {
        updates['${GajiRepository._path}/${child.key}'] = null;
      }
      await _database.ref().update(updates);
    }

    await _ref.child(karyawanId).remove();
  }
}

class GajiRepository {
  GajiRepository(this._database);
  final FirebaseDatabase _database;

  static const _path = 'gaji';
  DatabaseReference get _ref => _database.ref(_path);

  Stream<List<Gaji>> watchAll() {
    return _ref.onValue.map((event) {
      if (!event.snapshot.exists) {
        return [];
      }
      // Menangani kasus jika data adalah List (dari seeding) atau Map
      if (event.snapshot.value is List) {
        final list = List<Object?>.from(event.snapshot.value as List);
        list.removeWhere((element) => element == null);
        return list.asMap().entries.map((entry) {
          final valueMap = Map<String, dynamic>.from(entry.value as Map);
          return Gaji.fromMap(valueMap, (entry.key + 1).toString());
        }).toList();
      } else {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        return data.entries.map((entry) {
          final valueMap = Map<String, dynamic>.from(entry.value as Map);
          return Gaji.fromMap(valueMap, entry.key);
        }).toList();
      }
    });
  }

  Future<void> add(Gaji gaji) {
    return _ref.push().set(gaji.toMap());
  }

  Future<void> update(Gaji gaji) {
    return _ref.child(gaji.id).update(gaji.toMap());
  }

  Future<void> delete(String id) {
    return _ref.child(id).remove();
  }
}
