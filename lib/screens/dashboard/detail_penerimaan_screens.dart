import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:heroicons/heroicons.dart';
import 'package:batik_sesa_bojonegoro_app/core/model/penerimaan_model.dart';
import 'package:batik_sesa_bojonegoro_app/core/provider/penerimaan_provider.dart';
import 'package:batik_sesa_bojonegoro_app/screens/dashboard/edit_penerimaan_screen.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class DetailPenerimaanScreen extends ConsumerStatefulWidget {
  const DetailPenerimaanScreen({super.key});

  @override
  ConsumerState<DetailPenerimaanScreen> createState() =>
      _DetailPenerimaanScreenState();
}

class _DetailPenerimaanScreenState
    extends ConsumerState<DetailPenerimaanScreen> {
  String _selectedFilter = 'hari';
  String _sortOrder = 'terbesar';
  DateTime? _selectedMonth;
  DateTime? _selectedYear;

  @override
  Widget build(BuildContext context) {
    final penerimaanAsync = ref.watch(penerimaanStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Penerimaan'),
        centerTitle: true,
        leading: IconButton(
          icon: const HeroIcon(HeroIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: penerimaanAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (allPenerimaan) {
          final filteredPenerimaan = _applyFilters(allPenerimaan);

          return Column(
            children: [
              // Filter Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Filter Buttons
                    Row(
                      children: [
                        _buildFilterButton('hari', 'Hari Ini', allPenerimaan),
                        _buildFilterButton(
                          'minggu',
                          'Minggu Ini',
                          allPenerimaan,
                        ),
                        _buildFilterButton('bulan', 'Bulan', allPenerimaan),
                        _buildFilterButton('tahun', 'Tahun', allPenerimaan),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Sort Dropdown
                    DropdownButtonFormField<String>(
                      value: _sortOrder,
                      items: const [
                        DropdownMenuItem(
                          value: 'terbesar',
                          child: Text('Total Tertinggi'),
                        ),
                        DropdownMenuItem(
                          value: 'terkecil',
                          child: Text('Total Terendah'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _sortOrder = value!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Urutkan',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // List of Penerimaan
              Expanded(
                child: filteredPenerimaan.isEmpty
                    ? const Center(child: Text('Tidak ada data penerimaan'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredPenerimaan.length,
                        itemBuilder: (context, index) {
                          return _buildPenerimaanCard(
                            filteredPenerimaan[index],
                            context,
                            ref,
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<PenerimaanModel> _applyFilters(List<PenerimaanModel> allPenerimaan) {
    final now = DateTime.now();
    List<PenerimaanModel> filtered = allPenerimaan;

    // Apply time filter
    filtered = filtered.where((p) {
      final date = DateTime.tryParse(p.tanggal) ?? DateTime.now();
      switch (_selectedFilter) {
        case 'hari':
          return date.year == now.year &&
              date.month == now.month &&
              date.day == now.day;
        case 'minggu':
          final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
          final endOfWeek = startOfWeek.add(const Duration(days: 6));
          return date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
              date.isBefore(endOfWeek.add(const Duration(days: 1)));
        case 'bulan':
          if (_selectedMonth != null) {
            return date.year == _selectedMonth!.year &&
                date.month == _selectedMonth!.month;
          }
          return date.year == now.year && date.month == now.month;
        case 'tahun':
          if (_selectedYear != null) {
            return date.year == _selectedYear!.year;
          }
          return date.year == now.year;
        default:
          return true;
      }
    }).toList();

    // Apply sorting
    filtered.sort((a, b) {
      return _sortOrder == 'terbesar'
          ? b.total.compareTo(a.total)
          : a.total.compareTo(b.total);
    });

    return filtered;
  }

  Widget _buildFilterButton(
    String filterType,
    String label,
    List<PenerimaanModel> allPenerimaan,
  ) {
    final isSelected = _selectedFilter == filterType;
    final isMonthYear = filterType == 'bulan' || filterType == 'tahun';
    final orangeColor = Colors.blueAccent;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (filterType == 'bulan') {
            _selectMonth(context);
          } else if (filterType == 'tahun') {
            _selectYear(context);
          } else {
            setState(() {
              _selectedFilter = filterType;
              _selectedMonth = null;
              _selectedYear = null;
            });
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? orangeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: orangeColor, width: 1),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : orangeColor,
                ),
              ),
              if (isMonthYear && isSelected)
                Text(
                  filterType == 'bulan'
                      ? _selectedMonth != null
                            ? DateFormat('MMM yyyy').format(_selectedMonth!)
                            : DateFormat('MMM yyyy').format(DateTime.now())
                      : _selectedYear != null
                      ? _selectedYear!.year.toString()
                      : DateTime.now().year.toString(),
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectMonth(BuildContext context) async {
    final DateTime? picked = await showMonthPicker(
      context: context,
      initialDate: _selectedMonth ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedMonth = DateTime(picked.year, picked.month);
        _selectedFilter = 'bulan';
      });
    }
  }

  Future<void> _selectYear(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 300,
          child: YearPicker(
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            initialDate: _selectedYear ?? DateTime.now(),
            selectedDate: _selectedYear ?? DateTime.now(),
            onChanged: (DateTime dateTime) {
              setState(() {
                _selectedYear = DateTime(dateTime.year);
                _selectedFilter = 'tahun';
              });
              Navigator.pop(context);
            },
          ),
        );
      },
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
}
