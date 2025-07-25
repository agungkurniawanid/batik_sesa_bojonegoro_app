import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import '../../core/model/kain_model.dart';
import '../../core/provider/kain_provider.dart';
import 'add_kain_screens.dart';
import 'edit_kain_screens.dart';

class DaftarKainScreen extends ConsumerStatefulWidget {
  const DaftarKainScreen({super.key});

  @override
  ConsumerState<DaftarKainScreen> createState() => _DaftarKainScreenState();
}

class _DaftarKainScreenState extends ConsumerState<DaftarKainScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _checkAndSeedDatabase());

    _searchController.addListener(() {
      ref.read(kainSearchQueryProvider.notifier).state = _searchController.text;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _FilterBottomSheet(),
    );
  }

  Future<void> _checkAndSeedDatabase() async {
    final repository = ref.read(kainRepositoryProvider);
    final bool isEmpty = await repository.isDatabaseEmpty();

    if (isEmpty && mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Database Kosong'),
          content: const Text(
              'Database kain Anda kosong. Ingin menambahkan daftar harga kain default dari Bima Kunting?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tidak'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                showSnackbar(context, 'Menambahkan data default...');
                await repository.seedDatabaseFromPriceList();
                if (mounted) {
                  showSnackbar(context, 'Data default berhasil ditambahkan!',
                      isError: false);
                }
              },
              child: const Text('Ya, Tambahkan'),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildEmptyDataInfoCard(BuildContext context) {
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
              child: const HeroIcon(
                HeroIcons.informationCircle,
                size: 28,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Belum Ada Data Kain',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tambahkan data kain pertama Anda untuk memulai',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue[700],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddKainScreen(),
                  ),
                );
              },
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
                  Text('Tambah Kain'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredKainList = ref.watch(filteredKainListProvider);
    final kainListAsync = ref.watch(kainListStreamProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Daftar Kain', style: TextStyle(fontFamily: 'Sriwedari', fontWeight: FontWeight.bold, fontSize: 32, color: Colors.blueAccent)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddKainScreen())),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const HeroIcon(HeroIcons.plus, size: 20, color: Colors.white),
            ),
          ),
        ],
      ),
      body: kainListAsync.when(
        data: (_) {
          if (filteredKainList.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: _buildEmptyDataInfoCard(context),
              ),
            );
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredKainList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, index) {
                      final kain = filteredKainList[index];
                      return _buildKainCard(context, kain);
                    },
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Terjadi error: ${err.toString()}')),
      ),
    );
  }

  Widget _buildSearchBar() {
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
                hintText: 'Cari nama kain...',
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
            onTap: _showFilterBottomSheet,
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

  Widget _buildKainCard(BuildContext context, Kain kain) {
    final currencyFormatter =
    NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return InkWell(
      onTap: () => _showDetailBottomSheet(context, kain, currencyFormatter),
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
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const HeroIcon(HeroIcons.swatch, size: 20, color: Colors.blue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    kain.nama,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                ),
                PopupMenuButton(
                  icon: const HeroIcon(HeroIcons.ellipsisVertical, size: 20),
                  itemBuilder: (context) => [
                    _buildPopupMenuItem('edit', 'Edit', HeroIcons.pencil, Colors.black),
                    _buildPopupMenuItem('delete', 'Hapus', HeroIcons.trash, Colors.red),
                  ],
                  onSelected: (value) {
                    if (value == 'edit') {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EditKainScreen(kain: kain)));
                    } else if (value == 'delete') {
                      _showDeleteConfirmation(context, kain);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 5),
            const Divider(height: 1, color: Colors.grey, thickness: 0.3),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoItem('Kategori', kain.kategori),
                _infoItem('Lebar', kain.lebar),
                _infoItem('Satuan', kain.satuan),
              ],
            ),
            const SizedBox(height: 12),
            if (kain.harga != null) _buildHargaItem('Harga', currencyFormatter.format(kain.harga)),
            if (kain.hargaRoll != null) _buildHargaItem('Harga Roll', currencyFormatter.format(kain.hargaRoll)),
            if (kain.hargaEcer != null) _buildHargaItem('Harga Ecer', currencyFormatter.format(kain.hargaEcer)),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(String value, String text, HeroIcons a, Color color) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          HeroIcon(a, size: 18, color: color),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(color: color)),
        ],
      ),
    );
  }

  Widget _buildHargaItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        children: [
          const HeroIcon(HeroIcons.currencyDollar, size: 16, color: Colors.green),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  void _showDetailBottomSheet(BuildContext context, Kain kain, NumberFormat formatter) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Detail Kain', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 20),
              _buildDetailRow('Nama Kain', kain.nama),
              _buildDetailRow('Kategori', kain.kategori),
              _buildDetailRow('Lebar', kain.lebar),
              if (kain.finish != null) _buildDetailRow('Finish', kain.finish!),
              if (kain.motif != null) _buildDetailRow('Motif', kain.motif!),
              _buildDetailRow('Satuan', kain.satuan),
              const Divider(height: 30),
              if (kain.harga != null) _buildDetailRow('Harga', formatter.format(kain.harga), isTotal: true),
              if (kain.hargaRoll != null) _buildDetailRow('Harga Roll', formatter.format(kain.hargaRoll), isTotal: true),
              if (kain.hargaEcer != null) _buildDetailRow('Harga Ecer', formatter.format(kain.hargaEcer), isTotal: true),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Kain kain) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Kain'),
          content: Text('Anda yakin ingin menghapus ${kain.nama}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                try {
                  await ref.read(kainRepositoryProvider).deleteKain(kain.id);
                  if(mounted) {
                    Navigator.pop(context);
                    showSnackbar(context, '${kain.nama} berhasil dihapus', isError: false);
                  }
                } catch (e) {
                  if(mounted) {
                    Navigator.pop(context);
                    showSnackbar(context, 'Gagal menghapus: ${e.toString()}');
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
}

void showSnackbar(BuildContext context, String message, {bool isError = true}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
      behavior: SnackBarBehavior.floating,
    ),
  );
}

