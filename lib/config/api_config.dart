class ApiConfig {
  /// URL de base de l'API REST locale hébergée sur XAMPP.
  ///
  /// Pour tester sur un TÉLÉPHONE PHYSIQUE connecté par câble USB :
  /// 1. Exécutez dans le terminal de votre PC :
  ///    adb reverse tcp:80 tcp:80
  ///    (Cela redirige le port 80 du téléphone vers le port 80 de votre PC XAMPP)
  ///    Dans ce cas, utilisez : 'http://127.0.0.1/api-test/public'
  ///
  /// 2. Si vous êtes sur le MÊME RÉSEAU WI-FI sans redirection adb, remplacez par l'IP locale de votre PC :
  ///    Exemple : 'http://192.168.1.15/api-test/public' (trouvez votre IP avec 'ipconfig' sous Windows)
  ///
  /// 3. Si vous utilisez l'émulateur Android standard :
  ///    Utilisez : 'http://10.0.2.2/api-test/public'
  static const String baseUrl = 'http://127.0.0.1/api-test/public';

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
