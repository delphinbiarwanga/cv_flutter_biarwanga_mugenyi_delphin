import 'package:flutter/material.dart';
import 'package:cv_flutter_biarwanga_mugenyi_delphin/models/cv_data.dart';
import 'package:cv_flutter_biarwanga_mugenyi_delphin/screens/main_navigation_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(text: "delphin");
  final _passwordController = TextEditingController(text: "1234");

  bool _isPasswordObscured = true;
  bool _isLoading = false;
  bool _rememberMe = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simuler une courte vérification pour un effet visuel fluide
    await Future.delayed(const Duration(milliseconds: 650));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    // Message de bienvenue
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "Bienvenue, ${_usernameController.text.trim()} !",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0D9488),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );

    // Navigation vers la page d'accueil principale avec transition fluide
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MainNavigationScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1E3A8A),
              const Color(0xFF0F172A),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Avatar / Logo
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withAlpha(200), width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(80),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          CVData.profileImage,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 100,
                              height: 100,
                              color: Colors.white24,
                              child: const Icon(
                                Icons.person,
                                size: 55,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Titres
                    const Text(
                      "PORTAIL CV PROFESSIONNEL",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                        color: Color(0xFF2DD4BF),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      CVData.fullName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Connexion pour accéder au CV, à la famille et aux contacts",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Carte du formulaire de connexion
                    Card(
                      elevation: 8,
                      shadowColor: Colors.black45,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "Authentification",
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1E3A8A),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Veuillez saisir vos identifiants pour continuer",
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 22),

                              // Champ Identifiant
                              TextFormField(
                                controller: _usernameController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  labelText: "Identifiant",
                                  hintText: "Entrez votre nom d'utilisateur",
                                  prefixIcon: const Icon(Icons.person_outline),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Veuillez renseigner votre identifiant";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Champ Mot de passe (texte masqué)
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _isPasswordObscured,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _handleLogin(),
                                decoration: InputDecoration(
                                  labelText: "Mot de passe",
                                  hintText: "••••••••",
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordObscured
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: Colors.grey.shade600,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordObscured = !_isPasswordObscured;
                                      });
                                    },
                                    tooltip: _isPasswordObscured
                                        ? "Afficher le mot de passe"
                                        : "Masquer le mot de passe",
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Veuillez saisir votre mot de passe";
                                  }
                                  if (value.trim().length < 3) {
                                    return "Le mot de passe doit comporter au moins 3 caractères";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),

                              // Options supplémentaires (Se souvenir de moi)
                              Row(
                                children: [
                                  SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: Checkbox(
                                      value: _rememberMe,
                                      activeColor: const Color(0xFF1E3A8A),
                                      onChanged: (val) {
                                        setState(() {
                                          _rememberMe = val ?? true;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "Se souvenir de moi",
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              // Bouton « Se connecter »
                              SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _handleLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1E3A8A),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 3,
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.login, size: 20),
                                            SizedBox(width: 10),
                                            Text(
                                              "Se connecter",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Badge aide / Info rapide pour la démo
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(25),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.info_outline, color: Color(0xFF2DD4BF), size: 16),
                          SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              "Démo rapide : identifiants pré-remplis par défaut",
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
