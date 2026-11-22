import 'package:flutter/material.dart';
import 'package:cv_flutter_biarwanga_mugenyi_delphin/models/famille_membre.dart';
import 'package:cv_flutter_biarwanga_mugenyi_delphin/services/api_service.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  List<FamilleMembre> _membres = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final list = await ApiService.getFamilleMembres();
      if (!mounted) return;
      setState(() {
        _membres = list;
        _isLoading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.fullErrorMessage;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = "Impossible de charger les statistiques : $e";
        _isLoading = false;
      });
    }
  }

  // Calcul de la répartition par parenté
  Map<String, int> get _repartitionParente {
    final map = <String, int>{};
    for (var m in _membres) {
      final key = m.parente.trim().isEmpty ? 'Autre' : m.parente.trim();
      map[key] = (map[key] ?? 0) + 1;
    }
    return map;
  }

  // Calcul de la répartition par lieu de naissance
  Map<String, int> get _repartitionLieu {
    final map = <String, int>{};
    for (var m in _membres) {
      final key = m.lieuNaissance.trim().isEmpty ? 'Non renseigné' : m.lieuNaissance.trim();
      map[key] = (map[key] ?? 0) + 1;
    }
    return map;
  }

  // Calcul de l'âge moyen, min et max
  Map<String, dynamic> get _statistiquesAges {
    if (_membres.isEmpty) {
      return {'moyen': 0, 'min': 0, 'max': 0, 'count': 0};
    }

    final now = DateTime.now();
    final ages = <int>[];

    for (var m in _membres) {
      try {
        final birthDate = DateTime.parse(m.dateNaissance);
        int age = now.year - birthDate.year;
        if (now.month < birthDate.month ||
            (now.month == birthDate.month && now.day < birthDate.day)) {
          age--;
        }
        if (age >= 0) ages.add(age);
      } catch (_) {}
    }

    if (ages.isEmpty) {
      return {'moyen': 0, 'min': 0, 'max': 0, 'count': 0};
    }

    final total = ages.reduce((a, b) => a + b);
    final moyen = (total / ages.length).round();
    ages.sort();

    return {
      'moyen': moyen,
      'min': ages.first,
      'max': ages.last,
      'count': ages.length,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadData,
        color: const Color(0xFF1E3A8A),
        child: _buildBody(theme, isDark),
      ),
    );
  }

  Widget _buildBody(ThemeData theme, bool isDark) {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF1E3A8A)),
            SizedBox(height: 16),
            Text(
              "Calcul des statistiques depuis l'API...",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off_rounded, size: 56, color: Colors.redAccent),
              const SizedBox(height: 14),
              const Text(
                "Erreur de synchronisation",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
              const SizedBox(height: 18),
              ElevatedButton.icon(
                onPressed: _loadData,
                icon: const Icon(Icons.refresh),
                label: const Text("Réessayer"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final total = _membres.length;
    final statsAges = _statistiquesAges;
    final parenteMap = _repartitionParente;
    final lieuMap = _repartitionLieu;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Bannière En-tête Statistiques
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                    : [const Color(0xFF1E3A8A), const Color(0xFF2563EB)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1E3A8A).withAlpha(50),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.analytics_rounded, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "DONNÉES EN TEMPS RÉEL",
                        style: TextStyle(
                          color: Color(0xFF93C5FD),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        "Statistiques de la Famille",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "Calculé dynamiquement depuis l'API XAMPP",
                        style: TextStyle(
                          color: Colors.white.withAlpha(200),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 1. Cartes Compteurs Généraux
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  title: "Total Membres",
                  value: "$total",
                  icon: Icons.people_alt_rounded,
                  color: const Color(0xFF1E3A8A),
                  subtitle: "Enregistrés en BDD",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  title: "Âge Moyen",
                  value: total > 0 ? "${statsAges['moyen']} ans" : "N/A",
                  icon: Icons.cake_rounded,
                  color: const Color(0xFF0D9488),
                  subtitle: total > 0
                      ? "Min: ${statsAges['min']} • Max: ${statsAges['max']}"
                      : "Pas de date",
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 2. Répartition par Lien de Parenté (avec jauges dynamiques)
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E3A8A).withAlpha(20),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.family_restroom, color: Color(0xFF1E3A8A), size: 20),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Répartition par Parenté",
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (parenteMap.isEmpty)
                    const Text("Aucun membre enregistré.", style: TextStyle(color: Colors.grey))
                  else
                    ...parenteMap.entries.map((entry) {
                      final percentage = total > 0 ? (entry.value / total) : 0.0;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  entry.key,
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                ),
                                Text(
                                  "${entry.value} (${(percentage * 100).toStringAsFixed(1)}%)",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.5,
                                    color: Color(0xFF0D9488),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: percentage,
                                minHeight: 7,
                                backgroundColor: isDark ? Colors.white12 : Colors.grey.shade200,
                                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1E3A8A)),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),

          // 3. Répartition par Lieu de Naissance
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D9488).withAlpha(20),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.location_city_rounded, color: Color(0xFF0D9488), size: 20),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Lieux de Naissance",
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (lieuMap.isEmpty)
                    const Text("Aucun lieu enregistré.", style: TextStyle(color: Colors.grey))
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: lieuMap.entries.map((e) {
                        return Chip(
                          avatar: CircleAvatar(
                            backgroundColor: const Color(0xFF0D9488),
                            child: Text(
                              "${e.value}",
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                          label: Text(e.key),
                          backgroundColor: isDark ? Colors.white10 : Colors.grey.shade100,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String subtitle,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withAlpha(20),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
