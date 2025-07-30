import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:heroicons/heroicons.dart';
import 'package:batik_sesa_bojonegoro_app/screens/dashboard/dashboard_screens.dart';
import 'package:batik_sesa_bojonegoro_app/screens/bahan_baku/bahan_baku_screens.dart';
import 'package:batik_sesa_bojonegoro_app/screens/daftar_kain/daftar_kain_screens.dart';
import 'package:batik_sesa_bojonegoro_app/screens/daftar_keperluan/daftar_keperluan_screens.dart';
import 'package:batik_sesa_bojonegoro_app/screens/karyawan/karyawan_screens.dart';

class MainNavigation extends ConsumerWidget {
  MainNavigation({super.key});

  final PersistentTabController _controller = PersistentTabController(
    initialIndex: 0,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      navBarStyle: NavBarStyle.style10,
    );
  }

  List<Widget> _buildScreens() {
    return [
      const DashboardScreen(),
      const BahanBakuScreen(),
      const DaftarKainScreen(),
      const DaftarKeperluanScreen(),
      const KaryawanScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const HeroIcon(HeroIcons.home),
        title: "Dashboard",
        textStyle: TextStyle(fontWeight: FontWeight.bold),
        activeColorPrimary: Colors.blueAccent,
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const HeroIcon(HeroIcons.cube),
        title: "Bahan Baku",
        textStyle: TextStyle(fontWeight: FontWeight.bold),
        activeColorPrimary: Colors.blueAccent,
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const HeroIcon(HeroIcons.swatch),
        title: "Kain",
        textStyle: TextStyle(fontWeight: FontWeight.bold),
        activeColorPrimary: Colors.blueAccent,
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const HeroIcon(HeroIcons.clipboardDocumentList),
        title: "Keperluan",
        textStyle: TextStyle(fontWeight: FontWeight.bold),
        activeColorPrimary: Colors.blueAccent,
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const HeroIcon(HeroIcons.users),
        title: "Karyawan",
        textStyle: TextStyle(fontWeight: FontWeight.bold),
        activeColorPrimary: Colors.blueAccent,
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }
}
