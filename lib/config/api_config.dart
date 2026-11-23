class ApiConfig {
  /// URL de base de l'API REST locale hébergée sur XAMPP.
  ///
  /// Pour tester sur un TÉLÉPHONE PHYSIQUE connecté par câble USB :
  /// Le port 80 sur Android est un port privilégié (< 1024) qui requiert root.
  /// On utilise le port 8080 redirigé vers le port 80 du PC avec :
  ///    adb reverse tcp:8080 tcp:80
  static const String baseUrl = 'http://127.0.0.1:8080/api-test/public';

  // Endpoints Authentification
  static const String registerEndpoint = '$baseUrl/accounts/register';
  static const String loginEndpoint = '$baseUrl/accounts/login';

  // Endpoints Membres de Famille
  static const String familleMembresEndpoint = '$baseUrl/famille-membres';

  /// Helper pour convertir l'URL de l'image retournée par l'API (ex: http://localhost/api-test/public/uploads/...)
  /// en une URL accessible depuis le téléphone physique avec notre [baseUrl] configuré.
  static String? resolveImageUrl(String? rawUrl) {
    if (rawUrl == null || rawUrl.trim().isEmpty) return null;

    final trimmed = rawUrl.trim();

    // Remplacement du préfixe localhost retourné par le script PHP
    if (trimmed.contains('/api-test/public/')) {
      final pathAfterPublic = trimmed.substring(
        trimmed.indexOf('/api-test/public/') + '/api-test/public/'.length,
      );
      return '$baseUrl/$pathAfterPublic';
    }

    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }

    if (trimmed.startsWith('/')) {
      return '$baseUrl$trimmed';
    }

    return '$baseUrl/$trimmed';
  }
}
