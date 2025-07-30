import 'package:batik_sesa_bojonegoro_app/core/model/penerimaan_model.dart';
import 'package:batik_sesa_bojonegoro_app/core/repository/penerimaan_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final penerimaanRepositoryProvider = Provider<PenerimaanRepository>((ref) {
  return PenerimaanRepository();
});

final penerimaanStreamProvider = StreamProvider<List<PenerimaanModel>>((ref) {
  return ref.watch(penerimaanRepositoryProvider).getPenerimaanStream();
});
