import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:batik_sesa_bojonegoro_app/screens/bahan_baku/bahan_baku_screens.dart';

class EditBahanBakuScreen extends StatefulWidget {
  final BahanBaku bahanBaku;

  const EditBahanBakuScreen({super.key, required this.bahanBaku});

  @override
  State<EditBahanBakuScreen> createState() => _EditBahanBakuScreenState();
}

class _EditBahanBakuScreenState extends State<EditBahanBakuScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _hargaBeliController;
  late TextEditingController _ketersediaanController;
  late TextEditingController _satuanController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.bahanBaku.nama);
    _hargaBeliController = TextEditingController(text: widget.bahanBaku.hargaBeli);
    _ketersediaanController = TextEditingController(text: widget.bahanBaku.ketersediaan);
    _satuanController = TextEditingController(text: widget.bahanBaku.satuan);
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final bahanUpdated = {
        'nama': _namaController.text.trim(),
        'hargaBeli': _hargaBeliController.text.trim(),
        'ketersediaan': _ketersediaanController.text.trim(),
        'satuan': _satuanController.text.trim(),
      };

      print('Data Bahan Baku Diperbarui: $bahanUpdated');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bahan baku berhasil diperbarui'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memperbarui bahan baku: $e'),
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