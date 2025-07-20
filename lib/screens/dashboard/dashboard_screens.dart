import 'package:batik_sesa_bojonegoro_app/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Dummy data untuk contoh
    final List<Map<String, dynamic>> transactions = [
      {
        'id': '#1001',
        'item': 'Mori Biru Jempol',
        'quantity': '10 Yard',
        'amount': 150000,
        'date': DateTime(2023, 1, 12),
        'icon': HeroIcons.square2Stack,
        'color': Colors.blue,
      },
      {
        'id': '#1002',
        'item': 'Kain Katun Prima',
        'quantity': '15 Meter',
        'amount': 200000,
        'date': DateTime(2023, 1, 10),
        'icon': HeroIcons.swatch,
        'color': Colors.green,
      },
      {
        'id': '#1003',
        'item': 'Benang Sutra Lux',
        'quantity': '5 Kg',
        'amount': 250000,
        'date': DateTime(2023, 1, 8),
        'icon': HeroIcons.queueList,
        'color': Colors.orange,
      },
      {
        'id': '#1004',
        'item': 'Pewarna Alami',
        'quantity': '8 Botol',
        'amount': 180000,
        'date': DateTime(2023, 1, 5),
        'icon': HeroIcons.paintBrush,
        'color': Colors.purple,
      },
      {
        'id': '#1005',
        'item': 'Canting Tembaga',
        'quantity': '3 Set',
        'amount': 300000,
        'date': DateTime(2023, 1, 3),
        'icon': HeroIcons.wrenchScrewdriver,
        'color': Colors.teal,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const HeroIcon(HeroIcons.adjustmentsHorizontal),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Total Penerimaan Card
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Penerimaan Bulan Ini',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const HeroIcon(HeroIcons.currencyDollar,
                                size: 40, color: Colors.white),
                            const SizedBox(width: 8),
                            const Text(
                              'Rp 12.450.000',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.arrow_upward,
                                    color: Colors.green,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '12% dari bulan lalu',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Quick Menu Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              margin: const EdgeInsets.only(top: 8),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMenuButton(
                        icon: HeroIcons.cube,
                        label: 'Bahan Baku',
                        color: Colors.blue,
                        onTap: () =>
                            Navigator.pushNamed(context, AppRoutes.bahanBaku),
                      ),
                      _buildMenuButton(
                        icon: HeroIcons.swatch,
                        label: 'Daftar Kain',
                        color: Colors.purple,
                        onTap: () =>
                            Navigator.pushNamed(context, AppRoutes.daftarKain),
                      ),
                      _buildMenuButton(
                        icon: HeroIcons.clipboardDocumentList,
                        label: 'Daftar Keperluan',
                        color: Colors.orange,
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.daftarKeperluan,
                        ),
                      ),
                      _buildMenuButton(
                        icon: HeroIcons.users,
                        label: 'Karyawan',
                        color: Colors.green,
                        onTap: () =>
                            Navigator.pushNamed(context, AppRoutes.karyawan),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Penerimaan Terakhir Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              margin: const EdgeInsets.only(top: 8),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Penerimaan Terakhir',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Lihat Semua',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: transactions.map((transaction) {
                      return _buildTransactionCard(transaction, context);
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required HeroIcons icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: HeroIcon(icon, size: 24, color: color),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction, BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon with colored background
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: transaction['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: HeroIcon(
                  transaction['icon'],
                  size: 24,
                  color: transaction['color'],
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Item details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    transaction['item'],
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transaction['quantity'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            // Amount and date
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Rp ${NumberFormat('#,###').format(transaction['amount'])}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateFormat.format(transaction['date']),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}