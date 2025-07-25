import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import '../../core/model/bahan_baku_model.dart';
import '../../core/provider/bahanbaku_provider.dart';
import 'add_bahan_baku_screens.dart';
import 'edit_bahan_baku_screens.dart';

class BahanBakuScreen extends ConsumerWidget {
  const BahanBakuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bahanBakuListAsync = ref.watch(bahanBakuListStreamProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Data Bahan Baku',
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddBahanBakuScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              child: const HeroIcon(
                HeroIcons.plus,
                size: 20,
                color: Colors.white,
                style: HeroIconStyle.outline,
              ),
            ),
          ),
        ],
      ),
      body: bahanBakuListAsync.when(
        data: (bahanBakuList) {
          if (bahanBakuList.isEmpty) {
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
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: bahanBakuList.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final bahan = bahanBakuList[index];
                  return _buildBahanBakuCard(context, ref, bahan);
                },
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Terjadi kesalahan: $error'),
        ),
      ),
    );
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
              'Belum Ada Data Bahan Baku',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tambahkan bahan baku pertama Anda untuk memulai',
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
                    builder: (context) => const AddBahanBakuScreen(),
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
                  Text('Tambah Bahan Baku'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBahanBakuCard(BuildContext context, WidgetRef ref, BahanBaku bahan) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID', 
      symbol: 'Rp ', 
      decimalDigits: 0
    );
    final hargaFormatted = currencyFormatter.format(bahan.hargaBeli);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
                child: const HeroIcon(
                  HeroIcons.cube,
                  size: 20,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  bahan.nama,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
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
                        builder: (context) =>
                            EditBahanBakuScreen(bahanBaku: bahan),
                      ),
                    );
                  } else if (value == 'delete') {
                    _showDeleteConfirmation(context, ref, bahan);
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
              _infoItem('Harga Beli', hargaFormatted),
              _infoItem('Ketersediaan', '${bahan.ketersediaan}'),
              _infoItem('Satuan', bahan.satuan),
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

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, BahanBaku bahan) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Bahan Baku'),
          content: Text('Anda yakin ingin menghapus ${bahan.nama}?'),
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
              onPressed: () {
                ref.read(bahanBakuRepositoryProvider).deleteBahanBaku(bahan.id)
                    .then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${bahan.nama} berhasil dihapus'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal menghapus: $error'),
                      backgroundColor: Colors.red,
                    ),
                  );
                });
                Navigator.pop(context);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }
}
