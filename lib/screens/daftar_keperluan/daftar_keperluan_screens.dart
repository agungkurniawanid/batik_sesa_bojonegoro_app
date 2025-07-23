import 'package:batik_sesa_bojonegoro_app/screens/daftar_keperluan/edit_BahanBakuTradisional.dart';
import 'package:batik_sesa_bojonegoro_app/screens/daftar_keperluan/edit_PewarnaBatikModern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'add_BahanBakuTradisional.dart';
import 'add_PewarnaBatikModern.dart';

class BahanBakuTradisional {
  final String id;
  final String kategori;
  final String nama;
  final int harga;
  final String satuan;
  final String keterangan;

  BahanBakuTradisional({
    required this.id,
    required this.kategori,
    required this.nama,
    required this.harga,
    required this.satuan,
    required this.keterangan,
  });
}

class PewarnaBatikModern {
  final String id;
  final String kategori;
  final String nama;
  final int harga1kg;
  final int harga05kg;
  final int harga025kg;
  final int harga1ons;

  PewarnaBatikModern({
    required this.id,
    required this.kategori,
    required this.nama,
    required this.harga1kg,
    required this.harga05kg,
    required this.harga025kg,
    required this.harga1ons,
  });
}

final List<BahanBakuTradisional> daftarBahanBakuTradisional = [
  BahanBakuTradisional(
    id: '1',
    kategori: 'Canting Batik',
    nama: 'canting kuningan no 1',
    harga: 2500,
    satuan: 'biji',
    keterangan: 'cucuk 1',
  ),
  BahanBakuTradisional(
    id: '2',
    kategori: 'Canting Batik',
    nama: 'canting tembaga no 1',
    harga: 3000,
    satuan: 'biji',
    keterangan: 'cucuk 1',
  ),
  BahanBakuTradisional(
    id: '3',
    kategori: 'Wajan dan kompor Batik',
    nama: 'wajan canting',
    harga: 10000,
    satuan: 'biji',
    keterangan: 'wajan',
  ),
  BahanBakuTradisional(
    id: '4',
    kategori: 'Wajan dan kompor Batik',
    nama: 'loyang cap',
    harga: 210000,
    satuan: 'per kg',
    keterangan: 'berat kurang lebih 2,8 kg',
  ),
];

final List<PewarnaBatikModern> daftarPewarnaBatikModern = [
  PewarnaBatikModern(
    id: '1',
    kategori: 'Pewarna Remazol Batik',
    nama: 'remazol yellow FG 150%',
    harga1kg: 137000,
    harga05kg: 69000,
    harga025kg: 34500,
    harga1ons: 19000,
  ),
  PewarnaBatikModern(
    id: '2',
    kategori: 'Rapid',
    nama: 'rapid hitam',
    harga1kg: 140000,
    harga05kg: 70000,
    harga025kg: 37500,
    harga1ons: 19000,
  ),
  PewarnaBatikModern(
    id: '3',
    kategori: 'Indigosol',
    nama: 'Biru O4B',
    harga1kg: 390000,
    harga05kg: 195000,
    harga025kg: 100000,
    harga1ons: 44000,
  ),
];

class DaftarKeperluanScreen extends ConsumerWidget {
  const DaftarKeperluanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                          builder: (context) => const AddBahanBakuTradisionalScreen(),
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
              _buildCategorySection(context, 'Canting Batik', 'BahanBakuTradisional'),
              _buildCategorySection(context, 'Wajan dan kompor Batik', 'BahanBakuTradisional'),
              _buildCategorySection(context, 'Perlengkapan Batik Cap dan Malam', 'BahanBakuTradisional'),
              _buildCategorySection(context, 'Warna Alam', 'BahanBakuTradisional'),
              _buildCategorySection(context, 'Bumbu Malam', 'BahanBakuTradisional'),
              _buildCategorySection(context, 'Kimia Batik', 'BahanBakuTradisional'),
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
                          builder: (context) => const AddPewarnaBatikModernScreen(),
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
              _buildCategorySection(context, 'Pewarna Remazol Batik', 'PewarnaBatikModern'),
              _buildCategorySection(context, 'Rapid', 'PewarnaBatikModern'),
              _buildCategorySection(context, 'Indigosol', 'PewarnaBatikModern'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, String category, String type) {
    List items = [];
    if (type == 'BahanBakuTradisional') {
      items = daftarBahanBakuTradisional.where((item) => item.kategori == category).toList();
    } else {
      items = daftarPewarnaBatikModern.where((item) => item.kategori == category).toList();
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
              onPressed: () {
                
              },
              child: const Text(
                'Lihat Semua',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        items.isEmpty
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Belum ada data',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length > 3 ? 3 : items.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  if (type == 'BahanBakuTradisional') {
                    final item = items[index] as BahanBakuTradisional;
                    return _buildBahanBakuTradisionalItem(context, item);
                  } else {
                    final item = items[index] as PewarnaBatikModern;
                    return _buildPewarnaBatikModernItem(context, item);
                  }
                },
              ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildBahanBakuTradisionalItem(BuildContext context, BahanBakuTradisional item) {
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
              Text(
                item.nama,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
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
                    _showDeleteConfirmation(context, item.id, 'BahanBakuTradisional');
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Rp ${item.harga}'),
              Text(item.satuan),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            item.keterangan,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildPewarnaBatikModernItem(BuildContext context, PewarnaBatikModern item) {
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
              Text(
                item.nama,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
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
                    _showDeleteConfirmation(context, item.id, 'PewarnaBatikModern');
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('1 Kg: Rp ${item.harga1kg}'),
                  Text('0.5 Kg: Rp ${item.harga05kg}'),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('0.25 Kg: Rp ${item.harga025kg}'),
                  Text('1 Ons: Rp ${item.harga1ons}'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String id, String type) {
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
              onPressed: () {
                // Implement delete logic here
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Data berhasil dihapus'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }
}