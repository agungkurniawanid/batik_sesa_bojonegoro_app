import 'package:batik_sesa_bojonegoro_app/screens/daftar_kain/add_kain_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';

class Kain {
  final String nama;
  final String kategori;
  final String lebar;
  final String finish;
  final String harga;
  final String satuan;
  final String? motif;

  Kain({
    required this.nama,
    required this.kategori,
    required this.lebar,
    required this.finish,
    required this.harga,
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
    harga: 'Rp 185.000 (Roll) / Rp 190.000 (Ecer)',
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
      backgroundColor: Colors.grey[10],
      appBar: AppBar(
        title: const Text(
          'Daftar Kain',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const HeroIcon(HeroIcons.plus, size: 22),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddKainScreen(),
                ),
              );
            },
            tooltip: 'Tambah Kain',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ListView.separated(
          itemCount: daftarKain.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final kain = daftarKain[index];
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => _showDetailBottomSheet(context, kain),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with fabric icon and name
                      Row(
                        children: [
                          const HeroIcon(
                            HeroIcons.swatch,
                            size: 20,
                            color: Colors.blueAccent,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              kain.nama,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.blueAccent,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
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
                                    HeroIcon(HeroIcons.trash, size: 18),
                                    SizedBox(width: 8),
                                    Text('Hapus'),
                                  ],
                                ),
                              ),
                            ],
                            onSelected: (value) {
                              if (value == 'detail') {
                                _showDetailBottomSheet(context, kain);
                              } else if (value == 'edit') {
                                _showEditDialog(context, kain);
                              } else if (value == 'delete') {
                                _showDeleteConfirmation(context, kain);
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      
                      // Category and Width
                      Row(
                        children: [
                          _buildInfoItem(
                            icon: HeroIcons.tag,
                            label: 'Kategori',
                            value: kain.kategori,
                            iconColor: Colors.purple,
                          ),
                          const SizedBox(width: 16),
                          _buildInfoItem(
                            icon: HeroIcons.arrowsPointingOut,
                            label: 'Lebar',
                            value: kain.lebar,
                            iconColor: Colors.teal,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      
                      // Finish and Unit
                      Row(
                        children: [
                          _buildInfoItem(
                            icon: HeroIcons.sparkles,
                            label: 'Finish',
                            value: kain.finish,
                            iconColor: Colors.amber,
                          ),
                          const SizedBox(width: 16),
                          _buildInfoItem(
                            icon: HeroIcons.scale,
                            label: 'Satuan',
                            value: kain.satuan,
                            iconColor: Colors.indigo,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      
                      if (kain.motif != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _buildInfoItem(
                            icon: HeroIcons.squares2x2,
                            label: 'Motif',
                            value: kain.motif!,
                            iconColor: Colors.pink,
                          ),
                        ),
                      
                      // Price section with accent background
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const HeroIcon(
                              HeroIcons.currencyDollar,
                              size: 18,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                kain.harga,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required HeroIcons icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeroIcon(
            icon,
            size: 16,
            color: iconColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDetailBottomSheet(BuildContext context, Kain kain) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const HeroIcon(
                    HeroIcons.swatch,
                    size: 24,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    kain.nama,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildDetailItem('Kategori', kain.kategori, HeroIcons.tag, Colors.purple),
              _buildDetailItem('Lebar', kain.lebar, HeroIcons.arrowsPointingOut, Colors.teal),
              _buildDetailItem('Finish', kain.finish, HeroIcons.sparkles, Colors.amber),
              if (kain.motif != null)
                _buildDetailItem('Motif', kain.motif!, HeroIcons.squares2x2, Colors.pink),
              _buildDetailItem('Satuan', kain.satuan, HeroIcons.scale, Colors.indigo),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const HeroIcon(
                      HeroIcons.currencyDollar,
                      size: 24,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        kain.harga,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const HeroIcon(HeroIcons.pencil, size: 18),
                      label: const Text('Edit'),
                      onPressed: () {
                        Navigator.pop(context);
                        _showEditDialog(context, kain);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.blue.shade300),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const HeroIcon(HeroIcons.trash, size: 18),
                      label: const Text('Hapus'),
                      onPressed: () {
                        Navigator.pop(context);
                        _showDeleteConfirmation(context, kain);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade50,
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(String label, String value, HeroIcons icon, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeroIcon(
            icon,
            size: 20,
            color: iconColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, Kain kain) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Kain'),
          content: const Text('Fitur edit akan diimplementasikan di sini.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                // Implement edit functionality here
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${kain.nama} berhasil diupdate'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
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
                // Implement delete functionality here
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