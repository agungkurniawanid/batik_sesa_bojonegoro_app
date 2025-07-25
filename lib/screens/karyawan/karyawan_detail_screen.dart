import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/model/gaji_karyawan_model.dart';
import '../../core/provider/gaji_karyawan_provider.dart';
import '../daftar_kain/daftar_kain_screens.dart';


class KaryawanDetailScreen extends ConsumerWidget {
  final Karyawan karyawan;
  const KaryawanDetailScreen({super.key, required this.karyawan});

  /// Helper untuk membuka URL (WhatsApp, Telepon, SMS)
  Future<void> _launchURL(Uri url, BuildContext context) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        showSnackbar(context, 'Tidak dapat membuka $url');
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch stream gaji untuk mendapatkan semua data gaji
    final riwayatGajiAsync = ref.watch(gajiListStreamProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Detail Karyawan',
          style: TextStyle(fontFamily: 'Sriwedari', fontWeight: FontWeight.bold, fontSize: 32, color: Colors.blueAccent),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailKaryawanCard(context, karyawan),
            const SizedBox(height: 24),

            Text('Riwayat Gaji',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),

            riwayatGajiAsync.when(
              data: (allGaji) {
                final riwayatGajiKaryawan = allGaji
                    .where((gaji) => gaji.karyawanId == karyawan.id)
                    .toList();

                if (riwayatGajiKaryawan.isEmpty) {
                  return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 32.0),
                        child: Text('Belum ada riwayat gaji.'),
                      ));
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: riwayatGajiKaryawan.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final gaji = riwayatGajiKaryawan[index];
                    return _buildGajiCard(context, gaji);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) =>
                  Center(child: Text('Error: ${err.toString()}')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailKaryawanCard(BuildContext context, Karyawan karyawan) {
    // Membersihkan dan memformat nomor telepon untuk URL
    String cleanPhoneNumber =
    karyawan.nomorTelepon.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanPhoneNumber.startsWith('0')) {
      cleanPhoneNumber = '62${cleanPhoneNumber.substring(1)}';
    } else if (!cleanPhoneNumber.startsWith('62')) {
      cleanPhoneNumber = '62$cleanPhoneNumber';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(karyawan.nama,
              style:
              const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _infoRow(HeroIcons.mapPin, 'Alamat', karyawan.alamat),
          const SizedBox(height: 8),
          _infoRow(HeroIcons.shieldCheck, 'Status', karyawan.status),
          const SizedBox(height: 8),
          _infoRow(HeroIcons.phone, 'Telepon', karyawan.nomorTelepon),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _contactButton(
                icon: HeroIcons.chatBubbleLeftRight,
                label: 'WhatsApp',
                color: Colors.green,
                onPressed: () {
                  final url = Uri.parse('https://wa.me/$cleanPhoneNumber');
                  _launchURL(url, context);
                },
              ),
              _contactButton(
                icon: HeroIcons.phone,
                label: 'Telepon',
                color: Colors.blueAccent,
                onPressed: () {
                  final url = Uri.parse('tel:$cleanPhoneNumber');
                  _launchURL(url, context);
                },
              ),
              _contactButton(
                icon: HeroIcons.envelope,
                label: 'SMS',
                color: Colors.orangeAccent,
                onPressed: () {
                  final url = Uri.parse('sms:$cleanPhoneNumber');
                  _launchURL(url, context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoRow(HeroIcons icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeroIcon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Text('$label: ', style: TextStyle(color: Colors.grey.shade600)),
        Expanded(
            child: Text(value,
                style: const TextStyle(fontWeight: FontWeight.w500))),
      ],
    );
  }

  Widget _contactButton({
    required HeroIcons icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(12),
            backgroundColor: color.withOpacity(0.1),
            foregroundColor: color,
            elevation: 0,
          ),
          child: HeroIcon(icon, size: 24),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildGajiCard(BuildContext context, Gaji gaji) {
    final currencyFormatter =
    NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${gaji.bulan} ${gaji.tahun}',
              style:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Jumlah Kain: ${gaji.jumlahKain} Lembar'),
              Text(
                currencyFormatter.format(gaji.totalGaji),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
