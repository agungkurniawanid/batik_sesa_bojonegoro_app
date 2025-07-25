import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_database/firebase_database.dart';

import '../model/kain_model.dart';
import '../repository/kain_repository.dart';

// --- Provider yang Sudah Ada ---

final firebaseDatabaseProvider = Provider<FirebaseDatabase>((ref) {
  return FirebaseDatabase.instance;
});

final kainRepositoryProvider = Provider<KainRepository>((ref) {
  final db = ref.watch(firebaseDatabaseProvider);
  return KainRepository(db);
});

final kainListStreamProvider = StreamProvider.autoDispose<List<Kain>>((ref) {
  final repository = ref.watch(kainRepositoryProvider);
  return repository.watchAllKain();
});


// --- Provider Baru untuk Search & Filter ---

/// Provider untuk menampung query pencarian dari TextField.
final kainSearchQueryProvider = StateProvider.autoDispose<String>((ref) => '');

/// Provider untuk filter kategori kain.
final kainCategoryFilterProvider = StateProvider.autoDispose<String?>((ref) => null);

/// Provider untuk filter lebar kain.
final kainWidthFilterProvider = StateProvider.autoDispose<String>((ref) => '');

/// Provider untuk filter satuan kain.
final kainUnitFilterProvider = StateProvider.autoDispose<String?>((ref) => null);


/// Provider UTAMA yang menggabungkan semua filter dan mengembalikan
/// daftar kain yang sudah tersaring.
final filteredKainListProvider = Provider.autoDispose<List<Kain>>((ref) {
  // 1. Ambil daftar lengkap kain dari stream
  final kainList = ref.watch(kainListStreamProvider).value ?? [];

  // 2. Ambil semua state filter saat ini
  final searchQuery = ref.watch(kainSearchQueryProvider);
  final selectedCategory = ref.watch(kainCategoryFilterProvider);
  final widthQuery = ref.watch(kainWidthFilterProvider);
  final selectedUnit = ref.watch(kainUnitFilterProvider);

  // 3. Terapkan logika filtering
  return kainList.where((kain) {
    // Filter berdasarkan nama (pencarian)
    final searchMatch = searchQuery.isEmpty ||
        kain.nama.toLowerCase().contains(searchQuery.toLowerCase());

    // Filter berdasarkan kategori
    final categoryMatch = selectedCategory == null || kain.kategori == selectedCategory;

    // Filter berdasarkan lebar (custom input)
    final widthMatch = widthQuery.isEmpty || kain.lebar.contains(widthQuery);

    // Filter berdasarkan satuan
    final unitMatch = selectedUnit == null || kain.satuan == selectedUnit;

    // Kembalikan true jika semua kondisi filter terpenuhi
    return searchMatch && categoryMatch && widthMatch && unitMatch;
  }).toList();
});
