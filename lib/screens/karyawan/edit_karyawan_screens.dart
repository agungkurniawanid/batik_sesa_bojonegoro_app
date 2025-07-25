import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';

import '../../core/model/gaji_karyawan_model.dart';
import '../../core/provider/gaji_karyawan_provider.dart';
import '../daftar_kain/daftar_kain_screens.dart';


class EditKaryawanScreen extends ConsumerStatefulWidget {
  final Karyawan karyawan;

  const EditKaryawanScreen({super.key, required this.karyawan});

  @override
  ConsumerState<EditKaryawanScreen> createState() => _EditKaryawanScreenState();
}

class _EditKaryawanScreenState extends ConsumerState<EditKaryawanScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _namaController;
  late final TextEditingController _alamatController;
  late final TextEditingController _nomorTeleponController; // Controller baru

  String? _selectedStatus;
  bool _isLoading = false;

  final List<String> _statusList = [
    'Karyawan Tetap',
    'Karyawan Kontrak',
    'Freelance',
  ];

  @override
  void initState() {
    super.initState();
    // Inisialisasi state dan controller dari data karyawan yang ada
    _namaController = TextEditingController(text: widget.karyawan.nama);
    _alamatController = TextEditingController(text: widget.karyawan.alamat);
    _nomorTeleponController =
        TextEditingController(text: widget.karyawan.nomorTelepon); // Inisialisasi controller baru
    _selectedStatus = widget.karyawan.status;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    _nomorTeleponController.dispose(); // Dispose controller baru
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final karyawanUpdate = Karyawan(
        id: widget.karyawan.id, // Gunakan ID yang sama untuk update
        nama: _namaController.text.trim(),
        alamat: _alamatController.text.trim(),
        status: _selectedStatus!,
        nomorTelepon: _nomorTeleponController.text.trim(), // Tambahkan nomor telepon
      );

      await ref.read(karyawanRepositoryProvider).update(karyawanUpdate);

      if (mounted) {
        showSnackbar(context, 'Data karyawan berhasil diperbarui.',
            isError: false);
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        showSnackbar(context, 'Gagal memperbarui data karyawan: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Data Karyawan'),
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
              // Nama Karyawan
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Karyawan',
                  border: OutlineInputBorder(),
                  prefixIcon: HeroIcon(HeroIcons.user),
                ),
                validator: (value) =>
                value!.isEmpty ? 'Masukkan nama karyawan' : null,
              ),
              const SizedBox(height: 16),

              // Alamat
              TextFormField(
                controller: _alamatController,
                decoration: const InputDecoration(
                  labelText: 'Alamat',
                  border: OutlineInputBorder(),
                  prefixIcon: HeroIcon(HeroIcons.mapPin),
                ),
                validator: (value) => value!.isEmpty ? 'Masukkan alamat' : null,
              ),
              const SizedBox(height: 16),

              // Nomor Telepon (Field Baru)
              TextFormField(
                controller: _nomorTeleponController,
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon',
                  border: OutlineInputBorder(),
                  prefixIcon: HeroIcon(HeroIcons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                value!.isEmpty ? 'Masukkan nomor telepon' : null,
              ),
              const SizedBox(height: 16),

              // Status Dropdown
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status Karyawan',
                  border: OutlineInputBorder(),
                  prefixIcon: HeroIcon(HeroIcons.shieldCheck),
                ),
                items: _statusList.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value;
                  });
                },
                validator: (value) =>
                value == null ? 'Pilih status karyawan' : null,
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
