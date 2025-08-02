import 'package:batik_sesa_bojonegoro_app/core/model/penerimaan_model.dart';
import 'package:batik_sesa_bojonegoro_app/core/provider/penerimaan_provider.dart';
import 'package:batik_sesa_bojonegoro_app/core/provider/pin_provider.dart';
import 'package:batik_sesa_bojonegoro_app/core/routes/app_routes.dart';
import 'package:batik_sesa_bojonegoro_app/screens/dashboard/add_penerimaan_screens.dart';
import 'package:batik_sesa_bojonegoro_app/screens/dashboard/detail_penerimaan_screens.dart';
import 'package:batik_sesa_bojonegoro_app/screens/dashboard/edit_penerimaan_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  StatsData _calculateStats(List<PenerimaanModel> penerimaanList) {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);
    final lastMonth = DateTime(now.year, now.month - 1);
    final currentMonthData = penerimaanList.where((p) {
      final date = DateTime.tryParse(p.tanggal) ?? DateTime.now();
      return date.year == currentMonth.year && date.month == currentMonth.month;
    }).toList();
    final lastMonthData = penerimaanList.where((p) {
      final date = DateTime.tryParse(p.tanggal) ?? DateTime.now();
      return date.year == lastMonth.year && date.month == lastMonth.month;
    }).toList();
    final currentMonthTotal = currentMonthData.fold<num>(
      0,
      (sum, p) => sum + (p.total ?? 0),
    );

    final lastMonthTotal = lastMonthData.fold<num>(
      0,
      (sum, p) => sum + (p.total ?? 0),
    );

    final monthlyGrowth = lastMonthTotal > 0
        ? ((currentMonthTotal - lastMonthTotal) / lastMonthTotal * 100).round()
        : 100;
    final transactionGrowth = lastMonthData.isNotEmpty
        ? ((currentMonthData.length - lastMonthData.length) /
                  lastMonthData.length *
                  100)
              .round()
        : 100;

    return StatsData(
      totalAmount: currentMonthTotal,
      transactionCount: currentMonthData.length,
      monthlyGrowth: monthlyGrowth,
      transactionGrowth: transactionGrowth,
    );
  }

  @override
  Widget build(BuildContext context) {
    final penerimaanAsync = ref.watch(penerimaanStreamProvider);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Dashboard',
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
          IconButton(
            icon: const HeroIcon(
              HeroIcons.adjustmentsHorizontal,
              color: Colors.black54,
              size: 22,
            ),
            onPressed: () => _showSettingsMenu(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selamat ${_getGreeting()}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('EEEE, d MMMM y').format(DateTime.now()),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade100, width: 1),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddPenerimaanScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const HeroIcon(
                            HeroIcons.plus,
                            size: 16,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Tambah Penerimaan',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Stats Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, child) {
                        final penerimaanAsync = ref.watch(
                          penerimaanStreamProvider,
                        );
                        return penerimaanAsync.when(
                          loading: () => _buildStatCard(
                            title: 'Total Penerimaan',
                            value: 'Loading...',
                            icon: HeroIcons.currencyDollar,
                            color: Colors.white,
                            growth: 'Calculating...',
                          ),
                          error: (error, stack) => _buildStatCard(
                            title: 'Total Penerimaan',
                            value: 'Error',
                            icon: HeroIcons.currencyDollar,
                            color: Colors.white,
                            growth: 'N/A',
                          ),
                          data: (penerimaanList) {
                            final stats = _calculateStats(penerimaanList);
                            return _buildStatCard(
                              title: 'Total Penerimaan',
                              value:
                                  'Rp ${NumberFormat('#,###').format(stats.totalAmount)}',
                              icon: HeroIcons.currencyDollar,
                              color: Colors.white,
                              growth: '${stats.monthlyGrowth}% dari bulan lalu',
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, child) {
                        final penerimaanAsync = ref.watch(
                          penerimaanStreamProvider,
                        );
                        return penerimaanAsync.when(
                          loading: () => _buildStatCard(
                            title: 'Total Transaksi',
                            value: 'Loading...',
                            icon: HeroIcons.shoppingBag,
                            color: Colors.white,
                            growth: 'Calculating...',
                          ),
                          error: (error, stack) => _buildStatCard(
                            title: 'Total Transaksi',
                            value: 'Error',
                            icon: HeroIcons.shoppingBag,
                            color: Colors.white,
                            growth: 'N/A',
                          ),
                          data: (penerimaanList) {
                            final stats = _calculateStats(penerimaanList);
                            return _buildStatCard(
                              title: 'Total Transaksi',
                              value: '${stats.transactionCount}',
                              icon: HeroIcons.shoppingBag,
                              color: Colors.white,
                              growth:
                                  '${stats.transactionGrowth}% dari bulan lalu',
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Quick Menu Section
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 8, bottom: 12),
                    child: Text(
                      'Menu Cepat',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 4,
                    childAspectRatio: 0.9,
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

            const SizedBox(height: 16),
            // Bagian penerimaanAsync.when yang diperbaiki
            penerimaanAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, stack) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Gagal Memuat Data',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          error.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () =>
                            ref.invalidate(penerimaanStreamProvider),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                );
              },
              data: (penerimaanList) {
                // Handle empty data state lebih aman
                if (penerimaanList.isEmpty ||
                    penerimaanList.every((e) => e.id.isEmpty)) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Penerimaan Terakhir',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Column(
                            children: [
                              Icon(
                                Icons.receipt_long,
                                size: 100,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Belum Ada Data Penerimaan',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                child: Text(
                                  'Mulai dengan menambahkan data penerimaan baru',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AddPenerimaanScreen(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Tambah Penerimaan',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Filter data yang valid
                final validPenerimaan = penerimaanList
                    .where((e) => e.id.isNotEmpty)
                    .toList();
                if (validPenerimaan.isEmpty) {
                  return const SizedBox.shrink(); // Fallback jika semua data tidak valid
                }

                final lastPenerimaan = validPenerimaan.take(10).toList();

                return Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
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
                          const Text(
                            'Penerimaan Terakhir',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const DetailPenerimaanScreen(),
                                ),
                              );
                            },
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
                      ...lastPenerimaan.map((penerimaan) {
                        return _buildPenerimaanCard(penerimaan, context, ref);
                      }).toList(),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) return 'Pagi';
    if (hour < 15) return 'Siang';
    if (hour < 18) return 'Sore';
    return 'Malam';
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required HeroIcons icon,
    required Color color,
    required String growth,
  }) {
    final isPositive = !growth.contains('-') && growth != '0%';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: HeroIcon(icon, size: 20, color: color),
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                  color: isPositive ? Colors.green : Colors.red,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  growth,
                  style: TextStyle(
                    fontSize: 12,
                    color: isPositive ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton({
    required HeroIcons icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: HeroIcon(icon, size: 24, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPenerimaanCard(
    PenerimaanModel penerimaan,
    BuildContext context,
    WidgetRef ref,
  ) {
    final dateFormat = DateFormat('dd MMM yyyy');
    final currencyFormat = NumberFormat('#,###');
    final tanggal = DateTime.tryParse(penerimaan.tanggal) ?? DateTime.now();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Icon dan Judul + Menu
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
                  HeroIcons.shoppingBag,
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
                      penerimaan.transaksi,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      penerimaan.pembeli,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                icon: const Icon(Icons.more_vert, color: Colors.black54),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'detail',
                    child: Row(
                      children: const [
                        HeroIcon(HeroIcons.eye, size: 18),
                        SizedBox(width: 8),
                        Text('Detail'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: const [
                        HeroIcon(HeroIcons.pencil, size: 18),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: const [
                        HeroIcon(HeroIcons.trash, size: 18, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Hapus', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) async {
                  if (value == 'detail') {
                    _showDetailBottomSheet(context, penerimaan);
                  } else if (value == 'edit') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditPenerimaanScreen(penerimaan: penerimaan),
                      ),
                    );
                  } else if (value == 'delete') {
                    await _showDeleteConfirmation(context, penerimaan, ref);
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
              Text(
                'Rp ${currencyFormat.format(penerimaan.hargaSatuan)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                '${penerimaan.kuantitas} ${penerimaan.satuan}',
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Tanggal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: Rp ${currencyFormat.format(penerimaan.total)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                dateFormat.format(tanggal),
                style: const TextStyle(fontSize: 12, color: Colors.black45),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDetailBottomSheet(
    BuildContext context,
    PenerimaanModel penerimaan,
  ) {
    final dateFormat = DateFormat('dd MMMM yyyy');
    final currencyFormat = NumberFormat('#,###');
    final tanggal = DateTime.tryParse(penerimaan.tanggal) ?? DateTime.now();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
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
              const Text(
                'Detail Penerimaan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildDetailRow('Tanggal', dateFormat.format(tanggal)),
              _buildDetailRow('Transaksi', penerimaan.transaksi),
              _buildDetailRow('Pembeli', penerimaan.pembeli),
              _buildDetailRow(
                'Quantity',
                '${penerimaan.kuantitas} ${penerimaan.satuan}',
              ),
              _buildDetailRow(
                'Harga Satuan',
                'Rp ${currencyFormat.format(penerimaan.hargaSatuan)}',
              ),
              if (penerimaan.keterangan?.isNotEmpty ?? false)
                _buildDetailRow('Keterangan', penerimaan.keterangan!),
              const Divider(height: 30),
              _buildDetailRow(
                'Total',
                'Rp ${currencyFormat.format(penerimaan.total)}',
                isTotal: true,
              ),
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
              color: isTotal ? Colors.blue : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmation(
    BuildContext context,
    PenerimaanModel penerimaan,
    WidgetRef ref,
  ) async {
    final repository = ref.read(penerimaanRepositoryProvider);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text(
          'Apakah Anda yakin ingin menghapus penerimaan ${penerimaan.transaksi}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await repository.deletePenerimaan(penerimaan.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Penerimaan ${penerimaan.transaksi} dihapus'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal menghapus: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _showSettingsMenu() {
    final pinState = ref.read(pinProvider);
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Iconsax.lock),
                title: const Text('Ubah PIN'),
                onTap: () {
                  Navigator.pop(context);
                  _showChangePinDialog(context, ref);
                },
              ),
              ListTile(
                leading: Icon(
                  pinState.isPinEnabled
                      ? Iconsax.toggle_on
                      : Iconsax.toggle_off,
                  color: pinState.isPinEnabled ? Colors.green : Colors.red,
                ),
                title: Text(
                  pinState.isPinEnabled
                      ? 'Nonaktifkan PIN (Aktif)'
                      : 'Aktifkan PIN (Nonaktif)',
                ),
                subtitle: Text(
                  pinState.isPinEnabled
                      ? 'PIN sedang aktif'
                      : 'PIN sedang nonaktif',
                  style: TextStyle(
                    color: pinState.isPinEnabled ? Colors.green : Colors.red,
                  ),
                ),
                onTap: () {
                  final newState = !pinState.isPinEnabled;
                  ref
                      .read(pinProvider.notifier)
                      .togglePinEnabled(newState, context);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Iconsax.refresh),
                title: const Text('Atur Ulang PIN'),
                onTap: () {
                  Navigator.pop(context);
                  _showResetPinConfirmation(context, ref);
                },
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tutup'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showChangePinDialog(BuildContext context, WidgetRef ref) {
    final currentPinController = TextEditingController();
    final newPinController = TextEditingController();
    final confirmPinController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ubah PIN'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: currentPinController,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: const InputDecoration(
                    labelText: 'PIN Saat Ini',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: newPinController,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: const InputDecoration(
                    labelText: 'PIN Baru (6 digit)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: confirmPinController,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: const InputDecoration(
                    labelText: 'Konfirmasi PIN Baru',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final currentPin = currentPinController.text;
                final newPin = newPinController.text;
                final confirmPin = confirmPinController.text;

                if (currentPin.length != 6 ||
                    newPin.length != 6 ||
                    confirmPin.length != 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('PIN harus 6 digit'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                if (!ref.read(pinProvider.notifier).verifyPin(currentPin)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('PIN saat ini salah'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                if (newPin != confirmPin) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Konfirmasi PIN tidak cocok'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                try {
                  await ref.read(pinProvider.notifier).updatePin(newPin);
                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('PIN berhasil diubah'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Gagal mengubah PIN: ${e.toString()}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showResetPinConfirmation(BuildContext context, WidgetRef ref) {
    final currentPinState = ref.read(pinProvider);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Atur Ulang PIN'),
          content: const Text(
            'Apakah Anda yakin ingin mengatur ulang PIN ke default (123456)?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                ref
                    .read(pinProvider.notifier)
                    .resetPin(keepEnabledStatus: currentPinState.isPinEnabled);

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('PIN telah direset ke default'),
                    action: SnackBarAction(label: 'OK', onPressed: () {}),
                  ),
                );
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }
}
