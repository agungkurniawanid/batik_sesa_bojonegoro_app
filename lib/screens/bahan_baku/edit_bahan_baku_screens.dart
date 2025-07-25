import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';

import '../../core/model/bahan_baku_model.dart';
import '../../core/provider/bahanbaku_provider.dart';

// 1. Ubah menjadi ConsumerStatefulWidget
class EditBahanBakuScreen extends ConsumerStatefulWidget {
  final BahanBaku bahanBaku;

  const EditBahanBakuScreen({super.key, required this.bahanBaku});

  @override
  ConsumerState<EditBahanBakuScreen> createState() => _EditBahanBakuScreenState();
}

class _EditBahanBakuScreenState extends ConsumerState<EditBahanBakuScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _hargaBeliController;
  late TextEditingController _ketersediaanController;
  late TextEditingController _satuanController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data yang ada
    _namaController = TextEditingController(text: widget.bahanBaku.nama);
    _hargaBeliController = TextEditingController(text: widget.bahanBaku.hargaBeli.toString());
    _ketersediaanController = TextEditingController(text: widget.bahanBaku.ketersediaan.toString());
    _satuanController = TextEditingController(text: widget.bahanBaku.satuan);
  }

  Future<void> _submitForm() async {
    // Validasi form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Buat objek BahanBaku yang diperbarui dengan ID yang sama
      final updatedBahanBaku = BahanBaku(
        id: widget.bahanBaku.id,
        nama: _namaController.text.trim(),
        hargaBeli: num.tryParse(_hargaBeliController.text.trim()) ?? 0,
        ketersediaan: num.tryParse(_ketersediaanController.text.trim()) ?? 0,
        satuan: _satuanController.text.trim(),
      );

      // 2. Baca repository provider dan panggil method updateBahanBaku
      await ref.read(bahanBakuRepositoryProvider).updateBahanBaku(updatedBahanBaku);

      // Tampilkan notifikasi sukses dan kembali ke halaman sebelumnya
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bahan baku berhasil diperbarui'),
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
            content: Text('Gagal memperbarui bahan baku: $e'),
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
        title: const Text('Edit Data Bahan Baku'),
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
              // Form fields... (sama seperti sebelumnya)
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
                    Text('Simpan Perubahan'),
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
