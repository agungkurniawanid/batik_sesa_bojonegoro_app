import 'package:batik_sesa_bojonegoro_app/core/model/keperluan_model.dart';
import 'package:batik_sesa_bojonegoro_app/core/provider/keperluan_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';

class AddBahanBakuTradisionalScreen extends ConsumerStatefulWidget {
  const AddBahanBakuTradisionalScreen({super.key});

  @override
  ConsumerState<AddBahanBakuTradisionalScreen> createState() => _AddBahanBakuTradisionalScreenState();
}

class _AddBahanBakuTradisionalScreenState extends ConsumerState<AddBahanBakuTradisionalScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _satuanController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();

  bool _isLoading = false;
  String? _selectedKategori;

  final List<String> _kategoriOptions = [
    'Canting Batik',
    'Wajan dan kompor Batik',
    'Perlengkapan Batik Cap dan Malam',
    'Warna Alam',
    'Bumbu Malam',
    'Kimia Batik',
  ];

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repository = ref.read(keperluanRepositoryProvider);
      final bahanBaru = BahanBakuTradisional(
        id: '', // ID akan di-generate oleh Firebase
        kategori: _selectedKategori!,
        nama: _namaController.text.trim(),
        harga: int.parse(_hargaController.text.trim()),
        satuan: _satuanController.text.trim(),
        keterangan: _keteranganController.text.trim(),
      );

      await repository.addBahanBakuTradisional(bahanBaru);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data bahan baku berhasil ditambahkan'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menambahkan data bahan baku: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _hargaController.dispose();
    _satuanController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Bahan Baku Tradisional'),
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
              // Kategori Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                  prefixIcon: HeroIcon(HeroIcons.tag),
                ),
                items: _kategoriOptions.map((kategori) {
                  return DropdownMenuItem(
                    value: kategori,
                    child: Text(kategori),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedKategori = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Pilih kategori' : null,
              ),
              const SizedBox(height: 16),

              // Nama
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Bahan',
                  border: OutlineInputBorder(),
                  prefixIcon: HeroIcon(HeroIcons.shoppingBag),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Masukkan nama bahan' : null,
              ),
              const SizedBox(height: 16),

              // Harga
              TextFormField(
                controller: _hargaController,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                  prefixIcon: HeroIcon(HeroIcons.currencyDollar),
                  prefixText: 'Rp ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Masukkan harga' : null,
              ),
              const SizedBox(height: 16),

              // Satuan
              TextFormField(
                controller: _satuanController,
                decoration: const InputDecoration(
                  labelText: 'Satuan',
                  border: OutlineInputBorder(),
                  prefixIcon: HeroIcon(HeroIcons.scale),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Masukkan satuan' : null,
              ),
              const SizedBox(height: 16),

              // Keterangan
              TextFormField(
                controller: _keteranganController,
                decoration: const InputDecoration(
                  labelText: 'Keterangan',
                  border: OutlineInputBorder(),
                  prefixIcon: HeroIcon(HeroIcons.informationCircle),
                ),
                maxLines: 2,
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
                          HeroIcon(HeroIcons.document, size: 20),
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