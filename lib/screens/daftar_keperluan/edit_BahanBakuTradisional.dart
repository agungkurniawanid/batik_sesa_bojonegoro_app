import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'daftar_keperluan_screens.dart';

class EditBahanBakuTradisionalScreen extends StatefulWidget {
  final BahanBakuTradisional item;

  const EditBahanBakuTradisionalScreen({super.key, required this.item});

  @override
  State<EditBahanBakuTradisionalScreen> createState() => _EditBahanBakuTradisionalScreenState();
}

class _EditBahanBakuTradisionalScreenState extends State<EditBahanBakuTradisionalScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _hargaController;
  late TextEditingController _satuanController;
  late TextEditingController _keteranganController;

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

  @override
  void initState() {
    super.initState();
    _selectedKategori = widget.item.kategori;
    _namaController = TextEditingController(text: widget.item.nama);
    _hargaController = TextEditingController(text: widget.item.harga.toString());
    _satuanController = TextEditingController(text: widget.item.satuan);
    _keteranganController = TextEditingController(text: widget.item.keterangan);
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final bahanUpdate = BahanBakuTradisional(
        id: widget.item.id,
        kategori: _selectedKategori!,
        nama: _namaController.text.trim(),
        harga: int.parse(_hargaController.text.trim()),
        satuan: _satuanController.text.trim(),
        keterangan: _keteranganController.text.trim(),
      );

      print('Data Bahan Baku Diupdate: $bahanUpdate');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data bahan baku berhasil diupdate'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengupdate data bahan baku: $e'),
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
        title: const Text('Edit Bahan Baku Tradisional'),
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
                value: _selectedKategori,
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
                          Text('Update Data'),
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