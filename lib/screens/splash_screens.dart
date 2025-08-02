import 'package:batik_sesa_bojonegoro_app/core/provider/pin_provider.dart';
import 'package:batik_sesa_bojonegoro_app/screens/pin_screens.dart';
import 'package:batik_sesa_bojonegoro_app/widgets/navbottom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Initialize fade animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    // Start the animation
    _controller.forward();

    // Load settings and navigate
    _initializeApp();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    await ref.read(pinProvider.notifier).loadSettings();
    if (mounted) {
      _navigateToAppropriateScreen();
    }
  }

  Future<void> _navigateToAppropriateScreen() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final pinState = ref.read(pinProvider);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) =>
            pinState.isPinEnabled ? const PinScreen() : MainNavigation(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1976D2), Color(0xFF0D47A1)],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'BATIK SESA',
                  style: TextStyle(
                    fontFamily: 'Sriwedari',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 56,
                  ),
                ),
                Text(
                  'Bojonegoro, Jawa Timur',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 10),
                LoadingAnimationWidget.progressiveDots(
                  color: Colors.white,
                  size: 50,
                ),
                const SizedBox(height: 10),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'Memuat Aplikasi...',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
