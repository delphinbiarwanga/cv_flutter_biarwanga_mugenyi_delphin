import 'package:flutter/material.dart';
import 'package:cv_flutter_biarwanga_mugenyi_delphin/models/cv_data.dart';
import 'package:cv_flutter_biarwanga_mugenyi_delphin/services/api_service.dart';
import 'package:cv_flutter_biarwanga_mugenyi_delphin/services/session_service.dart';
import 'package:cv_flutter_biarwanga_mugenyi_delphin/screens/main_navigation_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController(text: "delphinbiarwanga1@gmail.com");
  final _passwordController = TextEditingController(text: "123456");
  final _confirmPasswordController = TextEditingController();

  bool _isLoginMode = true; // true = Connexion, false = Inscription
  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _switchAuthMode() {
    setState(() {
      _isLoginMode = !_isLoginMode;
      _errorMessage = null;
      _confirmPasswordController.clear();
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      if (_isLoginMode) {
        // 1. CONNEXION (POST /accounts/login)
        final user = await ApiService.login(email: email, password: password);
        await SessionService.saveUserSession(user);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Connexion réussie ! Bienvenue ${user.email}",
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
      } else {
        // 2. INSCRIPTION (POST /accounts/register)
        final user = await ApiService.register(email: email, password: password);
        await SessionService.saveUserSession(user);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Compte créé avec succès ! Bienvenue ${user.email}",
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
      }

      if (!mounted) return;

      // Navigation vers l'application principale
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainNavigationScreen(),
        ),
      );
    } on ApiException catch (e) {
      setState(() {
        _errorMessage = e.fullErrorMessage;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Erreur inattendue : $e";
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E3A8A),
              Color(0xFF0F172A),
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
                    // Avatar / Photo de profil Delphin
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
                          width: 88,
                          height: 88,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 88,
                              height: 88,
                              color: Colors.white24,
                              child: const Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Titres
                    const Text(
                      "PORTAIL CV & FAMILLE XAMPP",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                        color: Color(0xFF2DD4BF),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      CVData.fullName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Carte du Formulaire
                    Card(
                      elevation: 8,
                      shadowColor: Colors.black45,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(22.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Onglets Bascule Connexion / Inscription
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.all(4),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          if (!_isLoginMode) _switchAuthMode();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                          decoration: BoxDecoration(
                                            color: _isLoginMode ? const Color(0xFF1E3A8A) : Colors.transparent,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            "Connexion",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: _isLoginMode ? Colors.white : Colors.grey.shade700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          if (_isLoginMode) _switchAuthMode();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                          decoration: BoxDecoration(
                                            color: !_isLoginMode ? const Color(0xFF1E3A8A) : Colors.transparent,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            "Inscription",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: !_isLoginMode ? Colors.white : Colors.grey.shade700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 18),

                              // Message d'erreur
                              if (_errorMessage != null) ...[
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.red.shade300),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.error_outline, color: Colors.redAccent, size: 20),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          _errorMessage!,
                                          style: TextStyle(
                                            color: Colors.red.shade800,
                                            fontSize: 12.5,
                                            height: 1.35,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],

                              // Champ Email (max 100)
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                maxLength: 100,
                                decoration: InputDecoration(
                                  labelText: "Adresse E-mail *",
                                  hintText: "exemple@gmail.com",
                                  prefixIcon: const Icon(Icons.alternate_email_rounded),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  counterText: "",
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Veuillez renseigner votre email";
                                  }
                                  final email = value.trim();
                                  if (!email.contains('@') || !email.contains('.')) {
                                    return "Format d'email invalide";
                                  }
                                  if (email.length > 100) {
                                    return "100 caractères maximum";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 14),

                              // Champ Mot de passe (min 6)
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _isPasswordObscured,
                                textInputAction: _isLoginMode ? TextInputAction.done : TextInputAction.next,
                                onFieldSubmitted: (_) {
                                  if (_isLoginMode) _handleSubmit();
                                },
                                decoration: InputDecoration(
                                  labelText: "Mot de passe * (min. 6 caractères)",
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
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Veuillez saisir votre mot de passe";
                                  }
                                  if (value.length < 6) {
                                    return "Le mot de passe doit comporter au moins 6 caractères";
                                  }
                                  return null;
                                },
                              ),

                              // Confirmation du mot de passe en mode inscription
                              if (!_isLoginMode) ...[
                                const SizedBox(height: 14),
                                TextFormField(
                                  controller: _confirmPasswordController,
                                  obscureText: _isConfirmPasswordObscured,
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (_) => _handleSubmit(),
                                  decoration: InputDecoration(
                                    labelText: "Confirmer le mot de passe *",
                                    hintText: "••••••••",
                                    prefixIcon: const Icon(Icons.lock_reset_rounded),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isConfirmPasswordObscured
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: Colors.grey.shade600,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isConfirmPasswordObscured = !_isConfirmPasswordObscured;
                                        });
                                      },
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (!_isLoginMode) {
                                      if (value == null || value.isEmpty) {
                                        return "Veuillez confirmer votre mot de passe";
                                      }
                                      if (value != _passwordController.text) {
                                        return "Les mots de passe ne correspondent pas";
                                      }
                                    }
                                    return null;
                                  },
                                ),
                              ],
                              const SizedBox(height: 22),

                              // Bouton d'action principal
                              SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _handleSubmit,
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
                                      : Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              _isLoginMode ? Icons.login_rounded : Icons.person_add_rounded,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              _isLoginMode ? "Se connecter" : "Créer mon compte",
                                              style: const TextStyle(
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
                    const SizedBox(height: 16),

                    // Information réseau USB & XAMPP
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
                          Icon(Icons.usb_rounded, color: Color(0xFF2DD4BF), size: 16),
                          SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              "API Locale XAMPP connectée via adb reverse / IP",
                              style: TextStyle(color: Colors.white70, fontSize: 11.5),
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
