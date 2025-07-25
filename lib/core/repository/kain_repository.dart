import 'package:firebase_database/firebase_database.dart';

import '../model/kain_model.dart';


class KainRepository {
  KainRepository(this._database);
  final FirebaseDatabase _database;

  // Path di Firebase Realtime Database
  static const _kainPath = 'kain';

  DatabaseReference get _kainRef => _database.ref(_kainPath);

  /// Memeriksa apakah database kain kosong.
  Future<bool> isDatabaseEmpty() async {
    final snapshot = await _kainRef.once();
    return !snapshot.snapshot.exists || snapshot.snapshot.value == null;
  }

  /// Mengawasi perubahan pada daftar kain secara real-time.
  Stream<List<Kain>> watchAllKain() {
    return _kainRef.onValue.map((event) {
      if (!event.snapshot.exists || event.snapshot.value == null) {
        return []; // Kembalikan list kosong jika tidak ada data
      }

      final data = event.snapshot.value;

      // PERBAIKAN: Cek apakah Firebase mengembalikan List atau Map
      if (data is Map) {
        // Logika untuk data Map (default)
        final valueMap = Map<String, dynamic>.from(data);
        return valueMap.entries.map((entry) {
          final itemMap = Map<String, dynamic>.from(entry.value as Map);
          return Kain.fromMap(itemMap, entry.key);
        }).toList();
      } else if (data is List) {
        // Logika untuk data List (karena seeder menggunakan key angka)
        final List<Kain> kainList = [];
        for (int i = 0; i < data.length; i++) {
          final item = data[i];
          // Firebase List bisa punya index null, jadi kita lewati
          if (item != null) {
            final valueMap = Map<String, dynamic>.from(item as Map);
            // Gunakan index sebagai 'key' sementara jika tidak ada
            kainList.add(Kain.fromMap(valueMap, valueMap['id'] ?? i.toString()));
          }
        }
        return kainList;
      }
      return [];
    });
  }

  /// Menambah kain baru ke database.
  Future<void> addKain(Kain kain) {
    final newRef = _kainRef.push();
    final data = kain.toMap();
    data['id'] = newRef.key;
    return newRef.set(data);
  }

  /// Memperbarui data kain yang sudah ada.
  Future<void> updateKain(Kain kain) {
    if (kain.id.isEmpty) {
      throw Exception('ID Kain tidak boleh kosong saat memperbarui data.');
    }
    return _kainRef.child(kain.id).update(kain.toMap());
  }

  /// Menghapus kain dari database berdasarkan ID.
  Future<void> deleteKain(String id) {
    return _kainRef.child(id).remove();
  }

  /// Mengisi database dengan data default dari daftar harga.
  Future<void> seedDatabaseFromPriceList() async {
    print('Memulai proses seeding database kain...');
    await _kainRef.set(_kainDataToSeed);
    print('Database kain berhasil di-seed.');
  }
}


