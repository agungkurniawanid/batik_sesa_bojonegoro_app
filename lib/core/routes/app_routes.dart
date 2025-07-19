import 'package:flutter/material.dart';
import 'package:batik_sesa_bojonegoro_app/screens/splash_screens.dart';
import 'package:batik_sesa_bojonegoro_app/screens/pin_screens.dart';
import 'package:batik_sesa_bojonegoro_app/widgets/navbottom.dart';
import 'package:batik_sesa_bojonegoro_app/screens/bahan_baku/bahan_baku_screens.dart';
import 'package:batik_sesa_bojonegoro_app/screens/daftar_kain/daftar_kain_screens.dart';
import 'package:batik_sesa_bojonegoro_app/screens/daftar_keperluan/daftar_keperluan_screens.dart';
import 'package:batik_sesa_bojonegoro_app/screens/karyawan/karyawan_screens.dart';

class AppRoutes {
  static const String splash = '/';
  static const String pin = '/pin';
  static const String dashboard = '/dashboard';
  static const String bahanBaku = '/bahan-baku';
  static const String daftarKain = '/daftar-kain';
  static const String daftarKeperluan = '/daftar-keperluan';
  static const String karyawan = '/karyawan';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case pin:
        return MaterialPageRoute(builder: (_) => const PinScreen());
      case dashboard:
        return MaterialPageRoute(builder: (_) => MainNavigation());
      case bahanBaku:
        return MaterialPageRoute(builder: (_) => const BahanBakuScreen());
      case daftarKain:
        return MaterialPageRoute(builder: (_) => const DaftarKainScreen());
      case daftarKeperluan:
        return MaterialPageRoute(builder: (_) => const DaftarKeperluanScreen());
      case karyawan:
        return MaterialPageRoute(builder: (_) => const KaryawanScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}