import 'package:batik_sesa_bojonegoro_app/screens/daftar_kain/add_kain_screens.dart';
import 'package:batik_sesa_bojonegoro_app/screens/daftar_kain/edit_kain_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';

class Kain {
  final String nama;
  final String kategori;
  final String lebar;
  final String finish;
  final String harga;
  final String? hargaKedua;
  final String satuan;
  final String? motif;

  Kain({
    required this.nama,
    required this.kategori,
    required this.lebar,
    required this.finish,
    required this.harga,
    this.hargaKedua,
    required this.satuan,
    this.motif,
  });
}

final List<Kain> daftarKain = [
  Kain(
    nama: 'Mori Biru Jempol',
    kategori: 'Katun',
    lebar: '115 cm',
    finish: 'BMS',
    harga: 'Rp 10.500',
    satuan: 'Yard',
  ),
  Kain(
    nama: 'Sutra 654 grade 1',
    kategori: 'Sutra',
    lebar: '115 cm',
    finish: '-',
    harga: 'Rp 185.000 (Roll)',
    hargaKedua: 'Rp 190.000 (Ecer)',
    satuan: 'Yard',
  ),
  Kain(
    nama: 'Rayon Banci',
    kategori: 'Rayon',
    lebar: '115 cm',
    finish: 'Bleaching',
    harga: 'Rp 10.000',
    satuan: 'Yard',
  ),
  Kain(
    nama: 'Dobby C/S',
    kategori: 'Doby Katun Viscose',
    lebar: '115 cm',
    finish: 'Kristal',
    harga: 'Rp 16.000',
    satuan: 'Yard',
    motif: 'Kristal',
  ),
];

class DaftarKainScreen extends ConsumerWidget {
  const DaftarKainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Daftar Kain',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
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
                    builder: (context) => const AddKainScreen(),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Search and filter bar
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          hintText: 'Cari kain...',
                          border: InputBorder.none,
                          prefixIcon: const HeroIcon(
                            HeroIcons.magnifyingGlass,
                            size: 20,
                          ),
                          suffixIcon: IconButton(
                            icon: const HeroIcon(HeroIcons.xMark, size: 20),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const HeroIcon(HeroIcons.funnel, size: 20),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Fabric list
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: daftarKain.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final kain = daftarKain[index];
                  return _buildKainCard(context, kain);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKainCard(BuildContext context, Kain kain) {
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
          // Header
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
                  HeroIcons.swatch,
                  size: 20,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  kain.nama,
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
                    value: 'detail',
                    child: Row(
                      children: [
                        HeroIcon(HeroIcons.eye, size: 18),
                        SizedBox(width: 8),
                        Text('Detail'),
                      ],
                    ),
                  ),
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
                  if (value == 'detail') {
                    _showDetailBottomSheet(context, kain);
                  } else if (value == 'edit') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditKainScreen(kain: kain),
                      ),
                    ).then((updatedKain) {
                      if (updatedKain != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${kain.nama} berhasil diupdate'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    });
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
          kain.kategori == 'Sutra' && kain.hargaKedua != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHargaItem(kain.harga),
                    const SizedBox(height: 4),
                    _buildHargaItem(kain.hargaKedua!),
                  ],
                )
              : _buildHargaItem(kain.harga),
        ],
      ),
    );
  }

  Widget _buildHargaItem(String hargaText) {
    return Row(
      children: [
        const HeroIcon(HeroIcons.currencyDollar, size: 20, color: Colors.green),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            hargaText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ),
      ],
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

  void _showDetailBottomSheet(BuildContext context, Kain kain) {
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

              // Header
              Text(
                'Detail Kain',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 20),

              // Nama Kain
              _buildDetailRow('Nama Kain', kain.nama, isTotal: false),

              // Kategori
              _buildDetailRow('Kategori', kain.kategori, isTotal: false),

              // Lebar
              _buildDetailRow('Lebar', kain.lebar, isTotal: false),

              // Finish
              _buildDetailRow('Finish', kain.finish, isTotal: false),

              // Motif (jika ada)
              if (kain.motif != null)
                _buildDetailRow('Motif', kain.motif!, isTotal: false),

              // Satuan
              _buildDetailRow('Satuan', kain.satuan, isTotal: false),

              const Divider(height: 30),

              // Harga - menampilkan berbeda untuk kategori Sutra
              if (kain.kategori == 'Sutra' && kain.hargaKedua != null) ...[
                _buildDetailRow('Harga Roll', kain.harga, isTotal: true),
                const SizedBox(height: 8),
                _buildDetailRow('Harga Ecer', kain.hargaKedua!, isTotal: true),
              ] else
                _buildDetailRow('Harga', kain.harga, isTotal: true),

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
                backgroundColor: Colors.red.shade50,
                foregroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${kain.nama} berhasil dihapus'),
                    duration: const Duration(seconds: 2),
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
