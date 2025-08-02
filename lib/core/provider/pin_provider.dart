import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final pinProvider = StateNotifierProvider<PinNotifier, PinState>((ref) {
  return PinNotifier();
});

class PinState {
  final String pin;
  final bool isPinEnabled;
  final bool isFirstTime;

  PinState({
    required this.pin,
    required this.isPinEnabled,
    required this.isFirstTime,
  });

  PinState copyWith({String? pin, bool? isPinEnabled, bool? isFirstTime}) {
    return PinState(
      pin: pin ?? this.pin,
      isPinEnabled: isPinEnabled ?? this.isPinEnabled,
      isFirstTime: isFirstTime ?? this.isFirstTime,
    );
  }
}

class PinNotifier extends StateNotifier<PinState> {
  PinNotifier()
    : super(PinState(pin: '123456', isPinEnabled: false, isFirstTime: true));

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = state.copyWith(
      pin: prefs.getString('pin') ?? '123456',
      isPinEnabled: prefs.getBool('isPinEnabled') ?? false,
      isFirstTime: prefs.getBool('isFirstTime') ?? true,
    );
  }

  bool verifyPin(String enteredPin) {
    return enteredPin == state.pin;
  }

  Future<void> updatePin(String newPin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pin', newPin);
    state = state.copyWith(pin: newPin);
  }

  Future<void> togglePinEnabled(bool enabled, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPinEnabled', enabled);
    state = state.copyWith(isPinEnabled: enabled);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            enabled ? 'PIN diaktifkan' : 'PIN dinonaktifkan',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: enabled ? Colors.green : Colors.red,
        ),
      );
    }
  }

  Future<void> resetPin({bool? keepEnabledStatus}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pin', '123456');
    final currentStatus = keepEnabledStatus ?? state.isPinEnabled;

    state = state.copyWith(pin: '123456', isPinEnabled: currentStatus);
  }
}
