import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'karyawan_screens.dart';

class EditGajiScreen extends StatefulWidget {
  final Gaji gaji;

  const EditGajiScreen({super.key, required this.gaji});

  @override
  State<EditGajiScreen> createState() => _EditGajiScreenState();
}

class _EditGajiScreenState extends State<EditGajiScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _karyawanController;
  late TextEditingController _bulanController;
  late TextEditingController _tahunController;
  late TextEditingController _jumlahKainController;
  late TextEditingController _totalGajiController;

  bool _isLoading = false;
  String? _selectedKaryawanId;

  @override
  void initState() {
    super.initState();
    _selectedKaryawanId = widget.gaji.karyawanId;
    final karyawan = daftarKaryawan.firstWhere(
      (k) => k.id == widget.gaji.karyawanId,
      orElse: () => Karyawan(
        id: '',
        nama: 'Unknown',
        alamat: '',
        status: '',
      ),
    );
    _karyawanController = TextEditingController(text: karyawan.nama);
    _bulanController = TextEditingController(text: widget.gaji.bulan);
    _tahunController = TextEditingController(text: widget.gaji.tahun);
    _jumlahKainController = TextEditingController(
      text: widget.gaji.jumlahKain.toString(),
    );
    _totalGajiController = TextEditingController(
      text: widget.gaji.totalGaji.toString(),
    );
  }

  void _calculateGaji() {
    if (_jumlahKainController.text.isEmpty) return;
    
    final jumlahKain = int.tryParse(_jumlahKainController.text) ?? 0;
    final totalGaji = jumlahKain * 25000; // 25rb per lembar (colet + nembok)
    
    _totalGajiController.text = totalGaji.toString();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final gajiUpdate = {
        'karyawanId': _selectedKaryawanId,
        'bulan': _bulanController.text.trim(),
        'tahun': _tahunController.text.trim(),
        'jumlahKain': int.parse(_jumlahKainController.text.trim()),
        'totalGaji': int.parse(_totalGajiController.text.trim()),
      };

      print('Data Gaji Diupdate: $gajiUpdate');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data gaji berhasil diupdate'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengupdate data gaji: $e'),
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
    _karyawanController.dispose();
    _bulanController.dispose();
    _tahunController.dispose();
    _jumlahKainController.dispose();
    _totalGajiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              DropdownButtonFormField<String>(
                value: _selectedKaryawanId,
                decoration: const InputDecoration(
                  labelText: 'Pilih Karyawan',
                  border: OutlineInputBorder(),
                  prefixIcon: HeroIcon(HeroIcons.user),
                ),
                items: daftarKaryawan.map((karyawan) {
                  return DropdownMenuItem(
                    value: karyawan.id,
                    child: Text(karyawan.nama),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedKaryawanId = value;
                    final karyawan = daftarKaryawan.firstWhere(
                      (k) => k.id == value,
                      orElse: () => Karyawan(
                        id: '',
                        nama: '',
                        alamat: '',
                        status: '',
                      ),
                    );
                    _karyawanController.text = karyawan.nama;
                  });
                },
                validator: (value) =>
                    value == null ? 'Pilih karyawan' : null,
              ),
              const SizedBox(height: 16),

              // Bulan
              DropdownButtonFormField<String>(
                value: widget.gaji.bulan,
                decoration: const InputDecoration(
                  labelText: 'Bulan',
                  border: OutlineInputBorder(),
                  prefixIcon: HeroIcon(HeroIcons.calendar),
                ),
                items: const [
                  DropdownMenuItem(value: 'Januari', child: Text('Januari')),
                  DropdownMenuItem(value: 'Februari', child: Text('Februari')),
                  DropdownMenuItem(value: 'Maret', child: Text('Maret')),
                  DropdownMenuItem(value: 'April', child: Text('April')),
                  DropdownMenuItem(value: 'Mei', child: Text('Mei')),
                  DropdownMenuItem(value: 'Juni', child: Text('Juni')),
                  DropdownMenuItem(value: 'Juli', child: Text('Juli')),
                  DropdownMenuItem(value: 'Agustus', child: Text('Agustus')),
                  DropdownMenuItem(value: 'September', child: Text('September')),
                  DropdownMenuItem(value: 'Oktober', child: Text('Oktober')),
                  DropdownMenuItem(value: 'November', child: Text('November')),
                  DropdownMenuItem(value: 'Desember', child: Text('Desember')),
                ],
                onChanged: (value) {
                  _bulanController.text = value!;
                },
                validator: (value) =>
                    value == null ? 'Pilih bulan' : null,
              ),
              const SizedBox(height: 16),

              // Tahun
              TextFormField(
                controller: _tahunController,
                decoration: const InputDecoration(
                  labelText: 'Tahun',
                  border: OutlineInputBorder(),
                  prefixIcon: HeroIcon(HeroIcons.calendar),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Masukkan tahun' : null,
              ),
              const SizedBox(height: 16),

              // Jumlah Kain
              TextFormField(
                controller: _jumlahKainController,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Kain (Lembar)',
                  border: OutlineInputBorder(),
                  prefixIcon: HeroIcon(HeroIcons.rectangleStack),
                  suffixText: 'Lembar',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => _calculateGaji(),
                validator: (value) =>
                    value!.isEmpty ? 'Masukkan jumlah kain' : null,
              ),
              const SizedBox(height: 16),

              // Total Gaji
              TextFormField(
                controller: _totalGajiController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Total Gaji',
                  border: OutlineInputBorder(),
                  prefixIcon: HeroIcon(HeroIcons.currencyDollar),
                  prefixText: 'Rp ',
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Total gaji harus dihitung' : null,
              ),
              const SizedBox(height: 16),

              // Info Tarif
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Tarif: Rp 10.000 (colet) + Rp 15.000 (nembok) = Rp 25.000 per lembar',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                  ),
                ),
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