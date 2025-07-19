import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';

class BahanBakuScreen extends ConsumerWidget {
  const BahanBakuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Persediaan Bahan Baku'),
        actions: [
          IconButton(
            icon: const HeroIcon(HeroIcons.plus),
            onPressed: () {
              // Navigate to add bahan baku screen
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
              leading: const HeroIcon(HeroIcons.cube),
              title: Text('Bahan Baku ${index + 1}'),
              subtitle: Text('Stok: ${index * 10}'),
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