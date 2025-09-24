import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService {
  static const String _hasSeenOnboardingKey = 'hasSeenOnboarding';

  /// Verifica se o usuário já viu o onboarding
  static Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    final result = prefs.getBool(_hasSeenOnboardingKey) ?? false;
    return result;
  }

  /// Marca que o usuário já viu o onboarding
  static Future<void> markOnboardingAsSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasSeenOnboardingKey, true);
  }

  /// Reseta o onboarding (útil para testes)
  static Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_hasSeenOnboardingKey);
  }
}
