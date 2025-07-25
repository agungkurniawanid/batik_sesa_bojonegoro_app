import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';

import '../../core/model/gaji_karyawan_model.dart';
import '../../core/provider/gaji_karyawan_provider.dart';
import '../daftar_kain/daftar_kain_screens.dart';


class EditGajiScreen extends ConsumerStatefulWidget {
  final Gaji gaji;

  const EditGajiScreen({super.key, required this.gaji});

  @override
  ConsumerState<EditGajiScreen> createState() => _EditGajiScreenState();
}

class _EditGajiScreenState extends ConsumerState<EditGajiScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _bulanController;
  late final TextEditingController _tahunController;
  late final TextEditingController _jumlahKainController;
  late final TextEditingController _totalGajiController;

  String? _selectedKaryawanId;
  String? _selectedBulan;
  bool _isLoading = false;

  final List<String> _bulanList = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  @override
  void initState() {
    super.initState();
    // Inisialisasi state dan controller dari data gaji yang ada
    _selectedKaryawanId = widget.gaji.karyawanId;
    _selectedBulan = widget.gaji.bulan;

    _bulanController = TextEditingController(text: widget.gaji.bulan);
    _tahunController = TextEditingController(text: widget.gaji.tahun);
    _jumlahKainController = TextEditingController(text: widget.gaji.jumlahKain.toString());
    _totalGajiController = TextEditingController(text: widget.gaji.totalGaji.toString());

    _jumlahKainController.addListener(_calculateGaji);
  }

  @override
  void dispose() {
    _bulanController.dispose();
    _tahunController.dispose();
    _jumlahKainController.dispose();
    _totalGajiController.dispose();
    super.dispose();
  }

  void _calculateGaji() {
    if (_jumlahKainController.text.isEmpty) {
      _totalGajiController.clear();
      return;
    }
    final jumlahKain = int.tryParse(_jumlahKainController.text) ?? 0;
    final totalGaji = jumlahKain * 25000; // Tarif: Rp 25.000 per lembar
    _totalGajiController.text = totalGaji.toString();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final gajiUpdate = Gaji(
        id: widget.gaji.id, // Gunakan ID yang sama untuk update
        karyawanId: _selectedKaryawanId!,
        bulan: _selectedBulan!,
        tahun: _tahunController.text.trim(),
        jumlahKain: int.parse(_jumlahKainController.text.trim()),
        totalGaji: int.parse(_totalGajiController.text.trim()),
      );

      await ref.read(gajiRepositoryProvider).update(gajiUpdate);

      if (mounted) {
        showSnackbar(context, 'Data gaji berhasil diperbarui.', isError: false);
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        showSnackbar(context, 'Gagal memperbarui data gaji: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final karyawanListAsync = ref.watch(karyawanListStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Data Gaji'),
        centerTitle: true,
        leading: IconButton(
          icon: const HeroIcon(HeroIcons.arrowLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Dropdown Karyawan
              karyawanListAsync.when(
                data: (karyawanList) => DropdownButtonFormField<String>(
                  value: _selectedKaryawanId,
                  hint: const Text('Pilih Karyawan'),
                  decoration: const InputDecoration(
                    labelText: 'Karyawan',
                    border: OutlineInputBorder(),
                    prefixIcon: HeroIcon(HeroIcons.user),
                  ),
                  items: karyawanList.map((karyawan) {
                    return DropdownMenuItem(
                      value: karyawan.id,
                      child: Text(karyawan.nama),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedKaryawanId = value;
                    });
                  },
                  validator: (value) => value == null ? 'Pilih karyawan' : null,
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Text('Error memuat karyawan: $err'),
              ),
              const SizedBox(height: 16),

              // Bulan
              DropdownButtonFormField<String>(
                value: _selectedBulan,
                decoration: const InputDecoration(
                  labelText: 'Bulan',
                  border: OutlineInputBorder(),
                  prefixIcon: HeroIcon(HeroIcons.calendar),
                ),
                items: _bulanList.map((bulan) {
                  return DropdownMenuItem(value: bulan, child: Text(bulan));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBulan = value;
                  });
                },
                validator: (value) => (value?.isEmpty ?? true) ? 'Pilih bulan' : null,
              ),
              const SizedBox(height: 16),

              // Tahun
              TextFormField(
                controller: _tahunController,
                decoration: const InputDecoration(
                  labelText: 'Tahun',
                  border: OutlineInputBorder(),
                  prefixIcon: HeroIcon(HeroIcons.calendarDays),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Masukkan tahun' : null,
              ),
              const SizedBox(height: 16),

              // Jumlah Kain
              TextFormField(
                controller: _jumlahKainController,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Kain (Lembar)',
                  border: OutlineInputBorder(),
                  prefixIcon: HeroIcon(HeroIcons.rectangleStack),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Masukkan jumlah kain' : null,
              ),
              const SizedBox(height: 16),

              // Total Gaji
              TextFormField(
                controller: _totalGajiController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Total Gaji',
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                  filled: true,
                  fillColor: Color(0xFFF5F7FA),
                  prefixIcon: HeroIcon(HeroIcons.currencyDollar),
                  prefixText: 'Rp ',
                ),
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: const Text(
                  'Info: Tarif gaji adalah Rp 25.000 per lembar kain.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.blue),
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: _isLoading
                    ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                )
                    : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HeroIcon(HeroIcons.documentCheck, size: 20),
                    SizedBox(width: 8),
                    Text('Update Data Gaji'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
