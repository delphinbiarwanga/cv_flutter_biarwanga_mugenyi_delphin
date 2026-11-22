import 'package:shared_preferences/shared_preferences.dart';
import 'package:cv_flutter_biarwanga_mugenyi_delphin/models/user_account.dart';

class SessionService {
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyCreatedAt = 'user_created_at';
  static const String _keyIsLoggedIn = 'is_logged_in';

  /// Sauvegarde la session après connexion ou inscription
  static Future<void> saveUserSession(UserAccount user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyUserId, user.id);
    await prefs.setString(_keyUserEmail, user.email);
    if (user.createdAt != null) {
      await prefs.setString(_keyCreatedAt, user.createdAt!);
    }
    await prefs.setBool(_keyIsLoggedIn, true);
  }

  /// Récupère l'utilisateur connecté actuellement
  static Future<UserAccount?> getUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;
    if (!isLoggedIn) return null;

    final id = prefs.getInt(_keyUserId) ?? 0;
    final email = prefs.getString(_keyUserEmail) ?? '';
    final createdAt = prefs.getString(_keyCreatedAt);

    return UserAccount(
      id: id,
      email: email,
      createdAt: createdAt,
    );
  }

  /// Vérifie si une session active existe
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  /// Déconnecte l'utilisateur en effaçant les données stockées
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUserEmail);
    await prefs.remove(_keyCreatedAt);
    await prefs.setBool(_keyIsLoggedIn, false);
  }
}
