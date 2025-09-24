import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _usernameKey = 'username';
  static const String _rememberMeKey = 'remember_me';

  // Credenciais mockadas
  static const String _mockUsername = 'joao';
  static const String _mockPassword = '123';

  /// Verifica se o usuário está logado
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  /// Realiza o login com as credenciais fornecidas
  static Future<bool> login(String username, String password, {bool rememberMe = false}) async {
    // Verifica se as credenciais são válidas (mock)
    if (username == _mockUsername && password == _mockPassword) {
      final prefs = await SharedPreferences.getInstance();
      
      // Salva o estado de login
      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setString(_usernameKey, username);
      await prefs.setBool(_rememberMeKey, rememberMe);
      
      return true;
    }
    return false;
  }

  /// Realiza o logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool(_rememberMeKey) ?? true; // Padrão é true
    
    // Se não está marcado para lembrar, remove todas as informações
    if (!rememberMe) {
      await prefs.remove(_isLoggedInKey);
      await prefs.remove(_usernameKey);
    } else {
      // Se está marcado para lembrar, apenas remove o estado de logado
      await prefs.setBool(_isLoggedInKey, false);
    }
  }

  /// Obtém o nome do usuário logado
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  /// Verifica se o usuário marcou para lembrar
  static Future<bool> isRememberMeEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getBool(_rememberMeKey);
      
      // Se não há valor salvo (null), retorna true como padrão
      if (value == null) {
        return true;
      }
      
      // Se há valor salvo, retorna esse valor
      return value;
    } catch (e) {
      // Se houver erro, retorna true como padrão
      return true;
    }
  }

  /// Verifica se já foi definido um valor para rememberMe
  static Future<bool> hasRememberMeBeenSet() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_rememberMeKey);
    } catch (e) {
      return false;
    }
  }

  /// Define se o usuário quer ser lembrado
  static Future<void> setRememberMe(bool rememberMe) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, rememberMe);
  }

  /// Limpa todas as informações de autenticação
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_rememberMeKey);
  }
}
