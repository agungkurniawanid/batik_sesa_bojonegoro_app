import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import '../../core/model/gaji_karyawan_model.dart';
import '../../core/provider/gaji_karyawan_provider.dart';
import 'add_gaji_screens.dart';
import 'add_karyawan_screens.dart';
import 'edit_gaji_screens.dart';
import 'edit_karyawan_screens.dart';
import 'karyawan_detail_screen.dart';

class KaryawanScreen extends ConsumerStatefulWidget {
  const KaryawanScreen({super.key});

  @override
  ConsumerState<KaryawanScreen> createState() => _KaryawanScreenState();
}

class _KaryawanScreenState extends ConsumerState<KaryawanScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(() {
      ref.read(karyawanSearchQueryProvider.notifier).state = _searchController.text;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showStatusFilterBottomSheet() {
    final statusList = ['Karyawan Tetap', 'Karyawan Kontrak', 'Freelance'];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
              20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Filter Berdasarkan Status',
                      style: Theme.of(context).textTheme.titleLarge),
                  TextButton(
                    onPressed: () {
                      ref.read(karyawanStatusFilterProvider.notifier).state = null;
                    },
                    child: const Text('Reset'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: ref.watch(karyawanStatusFilterProvider),
                hint: const Text('Pilih Status Karyawan'),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Status',
                ),
                items: statusList.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  ref.read(karyawanStatusFilterProvider.notifier).state = value;
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final karyawanListAsync = ref.watch(karyawanListStreamProvider);
    final gajiListAsync = ref.watch(gajiListStreamProvider);
    final filteredKaryawan = ref.watch(filteredKaryawanListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Data Karyawan',
          style: TextStyle(fontFamily: 'Sriwedari', fontWeight: FontWeight.bold, fontSize: 32, color: Colors.blueAccent),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Bagian Daftar Karyawan ---
              _buildSectionHeader(
                context,
                title: 'Daftar Karyawan',
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddKaryawanScreen())),
              ),
              const SizedBox(height: 16),
              _buildKaryawanSearchBar(),
              const SizedBox(height: 16),
              karyawanListAsync.when(
                data: (karyawanList) => karyawanList.isEmpty
                    ? _buildEmptyDataInfoCard(
                        context: context,
                        title: 'Belum Ada Data Karyawan',
                        message: 'Tambahkan karyawan pertama Anda untuk memulai',
                        icon: HeroIcons.user,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AddKaryawanScreen()),
                        ),
                      )
                    : (filteredKaryawan.isEmpty
                        ? _buildEmptyDataInfoCard(
                            context: context,
                            title: 'Karyawan Tidak Ditemukan',
                            message: 'Coba gunakan kata kunci lain atau filter yang berbeda',
                            icon: HeroIcons.magnifyingGlass,
                          )
                        : _buildKaryawanListView(filteredKaryawan)),
                loading: () => const _LoadingState(),
                error: (err, _) => _ErrorState(message: err.toString()),
              ),
              const SizedBox(height: 24),

              // --- Bagian Daftar Gaji ---
              _buildSectionHeader(
                context,
                title: 'Riwayat Gaji',
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddGajiScreen())),
              ),
              const SizedBox(height: 16),
              gajiListAsync.when(
                data: (gajiList) => gajiList.isEmpty
                    ? _buildEmptyDataInfoCard(
                        context: context,
                        title: 'Belum Ada Data Gaji',
                        message: 'Tambahkan data gaji pertama Anda untuk memulai',
                        icon: HeroIcons.currencyDollar,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AddGajiScreen()),
                        ),
                      )
                    : _buildGajiListView(gajiList, karyawanListAsync.asData?.value ?? []),
                loading: () => const _LoadingState(),
                error: (err, _) => _ErrorState(message: err.toString()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyDataInfoCard({
    required BuildContext context,
    required String title,
    required String message,
    required HeroIcons icon,
    VoidCallback? onPressed,
  }) {
    return Card(
      color: Colors.blue[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.blue[100]!,
          width: 1,
        ),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                shape: BoxShape.circle,
              ),
              child: HeroIcon(
                icon,
                size: 28,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue[700],
              ),
            ),
            if (onPressed != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    HeroIcon(HeroIcons.plus, size: 16),
                    SizedBox(width: 8),
                    Text('Tambah Data'),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildKaryawanListView(List<Karyawan> karyawanList) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: karyawanList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, index) {
        final karyawan = karyawanList[index];
        return _buildKaryawanCard(context, ref, karyawan);
      },
    );
  }

  Widget _buildKaryawanSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10),
                hintText: 'Cari nama karyawan...',
                border: InputBorder.none,
                prefixIcon: const HeroIcon(HeroIcons.magnifyingGlass, size: 20),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const HeroIcon(HeroIcons.xMark, size: 20),
                  onPressed: () => _searchController.clear(),
                )
                    : null,
              ),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: _showStatusFilterBottomSheet,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
              child: const HeroIcon(HeroIcons.funnel, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGajiListView(List<Gaji> gajiList, List<Karyawan> karyawanList) {
    final karyawanMap = {for (var k in karyawanList) k.id: k.nama};
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: gajiList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final gaji = gajiList[index];
        final namaKaryawan = karyawanMap[gaji.karyawanId] ?? 'Karyawan Tidak Ditemukan';
        return _buildGajiCard(context, ref, gaji, namaKaryawan);
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, {required String title, required VoidCallback onPressed}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Row(
            children: [
              HeroIcon(HeroIcons.plus, size: 16),
              SizedBox(width: 4),
              Text('Tambah'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKaryawanCard(BuildContext context, WidgetRef ref, Karyawan karyawan) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => KaryawanDetailScreen(karyawan: karyawan),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4))
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12)),
              child:
              const HeroIcon(HeroIcons.user, size: 20, color: Colors.blue),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(karyawan.nama,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(karyawan.alamat,
                      style: const TextStyle(color: Colors.black54)),
                  const SizedBox(height: 4),
                  Text(karyawan.status,
                      style: TextStyle(
                          color: Colors.green.shade600,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            PopupMenuButton(
              icon: const HeroIcon(HeroIcons.ellipsisVertical, size: 20),
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                const PopupMenuItem(
                    value: 'delete',
                    child: Text('Hapus', style: TextStyle(color: Colors.red))),
              ],
              onSelected: (value) {
                if (value == 'edit') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              EditKaryawanScreen(karyawan: karyawan)));
                } else if (value == 'delete') {
                  _showDeleteConfirmation(context, ref,
                      isKaryawan: true, id: karyawan.id, nama: karyawan.nama);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGajiCard(BuildContext context, WidgetRef ref, Gaji gaji, String namaKaryawan) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(12)),
                child: const HeroIcon(HeroIcons.currencyDollar, size: 20, color: Colors.orange),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(namaKaryawan, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text('${gaji.bulan} ${gaji.tahun}', style: const TextStyle(color: Colors.black54)),
                  ],
                ),
              ),
              PopupMenuButton(
                icon: const HeroIcon(HeroIcons.ellipsisVertical, size: 20),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(value: 'delete', child: Text('Hapus', style: TextStyle(color: Colors.red))),
                ],
                onSelected: (value) {
                  if (value == 'edit') {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditGajiScreen(gaji: gaji)));
                  } else if (value == 'delete') {
                    _showDeleteConfirmation(context, ref, isKaryawan: false, id: gaji.id, nama: 'data gaji untuk $namaKaryawan');
                  }
                },
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoItem('Jumlah Kain', '${gaji.jumlahKain} Lembar'),
              _infoItem('Total Gaji', currencyFormatter.format(gaji.totalGaji)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, {required bool isKaryawan, required String id, required String nama}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Hapus ${isKaryawan ? "Karyawan" : "Data Gaji"}'),
          content: Text('Anda yakin ingin menghapus $nama?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
              onPressed: () async {
                try {
                  if (isKaryawan) {
                    await ref.read(karyawanRepositoryProvider).delete(id);
                  } else {
                    await ref.read(gajiRepositoryProvider).delete(id);
                  }
                  if (context.mounted) {
                    Navigator.pop(context);
                    showSnackbar(context, '$nama berhasil dihapus.', isError: false);
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.pop(context);
                    showSnackbar(context, 'Gagal menghapus: $e');
                  }
                }
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  void showSnackbar(BuildContext context, String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();
  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        ));
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});
  final String message;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Terjadi error: $message'),
        ));
  }
}