class _FilterBottomSheet extends ConsumerStatefulWidget {
  const _FilterBottomSheet();

  @override
  ConsumerState<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<_FilterBottomSheet> {
  late final TextEditingController _widthController;

  final List<String> _kategoriList = ['Katun', 'Sutra', 'Dobby', 'Rayon'];
  final List<String> _satuanList = ['Yard', 'Meter', 'Pcs'];

  @override
  void initState() {
    super.initState();
    final currentWidthFilter = ref.read(kainWidthFilterProvider);
    _widthController = TextEditingController(text: currentWidthFilter);

    _widthController.addListener(() {
      ref.read(kainWidthFilterProvider.notifier).state = _widthController.text;
    });
  }

  @override
  void dispose() {
    _widthController.dispose();
    super.dispose();
  }

  void _resetFilters() {
    ref.read(kainCategoryFilterProvider.notifier).state = null;
    ref.read(kainUnitFilterProvider.notifier).state = null;
    _widthController.clear();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = ref.watch(kainCategoryFilterProvider);
    final selectedUnit = ref.watch(kainUnitFilterProvider);

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Filter Kain', style: Theme.of(context).textTheme.titleLarge),
              TextButton(onPressed: _resetFilters, child: const Text('Reset'))
            ],
          ),
          const SizedBox(height: 20),

          DropdownButtonFormField<String>(
            value: selectedCategory,
            hint: const Text('Semua Kategori'),
            items: _kategoriList.map((kategori) => DropdownMenuItem(value: kategori, child: Text(kategori))).toList(),
            onChanged: (value) => ref.read(kainCategoryFilterProvider.notifier).state = value,
            decoration: const InputDecoration(labelText: 'Kategori', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _widthController,
            decoration: const InputDecoration(
              labelText: 'Filter Lebar Kain',
              hintText: 'Contoh: 115',
              border: OutlineInputBorder(),
              suffixText: 'cm',
            ),
          ),
          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            value: selectedUnit,
            hint: const Text('Semua Satuan'),
            items: _satuanList.map((satuan) => DropdownMenuItem(value: satuan, child: Text(satuan))).toList(),
            onChanged: (value) => ref.read(kainUnitFilterProvider.notifier).state = value,
            decoration: const InputDecoration(labelText: 'Satuan', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}