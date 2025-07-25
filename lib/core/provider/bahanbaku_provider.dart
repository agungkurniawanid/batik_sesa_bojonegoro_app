import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/bahan_baku_model.dart';
import '../repository/bahan_baku_repository.dart';

// Provider untuk FirebaseDatabase
final firebaseDatabaseProvider = Provider<FirebaseDatabase>((ref) {
  return FirebaseDatabase.instance;
});

// Provider untuk BahanBakuRepository
final bahanBakuRepositoryProvider = Provider<BahanBakuRepository>((ref) {
  return BahanBakuRepository(ref.watch(firebaseDatabaseProvider));
});

// StreamProvider untuk mendapatkan daftar bahan baku
final bahanBakuListStreamProvider = StreamProvider.autoDispose<List<BahanBaku>>((ref) {
  final repository = ref.watch(bahanBakuRepositoryProvider);
  return repository.watchBahanBakuList();
});
