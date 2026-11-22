import 'package:flutter_test/flutter_test.dart';
import 'package:cv_flutter_biarwanga_mugenyi_delphin/main.dart';

void main() {
  testWidgets('Smoke test: Vérification du chargement de la page de connexion',
      (WidgetTester tester) async {
    // Lance l'application en mode déconnecté
    await tester.pumpWidget(const MyApp(isLoggedIn: false));

    // Vérifie que le portail, les onglets et le bouton sont présents
    expect(find.text('PORTAIL CV & FAMILLE XAMPP'), findsOneWidget);
    expect(find.text('Connexion'), findsOneWidget);
    expect(find.text('Inscription'), findsOneWidget);
    expect(find.text('Se connecter'), findsOneWidget);
  });
}
