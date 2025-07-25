import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/gaji_karyawan_model.dart';
import '../repository/gaji_karyawan_repository.dart';
import 'bahanbaku_provider.dart';

// --- Provider untuk Fitur Karyawan ---

// Provider untuk menyediakan instance KaryawanRepository.
final karyawanRepositoryProvider = Provider<KaryawanRepository>((ref) {
  final db = ref.watch(firebaseDatabaseProvider);
  return KaryawanRepository(db);
});

// StreamProvider untuk mendapatkan daftar karyawan secara real-time.
final karyawanListStreamProvider = StreamProvider.autoDispose<List<Karyawan>>((ref) {
  final repository = ref.watch(karyawanRepositoryProvider);
  return repository.watchAll();
});

final karyawanSearchQueryProvider = StateProvider.autoDispose<String>((ref) => '');

// Provider untuk menampung filter status karyawan
final karyawanStatusFilterProvider = StateProvider.autoDispose<String?>((ref) => null);

// Provider yang menghasilkan daftar karyawan yang sudah difilter
final filteredKaryawanListProvider = Provider.autoDispose<List<Karyawan>>((ref) {
  final karyawanList = ref.watch(karyawanListStreamProvider).value ?? [];
  final searchQuery = ref.watch(karyawanSearchQueryProvider);
  final statusFilter = ref.watch(karyawanStatusFilterProvider);

  return karyawanList.where((karyawan) {
    final searchMatch = searchQuery.isEmpty ||
        karyawan.nama.toLowerCase().contains(searchQuery.toLowerCase());

    final statusMatch = statusFilter == null || karyawan.status == statusFilter;

    return searchMatch && statusMatch;
  }).toList();
});


// --- Provider untuk Fitur Gaji ---

/// Provider untuk menyediakan instance GajiRepository.
final gajiRepositoryProvider = Provider<GajiRepository>((ref) {
  final db = ref.watch(firebaseDatabaseProvider);
  return GajiRepository(db);
});

/// StreamProvider untuk mendapatkan daftar gaji secara real-time.
final gajiListStreamProvider = StreamProvider.autoDispose<List<Gaji>>((ref) {
  final repository = ref.watch(gajiRepositoryProvider);
  return repository.watchAll();
});