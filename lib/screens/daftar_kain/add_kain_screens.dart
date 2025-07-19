import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class AddKainScreen extends StatefulWidget {
  const AddKainScreen({super.key});

  @override
  State<AddKainScreen> createState() => _AddKainScreenState();
}

class _AddKainScreenState extends State<AddKainScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _lebarController = TextEditingController();
  final TextEditingController _finishController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _satuanController = TextEditingController();
  final TextEditingController _motifController = TextEditingController();
  final TextEditingController _hargaRollController = TextEditingController();
  final TextEditingController _hargaEcerController = TextEditingController();

  String _selectedKategori = 'Katun';
  bool _isLoading = false;

  final List<String> _kategoriList = [
    'Katun',
    'Rayon',
    'Sutra',
    'Doby Katun Viscose',
  ];

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final kainBaru = {
        'nama': _namaController.text.trim(),
        'kategori': _selectedKategori,
        'lebar': _lebarController.text.trim(),
        'finish': _finishController.text.trim(),
        'harga': _hargaController.text.trim(),
        'satuan': _satuanController.text.trim(),
        'motif': _selectedKategori == 'Doby Katun Viscose'
            ? _motifController.text.trim()
            : null,
        'hargaRoll':
            _selectedKategori == 'Sutra' ? _hargaRollController.text.trim() : null,
        'hargaEcer':
            _selectedKategori == 'Sutra' ? _hargaEcerController.text.trim() : null,
      };

      print('Data Kain Ditambahkan: $kainBaru');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kain berhasil ditambahkan'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menambahkan kain: $e'),
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
    _lebarController.dispose();
    _finishController.dispose();
    _hargaController.dispose();
    _satuanController.dispose();
    _motifController.dispose();
    _hargaRollController.dispose();
    _hargaEcerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Data Kain'),
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
                items: _kategoriList.map((kategori) {
                  return DropdownMenuItem(
                    value: kategori,
                    child: Text(kategori),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedKategori = value!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                  prefixIcon: HeroIcon(HeroIcons.tag),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              const SizedBox(height: 16),

              // Nama Kain
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Kain',
                  border: OutlineInputBorder(),
                  prefixIcon: HeroIcon(HeroIcons.swatch),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Masukkan nama kain' : null,
              ),
              const SizedBox(height: 16),

              // Lebar
              TextFormField(
                controller: _lebarController,
                decoration: const InputDecoration(
                  labelText: 'Lebar',
                  hintText: 'Contoh: 115 cm',
                  border: OutlineInputBorder(),
                  prefixIcon: HeroIcon(HeroIcons.arrowsPointingOut),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Masukkan lebar kain' : null,
              ),
              const SizedBox(height: 16),

              // Finish
              TextFormField(
                controller: _finishController,
                decoration: const InputDecoration(
                  labelText: 'Finish',
                  hintText: 'Contoh: BMS, Bleaching, -',
                  border: OutlineInputBorder(),
                  prefixIcon: HeroIcon(HeroIcons.sparkles),
                ),
              ),
              const SizedBox(height: 16),

              // Satuan
              TextFormField(
                controller: _satuanController,
                decoration: const InputDecoration(
                  labelText: 'Satuan',
                  hintText: 'Contoh: Yard, Meter, Pcs',
                  border: OutlineInputBorder(),
                  prefixIcon: HeroIcon(HeroIcons.scale),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Masukkan satuan kain' : null,
              ),
              const SizedBox(height: 16),

              // Conditional Fields
              if (_selectedKategori == 'Sutra') ...[
                TextFormField(
                  controller: _hargaRollController,
                  decoration: const InputDecoration(
                    labelText: 'Harga Roll',
                    hintText: 'Contoh: 185000',
                    border: OutlineInputBorder(),
                    prefixIcon: HeroIcon(HeroIcons.currencyDollar),
                    prefixText: 'Rp ',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Masukkan harga roll' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _hargaEcerController,
                  decoration: const InputDecoration(
                    labelText: 'Harga Ecer',
                    hintText: 'Contoh: 190000',
                    border: OutlineInputBorder(),
                    prefixIcon: HeroIcon(HeroIcons.currencyDollar),
                    prefixText: 'Rp ',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Masukkan harga ecer' : null,
                ),
                const SizedBox(height: 16),
              ] else ...[
                TextFormField(
                  controller: _hargaController,
                  decoration: const InputDecoration(
                    labelText: 'Harga',
                    hintText: 'Contoh: 10500',
                    border: OutlineInputBorder(),
                    prefixIcon: HeroIcon(HeroIcons.currencyDollar),
                    prefixText: 'Rp ',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Masukkan harga kain' : null,
                ),
                const SizedBox(height: 16),
              ],

              if (_selectedKategori == 'Doby Katun Viscose') ...[
                TextFormField(
                  controller: _motifController,
                  decoration: const InputDecoration(
                    labelText: 'Motif',
                    hintText: 'Contoh: Kristal',
                    border: OutlineInputBorder(),
                    prefixIcon: HeroIcon(HeroIcons.squares2x2),
                  ),
                ),
                const SizedBox(height: 16),
              ],

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