import 'package:flutter/material.dart';
import 'package:cv_flutter_biarwanga_mugenyi_delphin/models/cv_data.dart';

class CVHomeScreen extends StatelessWidget {
  const CVHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. CARTE PROFIL PRINCIPALE (HEADER)
          _buildProfileHeaderCard(context, isDark),
          const SizedBox(height: 20),

          // 2. FORMATION ACADÉMIQUE
          _buildSectionHeader(
            context,
            icon: Icons.school_rounded,
            title: "Formation Académique",
            subtitle: "Parcours universitaire et spécialisation",
          ),
          const SizedBox(height: 10),
          _buildEducationCard(context, isDark),
          const SizedBox(height: 24),

          // 3. EXPÉRIENCES (STAGES & PROJETS)
          _buildSectionHeader(
            context,
            icon: Icons.work_history_rounded,
            title: "Expériences Professionnelles",
            subtitle: "Stages en entreprises & Projets majeurs",
          ),
          const SizedBox(height: 12),
          _buildStagesSection(context, isDark),
          const SizedBox(height: 16),
          _buildProjectsSection(context, isDark),
          const SizedBox(height: 24),

          // 4. COMPÉTENCES TECHNIQUES & LINGUISTIQUES
          _buildSectionHeader(
            context,
            icon: Icons.psychology_rounded,
            title: "Compétences",
            subtitle: "Expertise technique & Langues maîtrisées",
          ),
          const SizedBox(height: 12),
          _buildTechnicalSkillsCard(context, isDark),
          const SizedBox(height: 14),
          _buildLanguagesCard(context, isDark),
          const SizedBox(height: 24),

          // 5. CENTRES D'INTÉRÊT
          _buildSectionHeader(
            context,
            icon: Icons.sports_martial_arts_rounded,
            title: "Centres d'intérêt",
            subtitle: "Sports, veille scientifique et passions",
          ),
          const SizedBox(height: 12),
          _buildHobbiesGrid(context, isDark),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // --- WIDGETS DE SECTIONS ---

