import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';

class DaftarKeperluanScreen extends ConsumerWidget {
  const DaftarKeperluanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Keperluan'),
        actions: [
          IconButton(
            icon: const HeroIcon(HeroIcons.plus),
            onPressed: () {
              // Navigate to add keperluan screen
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10, // Replace with actual data count
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: const HeroIcon(HeroIcons.clipboardDocument),
              title: Text('Keperluan ${index + 1}'),
              subtitle: Text('Status: ${index % 2 == 0 ? 'Selesai' : 'Proses'}'),
              trailing: const HeroIcon(HeroIcons.chevronRight),
              onTap: () {
                // Navigate to detail screen
              },
            ),
          );
        },
      ),
    );
  }
}