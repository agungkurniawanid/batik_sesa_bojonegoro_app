import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';

class KaryawanScreen extends ConsumerWidget {
  const KaryawanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Karyawan'),
        actions: [
          IconButton(
            icon: const HeroIcon(HeroIcons.plus),
            onPressed: () {
              // Navigate to add karyawan screen
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
              leading: const CircleAvatar(
                child: HeroIcon(HeroIcons.user),
              ),
              title: Text('Karyawan ${index + 1}'),
              subtitle: Text('Posisi: ${index % 2 == 0 ? 'Penjahit' : 'Designer'}'),
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