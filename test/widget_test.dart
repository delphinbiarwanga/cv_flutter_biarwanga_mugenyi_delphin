import 'package:flutter_test/flutter_test.dart';
import 'package:cv_flutter_biarwanga_mugenyi_delphin/main.dart';

void main() {
  testWidgets('Smoke test: Vérification du chargement de la page de connexion',
      (WidgetTester tester) async {
    // Lance l'application
    await tester.pumpWidget(const MyApp());

    // Vérifie que le titre et le bouton de connexion sont présents
    expect(find.text('PORTAIL CV PROFESSIONNEL'), findsOneWidget);
    expect(find.text('Se connecter'), findsOneWidget);
    expect(find.text('Identifiant'), findsOneWidget);
    expect(find.text('Mot de passe'), findsOneWidget);
  });
}
