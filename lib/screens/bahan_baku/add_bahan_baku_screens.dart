import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class AddBahanBakuScreen extends StatefulWidget {
  const AddBahanBakuScreen({super.key});

  @override
  State<AddBahanBakuScreen> createState() => _AddBahanBakuScreenState();
}

class _AddBahanBakuScreenState extends State<AddBahanBakuScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _hargaBeliController = TextEditingController();
  final TextEditingController _ketersediaanController = TextEditingController();
  final TextEditingController _satuanController = TextEditingController();

  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final bahanBaru = {
        'nama': _namaController.text.trim(),
        'hargaBeli': _hargaBeliController.text.trim(),
        'ketersediaan': _ketersediaanController.text.trim(),
        'satuan': _satuanController.text.trim(),
      };

      print('Data Bahan Baku Ditambahkan: $bahanBaru');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bahan baku berhasil ditambahkan'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menambahkan bahan baku: $e'),
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
                validator: (value) =>
                    value!.isEmpty ? 'Masukkan harga beli' : null,
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
                validator: (value) =>
                    value!.isEmpty ? 'Masukkan jumlah ketersediaan' : null,
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
              const SizedBox(height: 16),

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