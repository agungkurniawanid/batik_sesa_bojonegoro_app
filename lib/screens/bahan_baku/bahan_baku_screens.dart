import 'package:batik_sesa_bojonegoro_app/screens/bahan_baku/add_bahan_baku_screens.dart';
import 'package:batik_sesa_bojonegoro_app/screens/bahan_baku/edit_bahan_baku_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';

class BahanBaku {
  final String nama;
  final String hargaBeli;
  final String ketersediaan;
  final String satuan;

  BahanBaku({
    required this.nama,
    required this.hargaBeli,
    required this.ketersediaan,
    required this.satuan,
  });
}

final List<BahanBaku> daftarBahanBaku = [
  BahanBaku(
    nama: 'Kain Katun Primis',
    hargaBeli: '20.500',
    ketersediaan: '120',
    satuan: 'Lembar/Yard',
  ),
  BahanBaku(
    nama: 'Malam / Lilin',
    hargaBeli: '28.000',
    ketersediaan: '30',
    satuan: 'Biji',
  ),
  BahanBaku(
    nama: 'Water Glass',
    hargaBeli: '260.000',
    ketersediaan: '1',
    satuan: 'Drum',
  ),
  BahanBaku(
    nama: 'Kaporit',
    hargaBeli: '30.000',
    ketersediaan: '10',
    satuan: 'Kg',
  ),
  BahanBaku(
    nama: 'Soda Kue',
    hargaBeli: '15.000',
    ketersediaan: '5',
    satuan: 'Kg',
  ),
  BahanBaku(
    nama: 'Yellow FG',
    hargaBeli: '165.000',
    ketersediaan: '2',
    satuan: 'Kg',
  ),
  BahanBaku(
    nama: 'Black B',
    hargaBeli: '155.000',
    ketersediaan: '1',
    satuan: 'Kg',
  ),
  BahanBaku(
    nama: 'Black N',
    hargaBeli: '177.500',
    ketersediaan: '1',
    satuan: 'Kg',
  ),
  BahanBaku(
    nama: 'Turqis',
    hargaBeli: '120.000',
    ketersediaan: '1',
    satuan: 'Kg',
  ),
  BahanBaku(
    nama: 'Red RR',
    hargaBeli: '145.000',
    ketersediaan: '1',
    satuan: 'Kg',
  ),
  BahanBaku(
    nama: 'OR3R',
    hargaBeli: '255.000',
    ketersediaan: '1',
    satuan: 'Kg',
  ),
  BahanBaku(
    nama: 'Blue RSP',
    hargaBeli: '245.000',
    ketersediaan: '1',
    satuan: 'Kg',
  ),
  BahanBaku(
    nama: 'Blue KMR',
    hargaBeli: '450.000',
    ketersediaan: '1',
    satuan: 'Kg',
  ),
  BahanBaku(
    nama: 'Violet',
    hargaBeli: '240.000',
    ketersediaan: '1',
    satuan: 'Kg',
  ),
  BahanBaku(
    nama: 'Brown GR',
    hargaBeli: '200.000',
    ketersediaan: '1',
    satuan: 'Kg',
  ),
  BahanBaku(
    nama: 'Plastik Kaca',
    hargaBeli: '3.500',
    ketersediaan: '20',
    satuan: 'Lembar',
  ),
  BahanBaku(
    nama: 'Gas Elpiji',
    hargaBeli: '22.000',
    ketersediaan: '7',
    satuan: 'Biji',
  ),
];

class BahanBakuScreen extends ConsumerWidget {
  const BahanBakuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Data Bahan Baku',
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
                          hintText: 'Cari bahan baku...',
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

              // Bahan baku list
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: daftarBahanBaku.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final bahan = daftarBahanBaku[index];
                  return _buildBahanBakuCard(context, bahan);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBahanBakuCard(BuildContext context, BahanBaku bahan) {
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
                    _showDetailBottomSheet(context, bahan);
                  } else if (value == 'edit') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditBahanBakuScreen(bahanBaku: bahan),
                      ),
                    );
                  } else if (value == 'delete') {
                    _showDeleteConfirmation(context, bahan);
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
              _infoItem('Harga Beli', 'Rp ${bahan.hargaBeli}'),
              _infoItem('Ketersediaan', bahan.ketersediaan),
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

  void _showDetailBottomSheet(BuildContext context, BahanBaku bahan) {
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
                'Detail Bahan Baku',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 20),

              // Nama Bahan Baku
              _buildDetailRow('Nama Bahan Baku', bahan.nama, isTotal: false),

              // Harga Beli
              _buildDetailRow(
                'Harga Beli',
                'Rp ${bahan.hargaBeli}',
                isTotal: true,
              ),

              // Ketersediaan
              _buildDetailRow(
                'Ketersediaan',
                bahan.ketersediaan,
                isTotal: false,
              ),

              // Satuan
              _buildDetailRow('Satuan', bahan.satuan, isTotal: false),

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

  void _showDeleteConfirmation(BuildContext context, BahanBaku bahan) {
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
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${bahan.nama} berhasil dihapus'),
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
