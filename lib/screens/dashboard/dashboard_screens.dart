import 'package:batik_sesa_bojonegoro_app/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(icon: const HeroIcon(HeroIcons.bell), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User Greeting Card
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
                            const HeroIcon(HeroIcons.currencyDollar, size: 40, color: Colors.white,),
                            SizedBox(width: 8),
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
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.arrow_upward,
                                    color: Colors.green,
                                    size: 16,
                                  ),
                                  SizedBox(height: 4),
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
              padding: const EdgeInsets.all(16),
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

            // Recent Transactions
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(top: 8),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Penerimaan Terakhir',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 16),
                    itemBuilder: (context, index) =>
                        _buildTransactionItem(index),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Lihat Semua Penerimaan'),
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

  Widget _buildTransactionItem(int index) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            shape: BoxShape.circle,
          ),
          child: const HeroIcon(HeroIcons.truck, size: 20, color: Colors.blue),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Penerimaan #${1000 + index}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                'Mori Biru Jempol - 10 Yard',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Rp ${150000 + (index * 50000)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '12 Jan 2023',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }
}
