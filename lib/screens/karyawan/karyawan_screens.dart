import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'add_karyawan_screens.dart';
import 'add_gaji_screens.dart';
import 'edit_karyawan_screens.dart';
import 'edit_gaji_screens.dart';

class Karyawan {
  final String id;
  final String nama;
  final String alamat;
  final String status;

  Karyawan({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.status,
  });
}

class Gaji {
  final String id;
  final String karyawanId;
  final String bulan;
  final String tahun;
  final int jumlahKain;
  final int totalGaji;

  Gaji({
    required this.id,
    required this.karyawanId,
    required this.bulan,
    required this.tahun,
    required this.jumlahKain,
    required this.totalGaji,
  });
}

final List<Karyawan> daftarKaryawan = [
  Karyawan(
    id: '1',
    nama: 'Rumini',
    alamat: 'Jono RT.16',
    status: 'Karyawan Tetap',
  ),
  Karyawan(
    id: '2',
    nama: 'Katiyem',
    alamat: 'Jono RT.16',
    status: 'Karyawan Tetap',
  ),
  Karyawan(id: '3', nama: 'Candra', alamat: 'Belun', status: 'Karyawan Tetap'),
];

final List<Gaji> daftarGaji = [
  Gaji(
    id: '1',
    karyawanId: '1',
    bulan: 'Januari',
    tahun: '2023',
    jumlahKain: 28,
    totalGaji: 700000,
  ),
  Gaji(
    id: '2',
    karyawanId: '2',
    bulan: 'Januari',
    tahun: '2023',
    jumlahKain: 30,
    totalGaji: 750000,
  ),
  Gaji(
    id: '3',
    karyawanId: '3',
    bulan: 'Januari',
    tahun: '2023',
    jumlahKain: 32,
    totalGaji: 800000,
  ),
];

class KaryawanScreen extends ConsumerWidget {
  const KaryawanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Data Karyawan',
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
              // Daftar Karyawan Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Daftar Karyawan',
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
                          builder: (context) => const AddKaryawanScreen(),
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
                        Text('Tambah Karyawan'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: daftarKaryawan.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final karyawan = daftarKaryawan[index];
                  return _buildKaryawanCard(context, karyawan);
                },
              ),
              const SizedBox(height: 24),

              // Daftar Gaji Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Daftar Gaji',
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
                          builder: (context) => const AddGajiScreen(),
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
                        Text('Tambah Gaji'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: daftarGaji.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final gaji = daftarGaji[index];
                  final karyawan = daftarKaryawan.firstWhere(
                    (k) => k.id == gaji.karyawanId,
                    orElse: () => Karyawan(
                      id: '',
                      nama: 'Unknown',
                      alamat: '',
                      status: '',
                    ),
                  );
                  return _buildGajiCard(context, gaji, karyawan);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKaryawanCard(BuildContext context, Karyawan karyawan) {
    return Container(
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
                  HeroIcons.user,
                  size: 20,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      karyawan.nama,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      karyawan.alamat,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      karyawan.status,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
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
                            EditKaryawanScreen(karyawan: karyawan),
                      ),
                    );
                  } else if (value == 'delete') {
                    _showDeleteKaryawanConfirmation(context, karyawan);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGajiCard(BuildContext context, Gaji gaji, Karyawan karyawan) {
    return Container(
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
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const HeroIcon(
                  HeroIcons.currencyDollar,
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
                      karyawan.nama,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${gaji.bulan} ${gaji.tahun}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
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
                        builder: (context) => EditGajiScreen(gaji: gaji),
                      ),
                    );
                  } else if (value == 'delete') {
                    _showDeleteGajiConfirmation(context, gaji);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Colors.grey, thickness: 0.3),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _gajiInfoItem('Jumlah Kain', '${gaji.jumlahKain} Lembar'),
              _gajiInfoItem('Total Gaji', 'Rp ${gaji.totalGaji}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _gajiInfoItem(String label, String value) {
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

  void _showDeleteKaryawanConfirmation(
    BuildContext context,
    Karyawan karyawan,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Karyawan'),
          content: Text('Anda yakin ingin menghapus ${karyawan.nama}?'),
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
                    content: Text('${karyawan.nama} berhasil dihapus'),
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

  void _showDeleteGajiConfirmation(BuildContext context, Gaji gaji) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Data Gaji'),
          content: const Text('Anda yakin ingin menghapus data gaji ini?'),
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
                  const SnackBar(
                    content: Text('Data gaji berhasil dihapus'),
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
