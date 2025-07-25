import 'package:batik_sesa_bojonegoro_app/core/model/keperluan_model.dart';
import 'package:batik_sesa_bojonegoro_app/core/provider/keperluan_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';

class EditPewarnaBatikModernScreen extends ConsumerStatefulWidget {
  final PewarnaBatikModern item;

  const EditPewarnaBatikModernScreen({super.key, required this.item});

  @override
  ConsumerState<EditPewarnaBatikModernScreen> createState() => 
      _EditPewarnaBatikModernScreenState();
}

class _EditPewarnaBatikModernScreenState 
    extends ConsumerState<EditPewarnaBatikModernScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _harga1kgController;
  late TextEditingController _harga05kgController;
  late TextEditingController _harga025kgController;
  late TextEditingController _harga1onsController;

  bool _isLoading = false;
  String? _selectedKategori;

  final List<String> _kategoriOptions = [
    'Pewarna Remazol Batik',
    'Rapid',
    'Indigosol',
  ];

  @override
  void initState() {
    super.initState();
    _selectedKategori = widget.item.kategori;
    _namaController = TextEditingController(text: widget.item.nama);
    _harga1kgController = TextEditingController(text: widget.item.harga1kg.toString());
    _harga05kgController = TextEditingController(text: widget.item.harga05kg.toString());
    _harga025kgController = TextEditingController(text: widget.item.harga025kg.toString());
    _harga1onsController = TextEditingController(text: widget.item.harga1ons.toString());
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repository = ref.read(keperluanRepositoryProvider);
      final pewarnaUpdate = PewarnaBatikModern(
        id: widget.item.id,
        kategori: _selectedKategori!,
        nama: _namaController.text.trim(),
        harga1kg: int.parse(_harga1kgController.text.trim()),
        harga05kg: int.parse(_harga05kgController.text.trim()),
        harga025kg: int.parse(_harga025kgController.text.trim()),
        harga1ons: int.parse(_harga1onsController.text.trim()),
      );

      await repository.updatePewarnaBatikModern(pewarnaUpdate);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data pewarna batik berhasil diupdate'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengupdate data pewarna batik: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _harga1kgController.dispose();
    _harga05kgController.dispose();
    _harga025kgController.dispose();
    _harga1onsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Pewarna Batik Modern'),
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
                  labelText: 'Nama Pewarna',
                  border: OutlineInputBorder(),
                  prefixIcon: HeroIcon(HeroIcons.paintBrush),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Masukkan nama pewarna' : null,
              ),
              const SizedBox(height: 16),

              // Harga 1 Kg
              TextFormField(
                controller: _harga1kgController,
                decoration: const InputDecoration(
                  labelText: 'Harga 1 Kg',
                  border: OutlineInputBorder(),
                  prefixIcon: HeroIcon(HeroIcons.currencyDollar),
                  prefixText: 'Rp ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Masukkan harga 1 Kg';
                  if (int.tryParse(value) == null) return 'Masukkan angka yang valid';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Harga 0.5 Kg
              TextFormField(
                controller: _harga05kgController,
                decoration: const InputDecoration(
                  labelText: 'Harga 0.5 Kg',
                  border: OutlineInputBorder(),
                  prefixIcon: HeroIcon(HeroIcons.currencyDollar),
                  prefixText: 'Rp ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Masukkan harga 0.5 Kg';
                  if (int.tryParse(value) == null) return 'Masukkan angka yang valid';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Harga 0.25 Kg
              TextFormField(
                controller: _harga025kgController,
                decoration: const InputDecoration(
                  labelText: 'Harga 0.25 Kg',
                  border: OutlineInputBorder(),
                  prefixIcon: HeroIcon(HeroIcons.currencyDollar),
                  prefixText: 'Rp ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Masukkan harga 0.25 Kg';
                  if (int.tryParse(value) == null) return 'Masukkan angka yang valid';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Harga 1 Ons
              TextFormField(
                controller: _harga1onsController,
                decoration: const InputDecoration(
                  labelText: 'Harga 1 Ons',
                  border: OutlineInputBorder(),
                  prefixIcon: HeroIcon(HeroIcons.currencyDollar),
                  prefixText: 'Rp ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Masukkan harga 1 Ons';
                  if (int.tryParse(value) == null) return 'Masukkan angka yang valid';
                  return null;
                },
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