import 'package:batik_sesa_bojonegoro_app/core/model/keperluan_model.dart';
import 'package:batik_sesa_bojonegoro_app/core/provider/keperluan_provider.dart';
import 'package:batik_sesa_bojonegoro_app/core/repository/keperluan_repository.dart';
import 'package:batik_sesa_bojonegoro_app/screens/daftar_keperluan/edit_BahanBakuTradisional.dart';
import 'package:batik_sesa_bojonegoro_app/screens/daftar_keperluan/edit_PewarnaBatikModern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import 'add_BahanBakuTradisional.dart';
import 'add_PewarnaBatikModern.dart';

class DaftarKeperluanScreen extends ConsumerWidget {
  const DaftarKeperluanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bahanBakuAsync = ref.watch(bahanBakuTradisionalStreamProvider);
    final pewarnaBatikAsync = ref.watch(pewarnaBatikModernStreamProvider);
    ref.read(keperluanRepositoryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Daftar Keperluan',
          style: TextStyle(
            fontFamily: 'Sriwedari',
            fontWeight: FontWeight.bold,
            fontSize: 32,
            color: Colors.blueAccent,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Bahan Baku Tradisional Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Bahan Baku Tradisional',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const AddBahanBakuTradisionalScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        HeroIcon(HeroIcons.plus, size: 16, color: Colors.white),
                        SizedBox(width: 4),
                        Text('Tambah Data'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Categories for Bahan Baku Tradisional
              _buildCategorySection(
                context,
                'Canting Batik',
                'BahanBakuTradisional',
                bahanBakuAsync,
              ),
              _buildCategorySection(
                context,
                'Wajan dan kompor Batik',
                'BahanBakuTradisional',
                bahanBakuAsync,
              ),
              _buildCategorySection(
                context,
                'Perlengkapan Batik Cap dan Malam',
                'BahanBakuTradisional',
                bahanBakuAsync,
              ),
              _buildCategorySection(
                context,
                'Warna Alam',
                'BahanBakuTradisional',
                bahanBakuAsync,
              ),
              _buildCategorySection(
                context,
                'Bumbu Malam',
                'BahanBakuTradisional',
                bahanBakuAsync,
              ),
              _buildCategorySection(
                context,
                'Kimia Batik',
                'BahanBakuTradisional',
                bahanBakuAsync,
              ),
              const SizedBox(height: 24),

              // Pewarna Batik Modern Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Pewarna Batik Modern',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const AddPewarnaBatikModernScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        HeroIcon(HeroIcons.plus, size: 16, color: Colors.white),
                        SizedBox(width: 4),
                        Text('Tambah Data'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Categories for Pewarna Batik Modern
              _buildCategorySection(
                context,
                'Pewarna Remazol Batik',
                'PewarnaBatikModern',
                pewarnaBatikAsync,
              ),
              _buildCategorySection(
                context,
                'Rapid',
                'PewarnaBatikModern',
                pewarnaBatikAsync,
              ),
              _buildCategorySection(
                context,
                'Indigosol',
                'PewarnaBatikModern',
                pewarnaBatikAsync,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection(
    BuildContext context,
    String category,
    String type,
    AsyncValue<List<dynamic>> asyncData,
  ) {
    return asyncData.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (items) {
        List filteredItems = [];
        if (type == 'BahanBakuTradisional') {
          filteredItems = items.where((item) => item.kategori == category).toList();
        } else {
          filteredItems = items.where((item) => item.kategori == category).toList();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Lihat Semua',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            filteredItems.isEmpty
                ? _buildEmptyDataCard(context, category)
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredItems.length > 3 ? 3 : filteredItems.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      if (type == 'BahanBakuTradisional') {
                        final item = filteredItems[index] as BahanBakuTradisional;
                        return _buildBahanBakuTradisionalItem(context, item);
                      } else {
                        final item = filteredItems[index] as PewarnaBatikModern;
                        return _buildPewarnaBatikModernItem(context, item);
                      }
                    },
                  ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildEmptyDataCard(BuildContext context, String category) {
    return Card(
      color: Colors.orange[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.orange[200]!,
          width: 1,
        ),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange[100],
                shape: BoxShape.circle,
              ),
              child: const HeroIcon(
                HeroIcons.exclamationTriangle,
                size: 20,
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data Kosong',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tidak ada data untuk kategori $category',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBahanBakuTradisionalItem(
    BuildContext context,
    BahanBakuTradisional item,
  ) {
    final repository = ProviderScope.containerOf(context).read(keperluanRepositoryProvider);
    
    // Format harga dengan pemisah ribuan
    final formattedHarga = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(item.harga);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.nama,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              PopupMenuButton(
                icon: const HeroIcon(HeroIcons.ellipsisVertical, size: 20),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        HeroIcon(HeroIcons.pencil, size: 18),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        HeroIcon(HeroIcons.trash, size: 18, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Hapus', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'edit') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditBahanBakuTradisionalScreen(item: item),
                      ),
                    );
                  } else if (value == 'delete') {
                    _showDeleteConfirmation(context, item.id, 'BahanBakuTradisional', repository);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const HeroIcon(HeroIcons.currencyDollar, size: 16, color: Colors.green),
                  const SizedBox(width: 4),
                  Text(
                    formattedHarga,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const HeroIcon(HeroIcons.scale, size: 16, color: Colors.blue),
                  const SizedBox(width: 4),
                  Text(
                    item.satuan,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (item.keterangan.isNotEmpty)
            Row(
              children: [
                const HeroIcon(HeroIcons.informationCircle, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    item.keterangan,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildPewarnaBatikModernItem(
    BuildContext context,
    PewarnaBatikModern item,
  ) {
    final repository = ProviderScope.containerOf(context).read(keperluanRepositoryProvider);
    
    // Format semua harga dengan pemisah ribuan
    final formatHarga = (int harga) => NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(harga);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.nama,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              PopupMenuButton(
                icon: const HeroIcon(HeroIcons.ellipsisVertical, size: 20),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        HeroIcon(HeroIcons.pencil, size: 18),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        HeroIcon(HeroIcons.trash, size: 18, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Hapus', style: TextStyle(color: Colors.red)),
                      ], 
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'edit') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditPewarnaBatikModernScreen(item: item),
                      ),
                    );
                  } else if (value == 'delete') {
                    _showDeleteConfirmation(context, item.id, 'PewarnaBatikModern', repository);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHargaItem('1 Kg', formatHarga(item.harga1kg)),
                  const SizedBox(height: 8),
                  _buildHargaItem('0.5 Kg', formatHarga(item.harga05kg)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHargaItem('0.25 Kg', formatHarga(item.harga025kg)),
                  const SizedBox(height: 8),
                  _buildHargaItem('1 Ons', formatHarga(item.harga1ons)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHargaItem(String label, String harga) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue.shade800,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Row(
          children: [
            const HeroIcon(HeroIcons.currencyDollar, size: 16, color: Colors.green),
            const SizedBox(width: 4),
            Text(
              harga,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    String id,
    String type,
    KeperluanRepository repository,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Data'),
          content: const Text('Anda yakin ingin menghapus data ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                foregroundColor: Colors.red,
              ),
              onPressed: () async {
                try {
                  if (type == 'BahanBakuTradisional') {
                    await repository.deleteBahanBakuTradisional(id);
                  } else {
                    await repository.deletePewarnaBatikModern(id);
                  }
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Data berhasil dihapus'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal menghapus data: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
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