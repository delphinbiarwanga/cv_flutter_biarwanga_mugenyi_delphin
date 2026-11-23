import 'package:flutter/material.dart';
import 'package:cv_flutter_biarwanga_mugenyi_delphin/models/cv_data.dart';
import 'package:cv_flutter_biarwanga_mugenyi_delphin/screens/cv_home_screen.dart';
import 'package:cv_flutter_biarwanga_mugenyi_delphin/screens/family_screen.dart';
import 'package:cv_flutter_biarwanga_mugenyi_delphin/screens/contact_screen.dart';
import 'package:cv_flutter_biarwanga_mugenyi_delphin/screens/login_screen.dart';
import 'package:cv_flutter_biarwanga_mugenyi_delphin/services/session_service.dart';
import 'package:cv_flutter_biarwanga_mugenyi_delphin/services/url_launcher_service.dart';

class MainNavigationScreen extends StatefulWidget {
  final Function(bool)? onThemeToggle;
  final bool isDarkMode;

  const MainNavigationScreen({
    super.key,
    this.onThemeToggle,
    this.isDarkMode = false,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  String _userEmail = CVData.email;

  final List<Widget> _pages = const [
    CVHomeScreen(),
    FamilyScreen(),
    ContactScreen(),
  ];

  final List<String> _titles = const [
    "Mon CV Professionnel",
    "Ma Famille",
    "Mes Coordonnées",
  ];

  @override
  void initState() {
    super.initState();
    _loadUserSession();
  }

  Future<void> _loadUserSession() async {
    final user = await SessionService.getUserSession();
    if (user != null && user.email.isNotEmpty) {
      setState(() {
        _userEmail = user.email;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: Colors.redAccent),
            SizedBox(width: 10),
            Text("Déconnexion"),
          ],
        ),
        content: const Text(
          "Êtes-vous sûr de vouloir vous déconnecter et fermer votre session ?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(context); // fermer la boîte de dialogue
              await SessionService.clearSession(); // Effacer la session SharedPreferences

              if (!context.mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text("Se déconnecter"),
          ),
        ],
      ),
    );
  }

  void _showAppInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: Color(0xFF1E3A8A)),
            SizedBox(width: 10),
            Text("À propos du projet"),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Application Mobile CV Flutter & API XAMPP",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 6),
              const Text("Auteur : BIARWANGA MUGENYI DELPHIN"),
              const Text("Profil : ETUDIANT"),
              const Text("Formation : Licence Réseau Système & Télécom"),
              const Divider(height: 20),
              const Text(
                "Fonctionnalités & Intégration :",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text("• Authentification (Login & Register) connectée à l'API PHP"),
              const Text("• Session persistante SharedPreferences"),
              const Text("• CRUD complet Membres de famille (GET, POST, PUT, DELETE)"),
              const Text("• Gestion upload d'images multipart & dates AAAA-MM-JJ"),
              const Text("• Contacts interactifs (Appels, Emails, WhatsApp, URLs)"),
              const SizedBox(height: 12),
              const Text(
                "API locale : XAMPP (api-test)",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fermer"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            tooltip: "À propos du projet",
            onPressed: _showAppInfoDialog,
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: "Se déconnecter",
            onPressed: _confirmLogout,
          ),
        ],
      ),

      // 1. NAVIGATION DRAWER
      drawer: Drawer(
        child: Column(
          children: [
            // En-tête personnalisé
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 44, 16, 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1E3A8A), Color(0xFF0F172A)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(2.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF2DD4BF), width: 2),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        CVData.profileImage,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 70,
                          height: 70,
                          color: Colors.white24,
                          child: const Icon(Icons.person, size: 40, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    CVData.fullName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2DD4BF).withAlpha(40),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      "PROFIL : ETUDIANT",
                      style: TextStyle(
                        color: Color(0xFF2DD4BF),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.account_circle, size: 13, color: Colors.white70),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _userEmail,
                          style: TextStyle(
                            color: Colors.white.withAlpha(200),
                            fontSize: 11,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Liens vers les pages principales
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const SizedBox(height: 8),
                  ListTile(
                    leading: const Icon(Icons.badge_rounded, color: Color(0xFF1E3A8A)),
                    title: const Text("Mon CV Complet"),
                    subtitle: const Text("Profil, études, stages et loisirs"),
                    selected: _currentIndex == 0,
                    selectedTileColor: const Color(0xFF1E3A8A).withAlpha(25),
                    onTap: () {
                      Navigator.pop(context);
                      _onItemTapped(0);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.diversity_1_rounded, color: Color(0xFF0D9488)),
                    title: const Text("Ma Famille"),
                    subtitle: const Text("Membres & synchronisation BDD"),
                    selected: _currentIndex == 1,
                    selectedTileColor: const Color(0xFF0D9488).withAlpha(25),
                    onTap: () {
                      Navigator.pop(context);
                      _onItemTapped(1);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.contact_phone_rounded, color: Color(0xFFD97706)),
                    title: const Text("Mes Coordonnées"),
                    subtitle: const Text("Contacts et liens cliquables"),
                    selected: _currentIndex == 2,
                    selectedTileColor: const Color(0xFFD97706).withAlpha(25),
                    onTap: () {
                      Navigator.pop(context);
                      _onItemTapped(2);
                    },
                  ),
                  const Divider(height: 24),

                  // Actions rapides
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                    child: Text(
                      "ACTIONS RAPIDES",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.call_outlined, color: Colors.green),
                    title: const Text("Appeler Delphin"),
                    subtitle: Text(CVData.phone),
                    onTap: () {
                      Navigator.pop(context);
                      UrlLauncherService.makePhoneCall(context, CVData.phone);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.mail_outline, color: Colors.redAccent),
                    title: const Text("Envoyer un e-mail"),
                    subtitle: Text(CVData.email),
                    onTap: () {
                      Navigator.pop(context);
                      UrlLauncherService.sendEmail(context, email: CVData.email);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.link_rounded, color: Color(0xFF0077B5)),
                    title: const Text("Profil LinkedIn"),
                    onTap: () {
                      Navigator.pop(context);
                      UrlLauncherService.openWebUrl(context, CVData.linkedInUrl);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.code_rounded, color: Colors.black87),
                    title: const Text("Dépôt GitHub"),
                    onTap: () {
                      Navigator.pop(context);
                      UrlLauncherService.openWebUrl(context, CVData.githubUrl);
                    },
                  ),
                ],
              ),
            ),

            // Déconnexion
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
              title: const Text(
                "Se déconnecter",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _confirmLogout();
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),

      // 2. CORPS DE PAGE ACTUELLE
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      // 3. NAVIGATION BAR INFERIEURE (Material 3)
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.badge_outlined),
            selectedIcon: Icon(Icons.badge_rounded),
            label: "Mon CV",
          ),
          NavigationDestination(
            icon: Icon(Icons.diversity_1_outlined),
            selectedIcon: Icon(Icons.diversity_1_rounded),
            label: "Famille",
          ),
          NavigationDestination(
            icon: Icon(Icons.contact_phone_outlined),
            selectedIcon: Icon(Icons.contact_phone_rounded),
            label: "Contact",
          ),
        ],
      ),
    );
  }
}