// Data default untuk di-seed ke database.
// Ditaruh di luar kelas agar lebih rapi.
final Map<String, Map<String, dynamic>> _kainDataToSeed = {
  // --- KATEGORI KATUN ---
  "kain_1": {'id': 'kain_1', 'kategori': 'Katun', 'nama': 'Mori Biru Jempol', 'lebar': '115 cm', 'finish': 'BMS', 'harga': 10500, 'satuan': 'Yard'},
  "kain_2": {'id': 'kain_2', 'kategori': 'Katun', 'nama': 'Prima PBK', 'lebar': '105 cm', 'finish': 'Bleaching', 'harga': 10500, 'satuan': 'Yard'},
  "kain_3": {'id': 'kain_3', 'kategori': 'Katun', 'nama': 'Prima BC', 'lebar': '107 cm', 'finish': 'Bleaching', 'harga': 11250, 'satuan': 'Yard'},
  "kain_4": {'id': 'kain_4', 'kategori': 'Katun', 'nama': 'Prima Lampion SHT', 'lebar': '105 cm', 'finish': 'BMS', 'harga': 11000, 'satuan': 'Yard'},
  "kain_5": {'id': 'kain_5', 'kategori': 'Katun', 'nama': 'Prima Lampion SHT', 'lebar': '115 cm', 'finish': 'BMS', 'harga': 11500, 'satuan': 'Yard'},
  "kain_6": {'id': 'kain_6', 'kategori': 'Katun', 'nama': 'Prima Lampion AIL', 'lebar': '115 cm', 'finish': 'BMS', 'harga': 11500, 'satuan': 'Yard'},
  "kain_7": {'id': 'kain_7', 'kategori': 'Katun', 'nama': 'Prima Gajah Super', 'lebar': '115 cm', 'finish': 'BMS', 'harga': 12800, 'satuan': 'Yard'},
  "kain_8": {'id': 'kain_8', 'kategori': 'Katun', 'nama': 'Poplyn', 'lebar': '120 cm', 'finish': 'BMS', 'harga': 14500, 'satuan': 'Yard'},
  "kain_9": {'id': 'kain_9', 'kategori': 'Katun', 'nama': 'Poplyn Spesial', 'lebar': '125 cm', 'finish': 'BMS', 'harga': 14500, 'satuan': 'Yard'},
  "kain_10": {'id': 'kain_10', 'kategori': 'Katun', 'nama': 'Berkolin', 'lebar': '115 cm', 'finish': 'BMS', 'harga': 15000, 'satuan': 'Yard'},
  "kain_11": {'id': 'kain_11', 'kategori': 'Katun', 'nama': 'Primis Bima Kunting SHT', 'lebar': '115 cm', 'finish': 'BMS', 'harga': 16500, 'satuan': 'Yard'},
  "kain_12": {'id': 'kain_12', 'kategori': 'Katun', 'nama': 'Primis Bima Kunting AIL', 'lebar': '115 cm', 'finish': 'BMS', 'harga': 16500, 'satuan': 'Yard'},
  "kain_13": {'id': 'kain_13', 'kategori': 'Katun', 'nama': 'Saten Tebal', 'lebar': '115 cm', 'finish': 'BMS', 'harga': 18500, 'satuan': 'Yard'},
  "kain_14": {'id': 'kain_14', 'kategori': 'Katun', 'nama': 'Saten Tebal Lebar', 'lebar': '122 cm', 'finish': 'BMS', 'harga': 22000, 'satuan': 'Yard'},
  "kain_15": {'id': 'kain_15', 'kategori': 'Katun', 'nama': 'Primis Tari Kupu Pcs', 'lebar': '105 cm', 'finish': 'Bleaching', 'harga': 570000, 'satuan': 'Pcs'},
  "kain_16": {'id': 'kain_16', 'kategori': 'Katun', 'nama': 'Primis Tari Kupu Roll', 'lebar': '105 cm', 'finish': 'Bleaching', 'harga': 15406, 'satuan': 'Yard'},
  "kain_17": {'id': 'kain_17', 'kategori': 'Katun', 'nama': 'Primis Tari Kupu Potong', 'lebar': '105 cm', 'finish': 'Bleaching', 'harga': 43000, 'satuan': 'Pot @2,9 yard'},
  "kain_18": {'id': 'kain_18', 'kategori': 'Katun', 'nama': 'Primis Gamelan Pcs', 'lebar': '105 cm', 'finish': 'Bleaching', 'harga': 570000, 'satuan': 'Pcs @37 yard'},
  "kain_19": {'id': 'kain_19', 'kategori': 'Katun', 'nama': 'Kereta Kencana Pcs', 'lebar': '105 cm', 'finish': 'Bleaching', 'harga': 1150000, 'satuan': 'Pcs @37 yard'},
  "kain_20": {'id': 'kain_20', 'kategori': 'Katun', 'nama': 'Katun Paris', 'lebar': '115 cm', 'finish': 'BMS', 'harga': 20000, 'satuan': 'Yard'},
  "kain_21": {'id': 'kain_21', 'kategori': 'Katun', 'nama': 'Katun Jepang', 'lebar': '115 cm', 'finish': 'BMS', 'harga': 28500, 'satuan': 'Yard'},
  "kain_22": {'id': 'kain_22', 'kategori': 'Katun', 'nama': 'Katun Sutra', 'lebar': '115 cm', 'finish': 'BMS', 'harga': 32500, 'satuan': 'Yard'},
  // --- KATEGORI SUTRA ---
  "kain_23": {'id': 'kain_23', 'kategori': 'Sutra', 'nama': 'Sutra 654 grade 1', 'lebar': '115 cm', 'hargaRoll': 185000, 'hargaEcer': 190000, 'satuan': 'Yard'},
  "kain_24": {'id': 'kain_24', 'kategori': 'Sutra', 'nama': 'Sutra super 654', 'lebar': '115 cm', 'hargaRoll': 135000, 'hargaEcer': 140000, 'satuan': 'Yard'},
  "kain_25": {'id': 'kain_25', 'kategori': 'Sutra', 'nama': 'Sutra super 656', 'lebar': '115 cm', 'hargaRoll': 100000, 'hargaEcer': 105000, 'satuan': 'Yard'},
  "kain_26": {'id': 'kain_26', 'kategori': 'Sutra', 'nama': 'Sutra Crepe', 'lebar': '115 cm', 'hargaRoll': 95000, 'hargaEcer': 105000, 'satuan': 'Yard'},
  "kain_27": {'id': 'kain_27', 'kategori': 'Sutra', 'nama': 'Thai Silk', 'lebar': '115 cm', 'hargaRoll': 95000, 'hargaEcer': 105000, 'satuan': 'Yard'},
  "kain_28": {'id': 'kain_28', 'kategori': 'Sutra', 'nama': 'Sutra Habutai', 'lebar': '115 cm', 'hargaRoll': 95000, 'hargaEcer': 100000, 'satuan': 'Yard'},
  "kain_29": {'id': 'kain_29', 'kategori': 'Sutra', 'nama': 'Sutra Sifon', 'lebar': '115 cm', 'hargaRoll': 68000, 'hargaEcer': 75000, 'satuan': 'Yard'},
  "kain_30": {'id': 'kain_30', 'kategori': 'Sutra', 'nama': 'Sutra Organdi', 'lebar': '115 cm', 'hargaRoll': 50000, 'hargaEcer': 60000, 'satuan': 'Yard'},
  "kain_31": {'id': 'kain_31', 'kategori': 'Sutra', 'nama': 'Sutra Krinkle', 'lebar': '115 cm', 'hargaRoll': 50000, 'hargaEcer': 55000, 'satuan': 'Yard'},
  "kain_32": {'id': 'kain_32', 'kategori': 'Sutra', 'nama': 'ATBM Tipis', 'lebar': '115 cm', 'hargaEcer': 170000, 'satuan': 'Meter'},
  "kain_33": {'id': 'kain_33', 'kategori': 'Sutra', 'nama': 'ATBM Sedang', 'lebar': '115 cm', 'hargaEcer': 185000, 'satuan': 'Meter'},
  "kain_34": {'id': 'kain_34', 'kategori': 'Sutra', 'nama': 'ATBM Tebal', 'lebar': '115 cm', 'hargaEcer': 200000, 'satuan': 'Meter'},
  // --- KATEGORI DOBBY ---
  "kain_35": {'id': 'kain_35', 'kategori': 'Dobby', 'nama': 'Dobby C/S', 'lebar': '115 cm', 'motif': 'Kristal', 'harga': 16000, 'satuan': 'Yard'},
  "kain_36": {'id': 'kain_36', 'kategori': 'Dobby', 'nama': 'Dobby C/V', 'lebar': '115 cm', 'motif': 'Kristal', 'harga': 19000, 'satuan': 'Yard'},
  // --- KATEGORI RAYON ---
  "kain_37": {'id': 'kain_37', 'kategori': 'Rayon', 'nama': 'Rayon Banci', 'lebar': '115 cm', 'finish': 'Bleaching', 'harga': 10000, 'satuan': 'Yard'},
  "kain_38": {'id': 'kain_38', 'kategori': 'Rayon', 'nama': 'Rayon RB1', 'lebar': '115 cm', 'finish': 'Bleaching', 'harga': 11000, 'satuan': 'Yard'},
  "kain_39": {'id': 'kain_39', 'kategori': 'Rayon', 'nama': 'Rayon Lebar 150', 'lebar': '150 cm', 'finish': 'Bleaching', 'harga': 13500, 'satuan': 'Yard'},
  "kain_40": {'id': 'kain_40', 'kategori': 'Rayon', 'nama': 'Rayon Sifon', 'lebar': '115 cm', 'finish': 'Bleaching', 'harga': 11500, 'satuan': 'Yard'},
  "kain_41": {'id': 'kain_41', 'kategori': 'Rayon', 'nama': 'Rayon Paris', 'lebar': '115 cm', 'finish': 'Bleaching', 'harga': 13500, 'satuan': 'Yard'},
  "kain_42": {'id': 'kain_42', 'kategori': 'Rayon', 'nama': 'Rayon Paris corak pelangi', 'lebar': '115 cm', 'finish': 'Bleaching', 'harga': 14500, 'satuan': 'Yard'},
  "kain_43": {'id': 'kain_43', 'kategori': 'Rayon', 'nama': 'Rayon Paris corak tetes air', 'lebar': '115 cm', 'finish': 'Bleaching', 'harga': 14500, 'satuan': 'Yard'},
};
