import 'package:batik_sesa_bojonegoro_app/core/provider/pin_provider.dart';
import 'package:batik_sesa_bojonegoro_app/widgets/navbottom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:batik_sesa_bojonegoro_app/core/routes/app_routes.dart';

class PinScreen extends ConsumerWidget {
  const PinScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Masukkan PIN',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const HeroIcon(
                      HeroIcons.lockClosed,
                      size: 32,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Masukkan 6 digit PIN Anda',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const PinInputField(),
                ],
              ),
              Column(
                children: [
                  TextButton(
                    onPressed: () {
                      // Handle forgot PIN
                    },
                    child: const Text(
                      'Lupa PIN?',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PinInputField extends ConsumerStatefulWidget {
  const PinInputField({super.key});

  @override
  ConsumerState<PinInputField> createState() => _PinInputFieldState();
}

class _PinInputFieldState extends ConsumerState<PinInputField> {
  final List<String> _pin = [];
  bool isError = false;
  bool isLoading = false;

  void _addDigit(String digit) {
    if (_pin.length < 6 && !isLoading) {
      setState(() {
        _pin.add(digit);
        isError = false;
      });
    }

    if (_pin.length == 6) {
      _verifyPin();
    }
  }

  Future<void> _verifyPin() async {
    setState(() => isLoading = true);

    await Future.delayed(const Duration(milliseconds: 300));

    final pinState = ref.read(pinProvider);
    final enteredPin = _pin.join();

    if (enteredPin == pinState.pin) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => MainNavigation(),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c),
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    } else {
      HapticFeedback.heavyImpact();
      setState(() {
        isError = true;
        _pin.clear();
      });
    }
    setState(() => isLoading = false);
  }

  void _removeDigit() {
    if (_pin.isNotEmpty && !isLoading) {
      setState(() {
        _pin.removeLast();
        isError = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(6, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 20,
              height: 20,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index < _pin.length
                    ? isError
                          ? Colors.red
                          : Colors.blueAccent
                    : Colors.grey[300],
                border: index < _pin.length
                    ? null
                    : Border.all(color: Colors.grey[400]!, width: 1),
              ),
            );
          }),
        ),
        if (isError) ...[
          const SizedBox(height: 16),
          const Text(
            'PIN salah, coba lagi',
            style: TextStyle(color: Colors.red, fontSize: 14),
          ),
        ],
        const SizedBox(height: 40),
        NumericKeyboard(
          onDigitPressed: _addDigit,
          onBackspacePressed: _removeDigit,
        ),
      ],
    );
  }
}

class NumericKeyboard extends StatelessWidget {
  final Function(String) onDigitPressed;
  final Function() onBackspacePressed;

  const NumericKeyboard({
    super.key,
    required this.onDigitPressed,
    required this.onBackspacePressed,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 1.5,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: [
        for (int i = 1; i <= 9; i++)
          _buildKey(
            text: i.toString(),
            onPressed: () => onDigitPressed(i.toString()),
          ),
        const SizedBox.shrink(),
        _buildKey(text: '0', onPressed: () => onDigitPressed('0')),
        _buildIconKey(
          icon: const HeroIcon(HeroIcons.backspace, size: 24),
          onPressed: onBackspacePressed,
        ),
      ],
    );
  }

  Widget _buildKey({required String text, required VoidCallback onPressed}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(40),
        onTap: onPressed,
        splashColor: Colors.blueAccent.withOpacity(0.2),
        highlightColor: Colors.blueAccent.withOpacity(0.1),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconKey({
    required HeroIcon icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(40),
        onTap: onPressed,
        splashColor: Colors.blueAccent.withOpacity(0.2),
        highlightColor: Colors.blueAccent.withOpacity(0.1),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: IconTheme(
              data: const IconThemeData(color: Colors.black54),
              child: icon,
            ),
          ),
        ),
      ),
    );
  }
}
