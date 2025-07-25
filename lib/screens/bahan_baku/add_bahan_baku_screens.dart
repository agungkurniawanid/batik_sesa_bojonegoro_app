
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';

import '../../core/provider/bahanbaku_provider.dart';

// 1. Ubah menjadi ConsumerStatefulWidget
class AddBahanBakuScreen extends ConsumerStatefulWidget {
  const AddBahanBakuScreen({super.key});

  @override
  ConsumerState<AddBahanBakuScreen> createState() => _AddBahanBakuScreenState();
}

class _AddBahanBakuScreenState extends ConsumerState<AddBahanBakuScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _hargaBeliController = TextEditingController();
  final TextEditingController _ketersediaanController = TextEditingController();
  final TextEditingController _satuanController = TextEditingController();

  bool _isLoading = false;

  Future<void> _submitForm() async {
    // Validasi form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Ambil nilai dari controller
      final nama = _namaController.text.trim();
      final hargaBeli = num.tryParse(_hargaBeliController.text.trim()) ?? 0;
      final ketersediaan = num.tryParse(_ketersediaanController.text.trim()) ?? 0;
      final satuan = _satuanController.text.trim();

      // 2. Baca repository provider dan panggil method addBahanBaku
      await ref.read(bahanBakuRepositoryProvider).addBahanBaku(
        nama: nama,
        hargaBeli: hargaBeli,
        ketersediaan: ketersediaan,
        satuan: satuan,
      );

      // Tampilkan notifikasi sukses dan kembali ke halaman sebelumnya
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bahan baku berhasil ditambahkan'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      // Tampilkan notifikasi error jika gagal
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menambahkan bahan baku: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      // Hentikan loading state
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _hargaBeliController.dispose();
    _ketersediaanController.dispose();
    _satuanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Data Bahan Baku'),
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
              // Nama Bahan Baku
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Bahan Baku',
                  border: OutlineInputBorder(),
                  prefixIcon: HeroIcon(HeroIcons.tag),
                ),
                validator: (value) =>
                value!.isEmpty ? 'Masukkan nama bahan baku' : null,
              ),
              const SizedBox(height: 16),

              // Harga Beli
              TextFormField(
                controller: _hargaBeliController,
                decoration: const InputDecoration(
                  labelText: 'Harga Beli',
                  hintText: 'Contoh: 20500',
                  border: OutlineInputBorder(),
                  prefixIcon: HeroIcon(HeroIcons.currencyDollar),
                  prefixText: 'Rp ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan harga beli';
                  }
                  if (num.tryParse(value) == null) {
                    return 'Masukkan angka yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Ketersediaan
              TextFormField(
                controller: _ketersediaanController,
                decoration: const InputDecoration(
                  labelText: 'Ketersediaan',
                  hintText: 'Contoh: 120',
                  border: OutlineInputBorder(),
                  prefixIcon: HeroIcon(HeroIcons.archiveBox),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan jumlah ketersediaan';
                  }
                  if (num.tryParse(value) == null) {
                    return 'Masukkan angka yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Satuan
              TextFormField(
                controller: _satuanController,
                decoration: const InputDecoration(
                  labelText: 'Satuan',
                  hintText: 'Contoh: Kg, Lembar, Biji',
                  border: OutlineInputBorder(),
                  prefixIcon: HeroIcon(HeroIcons.scale),
                ),
                validator: (value) =>
                value!.isEmpty ? 'Masukkan satuan' : null,
              ),
              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
                    : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HeroIcon(HeroIcons.documentCheck, size: 20),
                    SizedBox(width: 8),
                    Text('Simpan Data'),
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
