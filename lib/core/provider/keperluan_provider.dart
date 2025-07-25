import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/keperluan_model.dart';
import '../repository/keperluan_repository.dart';

final firebaseDatabaseProvider = Provider<FirebaseDatabase>((ref) {
  return FirebaseDatabase.instance;
});

final keperluanRepositoryProvider = Provider<KeperluanRepository>((ref) {
  return KeperluanRepository(ref.watch(firebaseDatabaseProvider));
});

final bahanBakuTradisionalStreamProvider = StreamProvider.autoDispose<List<BahanBakuTradisional>>((ref) {
  return ref.watch(keperluanRepositoryProvider).watchBahanBakuTradisional();
});

final pewarnaBatikModernStreamProvider = StreamProvider.autoDispose<List<PewarnaBatikModern>>((ref) {
  return ref.watch(keperluanRepositoryProvider).watchPewarnaBatikModern();
});