  Widget _buildProfileHeaderCard(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
              : [const Color(0xFF1E3A8A), const Color(0xFF1D4ED8)],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A).withAlpha(50),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Photo de Profil avec bordure stylisée
                Container(
                  padding: const EdgeInsets.all(3.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2DD4BF), Color(0xFFF59E0B)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(60),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      CVData.profileImage,
                      width: 92,
                      height: 92,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 92,
                          height: 92,
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
                const SizedBox(width: 16),

                // Informations Nominatives
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge Profil : ETUDIANT
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2DD4BF).withAlpha(40),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF2DD4BF), width: 1.2),
                        ),
                        child: const Text(
                          "PROFIL : ${CVData.profileTitle}",
                          style: TextStyle(
                            color: Color(0xFF2DD4BF),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Nom complet
                      Text(
                        CVData.fullName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Localisation
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 15, color: Colors.white.withAlpha(200)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              CVData.location,
                              style: TextStyle(
                                color: Colors.white.withAlpha(210),
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Bio descriptive
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                CVData.bio,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  height: 1.45,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 14),

            // Barre de statistiques rapides (Responsive Wrap)
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildStatPill("5 Stages", Icons.domain),
                  _buildStatPill("Flutter & Web", Icons.code),
                  _buildStatPill("3 Langues", Icons.translate),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildStatPill(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(40),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFFFBBF24)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1E3A8A).withAlpha(20),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF1E3A8A), size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                ),
              ),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEducationCard(BuildContext context, bool isDark) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0D9488).withAlpha(25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.school, color: Color(0xFF0D9488), size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "FORMATION UNIVERSITAIRE",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D9488),
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    CVData.degree,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Cycle de Licence approfondie axé sur l'architecture réseau, l'administration système, la transmission de données, la sécurité informatique et les télécommunications modernes.",
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _buildMiniBadge("Réseaux IP"),
                      _buildMiniBadge("Systèmes d'exploitation"),
                      _buildMiniBadge("Télécommunications"),
                      _buildMiniBadge("Cybersécurité"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStagesSection(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
          child: Row(
            children: [
              const Icon(Icons.apartment_rounded, size: 18, color: Color(0xFF1E3A8A)),
              const SizedBox(width: 6),
              Text(
                "STAGES EN ENTREPRISE (5)",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF1E3A8A),
                ),
              ),
            ],
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: CVData.stages.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final stage = CVData.stages[index];
            return Card(
              elevation: 1.5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge entreprise
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF1E3A8A),
                            const Color(0xFF0D9488),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          stage.logoText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  stage.company,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD97706).withAlpha(25),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  stage.period,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFD97706),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            stage.role,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFF2DD4BF) : const Color(0xFF0D9488),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            stage.description,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildProjectsSection(BuildContext context, bool isDark) {
    final project = CVData.projects.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
          child: Row(
            children: [
              const Icon(Icons.rocket_launch_rounded, size: 18, color: Color(0xFF0D9488)),
              const SizedBox(width: 6),
              Text(
                "PROJET RÉALISÉ",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: isDark ? const Color(0xFF2DD4BF) : const Color(0xFF0D9488),
                ),
              ),
            ],
          ),
        ),
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E3A8A).withAlpha(20),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.apps_rounded, color: Color(0xFF1E3A8A), size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            project.role,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF1E3A8A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  project.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: project.technologies.map((tech) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E3A8A).withAlpha(15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFF1E3A8A).withAlpha(40),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle_rounded, size: 13, color: Color(0xFF0D9488)),
                          const SizedBox(width: 5),
                          Text(
                            tech,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTechnicalSkillsCard(BuildContext context, bool isDark) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.terminal_rounded, color: Color(0xFF1E3A8A), size: 22),
                const SizedBox(width: 8),
                const Text(
                  "Compétences Techniques",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...CVData.technicalSkills.map((skill) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          skill.name,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${(skill.level * 100).toInt()}%",
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0D9488),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: skill.level,
                        minHeight: 7,
                        backgroundColor: isDark ? Colors.white12 : Colors.grey.shade200,
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1E3A8A)),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: skill.details.map((detail) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white10 : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            detail,
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguagesCard(BuildContext context, bool isDark) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.language_rounded, color: Color(0xFF0D9488), size: 22),
                const SizedBox(width: 8),
                const Text(
                  "Compétences Linguistiques",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ...CVData.languages.map((lang) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D9488).withAlpha(25),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          lang.language.substring(0, 2).toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xFF0D9488),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                lang.language,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                "${(lang.proficiency * 100).toInt()}%",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0D9488),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            lang.level,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: lang.proficiency,
                              minHeight: 5,
                              backgroundColor: isDark ? Colors.white12 : Colors.grey.shade200,
                              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0D9488)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildHobbiesGrid(BuildContext context, bool isDark) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: CVData.hobbies.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final hobby = CVData.hobbies[index];
        IconData iconData;
        Color iconColor;
        switch (hobby.name) {
          case "Boxe":
            iconData = Icons.sports_mma_rounded;
            iconColor = const Color(0xFFDC2626);
            break;
          case "Football":
            iconData = Icons.sports_soccer_rounded;
            iconColor = const Color(0xFF059669);
            break;
          case "Volleyball":
            iconData = Icons.sports_volleyball_rounded;
            iconColor = const Color(0xFFD97706);
            break;
          case "Les Recherches":
            iconData = Icons.travel_explore_rounded;
            iconColor = const Color(0xFF2563EB);
            break;
          case "Lire / Lecture":
            iconData = Icons.menu_book_rounded;
            iconColor = const Color(0xFF7C3AED);
            break;
          default:
            iconData = Icons.star_rounded;
            iconColor = const Color(0xFF1E3A8A);
        }

        return Card(
          elevation: 1.5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: iconColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(iconData, color: iconColor, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hobby.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.5,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        hobby.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildMiniBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF0D9488).withAlpha(20),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xFF0D9488),
        ),
      ),
    );
  }
}
