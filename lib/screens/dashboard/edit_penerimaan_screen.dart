import 'package:batik_sesa_bojonegoro_app/core/model/penerimaan_model.dart';
import 'package:batik_sesa_bojonegoro_app/core/provider/penerimaan_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';

class EditPenerimaanScreen extends ConsumerStatefulWidget {
  final PenerimaanModel penerimaan;

  const EditPenerimaanScreen({super.key, required this.penerimaan});

  @override
  ConsumerState<EditPenerimaanScreen> createState() =>
      _EditPenerimaanScreenState();
}

class _EditPenerimaanScreenState extends ConsumerState<EditPenerimaanScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _tanggalController;
  late final TextEditingController _transaksiController;
  late final TextEditingController _pembeliController;
  late final TextEditingController _quantityController;
  late final TextEditingController _satuanController;
  late final TextEditingController _hargaController;
  late final TextEditingController _keteranganController;

  bool _isLoading = false;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing penerimaan data
    _selectedDate =
        DateTime.tryParse(widget.penerimaan.tanggal) ?? DateTime.now();

    _tanggalController = TextEditingController(
      text: DateFormat('dd MMM yyyy').format(_selectedDate!),
    );

    _transaksiController = TextEditingController(
      text: widget.penerimaan.transaksi,
    );

    _pembeliController = TextEditingController(text: widget.penerimaan.pembeli);

    _quantityController = TextEditingController(
      text: widget.penerimaan.kuantitas.toString(),
    );

    _satuanController = TextEditingController(text: widget.penerimaan.satuan);

    _hargaController = TextEditingController(
      text: widget.penerimaan.hargaSatuan.toString(),
    );

    _keteranganController = TextEditingController(
      text: widget.penerimaan.keterangan ?? '',
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _tanggalController.text = DateFormat('dd MMM yyyy').format(picked);
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repository = ref.read(penerimaanRepositoryProvider);

      final updatedPenerimaan = widget.penerimaan.copyWith(
        tanggal: _selectedDate!.toIso8601String(),
        transaksi: _transaksiController.text.trim(),
        pembeli: _pembeliController.text.trim(),
        kuantitas: num.tryParse(_quantityController.text) ?? 0,
        satuan: _satuanController.text.trim(),
        hargaSatuan: num.tryParse(_hargaController.text) ?? 0,
        total:
            (num.tryParse(_quantityController.text) ?? 0) *
            (num.tryParse(_hargaController.text) ?? 0),
        keterangan: _keteranganController.text.trim().isNotEmpty
            ? _keteranganController.text.trim()
            : null,
      );

      await repository.updatePenerimaan(updatedPenerimaan);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Penerimaan berhasil diperbarui'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _tanggalController.dispose();
    _transaksiController.dispose();
    _pembeliController.dispose();
    _quantityController.dispose();
    _satuanController.dispose();
    _hargaController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Penerimaan'),
        centerTitle: true,
        leading: IconButton(
          icon: const HeroIcon(HeroIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Tanggal Field
              TextFormField(
                controller: _tanggalController,
                decoration: InputDecoration(
                  labelText: 'Tanggal',
                  border: const OutlineInputBorder(),
                  prefixIcon: const HeroIcon(HeroIcons.calendar),
                  suffixIcon: IconButton(
                    icon: const HeroIcon(HeroIcons.calendarDays),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                readOnly: true,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Harap pilih tanggal' : null,
              ),
              const SizedBox(height: 16),

              // Nama Transaksi Field
              TextFormField(
                controller: _transaksiController,
                decoration: const InputDecoration(
                  labelText: 'Nama Transaksi',
                  border: OutlineInputBorder(),
                  prefixIcon: HeroIcon(HeroIcons.shoppingBag),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Harap isi nama transaksi' : null,
              ),
              const SizedBox(height: 16),

              // Nama Pembeli Field
              TextFormField(
                controller: _pembeliController,
                decoration: const InputDecoration(
                  labelText: 'Nama Pembeli',
                  border: OutlineInputBorder(),
                  prefixIcon: HeroIcon(HeroIcons.user),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Harap isi nama pembeli' : null,
              ),
              const SizedBox(height: 16),

              // Quantity and Satuan Row
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _quantityController,
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                        border: OutlineInputBorder(),
                        prefixIcon: HeroIcon(HeroIcons.hashtag),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Harap isi quantity' : null,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _satuanController,
                      decoration: const InputDecoration(
                        labelText: 'Satuan',
                        border: OutlineInputBorder(),
                        prefixIcon: HeroIcon(HeroIcons.scale),
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Harap isi satuan' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Harga Satuan Field
              TextFormField(
                controller: _hargaController,
                decoration: const InputDecoration(
                  labelText: 'Harga Satuan',
                  border: OutlineInputBorder(),
                  prefixIcon: HeroIcon(HeroIcons.currencyDollar),
                  prefixText: 'Rp ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Harap isi harga satuan' : null,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),

              // Keterangan Field
              TextFormField(
                controller: _keteranganController,
                decoration: const InputDecoration(
                  labelText: 'Keterangan (Opsional)',
                  border: OutlineInputBorder(),
                  prefixIcon: HeroIcon(HeroIcons.documentText),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),

              // Total Preview
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _calculateTotal(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
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
                          Text('Update Penerimaan'),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _calculateTotal() {
    final quantity = num.tryParse(_quantityController.text) ?? 0;
    final harga = num.tryParse(_hargaController.text) ?? 0;
    final total = quantity * harga;
    return 'Rp ${NumberFormat('#,###').format(total)}';
  }
}
