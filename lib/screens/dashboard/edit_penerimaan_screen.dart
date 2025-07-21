import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';

class EditPenerimaanScreen extends StatefulWidget {
  final Map<String, dynamic> penerimaan;

  const EditPenerimaanScreen({super.key, required this.penerimaan});

  @override
  State<EditPenerimaanScreen> createState() => _EditPenerimaanScreenState();
}

class _EditPenerimaanScreenState extends State<EditPenerimaanScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _transaksiController = TextEditingController();
  final TextEditingController _pembeliController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _satuanController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  bool _isLoading = false;

  DateTime? _selectedDate;
  final List<String> _satuanList = ['Yard', 'Meter', 'Kg', 'Botol', 'Pcs'];

  @override
  void initState() {
    super.initState();
    // Initialize form with existing penerimaan data
    _selectedDate = widget.penerimaan['tanggal'];
    _tanggalController.text = DateFormat('dd MMM yyyy').format(_selectedDate!);
    _transaksiController.text = widget.penerimaan['transaksi'];
    _pembeliController.text = widget.penerimaan['pembeli'];
    _quantityController.text = widget.penerimaan['quantity'].toString();
    _satuanController.text = widget.penerimaan['satuan'];
    _hargaController.text = widget.penerimaan['harga'].toString();
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
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final penerimaanUpdated = {
        'tanggal': _selectedDate,
        'transaksi': _transaksiController.text.trim(),
        'pembeli': _pembeliController.text.trim(),
        'quantity': int.parse(_quantityController.text.trim()),
        'satuan': _satuanController.text.trim(),
        'harga': int.parse(_hargaController.text.trim()),
        'total': int.parse(_quantityController.text.trim()) *
            int.parse(_hargaController.text.trim()),
      };

      print('Data Penerimaan Diupdate: $penerimaanUpdated');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Penerimaan berhasil diupdate'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengupdate penerimaan: $e'),
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
    _tanggalController.dispose();
    _transaksiController.dispose();
    _pembeliController.dispose();
    _quantityController.dispose();
    _satuanController.dispose();
    _hargaController.dispose();
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
              // Tanggal
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
                    value!.isEmpty ? 'Pilih tanggal penerimaan' : null,
              ),
              const SizedBox(height: 16),

              // Nama Transaksi
              TextFormField(
                controller: _transaksiController,
                decoration: const InputDecoration(
                  labelText: 'Nama Transaksi',
                  border: OutlineInputBorder(),
                  prefixIcon: HeroIcon(HeroIcons.shoppingBag),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Masukkan nama transaksi' : null,
              ),
              const SizedBox(height: 16),

              // Nama Pembeli
              TextFormField(
                controller: _pembeliController,
                decoration: const InputDecoration(
                  labelText: 'Nama Pembeli',
                  border: OutlineInputBorder(),
                  prefixIcon: HeroIcon(HeroIcons.user),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Masukkan nama pembeli' : null,
              ),
              const SizedBox(height: 16),

              // Quantity dan Satuan
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
                          value!.isEmpty ? 'Masukkan quantity' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: DropdownButtonFormField<String>(
                      value: _satuanController.text,
                      items: _satuanList.map((satuan) {
                        return DropdownMenuItem(
                          value: satuan,
                          child: Text(satuan),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _satuanController.text = value!;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Satuan',
                        border: OutlineInputBorder(),
                        prefixIcon: HeroIcon(HeroIcons.scale),
                      ),
                      onSaved: (value) {
                        _satuanController.text = value!;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Harga
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
                    value!.isEmpty ? 'Masukkan harga satuan' : null,
              ),
              const SizedBox(height: 24),

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
    try {
      if (_quantityController.text.isNotEmpty &&
          _hargaController.text.isNotEmpty) {
        final quantity = int.parse(_quantityController.text);
        final harga = int.parse(_hargaController.text);
        final total = quantity * harga;
        return 'Rp ${NumberFormat('#,###').format(total)}';
      }
    } catch (e) {
      return 'Rp 0';
    }
    return 'Rp 0';
  }
}