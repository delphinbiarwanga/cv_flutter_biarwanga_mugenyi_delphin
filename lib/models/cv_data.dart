class StageExperience {
  final String company;
  final String role;
  final String period;
  final String description;
  final String logoText;

  const StageExperience({
    required this.company,
    required this.role,
    required this.period,
    required this.description,
    required this.logoText,
  });
}

class ProjectItem {
  final String title;
  final String role;
  final String description;
  final List<String> technologies;

  const ProjectItem({
    required this.title,
    required this.role,
    required this.description,
    required this.technologies,
  });
}

class TechnicalSkill {
  final String name;
  final double level; // 0.0 à 1.0
  final String category;
  final List<String> details;

  const TechnicalSkill({
    required this.name,
    required this.level,
    required this.category,
    required this.details,
  });
}

class LanguageSkill {
  final String language;
  final String level;
  final double proficiency; // 0.0 à 1.0

  const LanguageSkill({
    required this.language,
    required this.level,
    required this.proficiency,
  });
}

class HobbyItem {
  final String name;
  final String description;
  final String iconCode;

  const HobbyItem({
    required this.name,
    required this.description,
    required this.iconCode,
  });
}

class CVData {
  static const String fullName = "BIARWANGA MUGENYI DELPHIN";
  static const String profileTitle = "ETUDIANT";
  static const String degree = "LICENCE EN RESEAU SYSTEME ET TELECOMUNICATION";
  static const String profileImage = "assets/images/profile.jpg";
  static const String email = "delphinbiarwanga1@gmail.com";
  static const String phone = "0818621552";
  static const String phoneInternational = "+243818621552";
  static const String linkedInUrl = "https://www.linkedin.com/in/delphin-biarwanga-mugenyi";
  static const String githubUrl = "https://github.com/delphinbiarwanga";
  static const String location = "Kinshasa, République Démocratique du Congo";
  static const String bio =
      "Étudiant passionné et rigoureux en Licence Réseau, Système et Télécommunication. Développeur Flutter et Web avec une solide expérience pratique acquise lors de stages au sein de grandes entreprises multinationales des secteurs minier et télécoms.";

  // Expériences (Stages)
  static const List<StageExperience> stages = [
    StageExperience(
      company: "KIBALI GOLD MINE",
      role: "Stagiaire Télécoms & Réseaux Industriels",
      period: "Stage Professionnel",
      description:
          "Participation à la maintenance de l'infrastructure réseau sur le site minier, gestion des faisceaux hertziens, de la fibre optique et support des systèmes de télécommunication critiques.",
      logoText: "KGM",
    ),
    StageExperience(
      company: "Global Technology",
      role: "Stagiaire Administrateur Systèmes & Réseaux",
      period: "Stage Technique",
      description:
          "Configuration des équipements réseaux (routeurs, switches, points d'accès), gestion des serveurs d'entreprise et assistance technique aux utilisateurs.",
      logoText: "GT",
    ),
    StageExperience(
      company: "VODACOM",
      role: "Stagiaire Ingénierie Réseaux Mobiles & Télécoms",
      period: "Stage Académique & Pratique",
      description:
          "Immersion dans l'architecture GSM/3G/4G, surveillance des liens de transmission, optimisation de la couverture réseau et diagnostic des incidents du réseau d'accès.",
      logoText: "VOD",
    ),
    StageExperience(
      company: "AIRTEL",
      role: "Stagiaire Infrastructure & Systèmes Télécoms",
      period: "Stage en Entreprise",
      description:
          "Supervision des liaisons de transmission par faisceaux hertziens, configuration des liaisons IP et maintenance préventive des stations de base (BTS).",
      logoText: "AIR",
    ),
    StageExperience(
      company: "ORANGE",
      role: "Stagiaire Réseaux IP & Solutions Entreprises",
      period: "Stage de Spécialisation",
      description:
          "Déploiement des solutions de connectivité pour entreprises, configuration de VLANs, interconnexion de sites clients et protocoles de routage dynamique.",
      logoText: "ORA",
    ),
  ];

  // Projets
  static const List<ProjectItem> projects = [
    ProjectItem(
      title: "Application de Gestion d'une École",
      role: "Concepteur & Développeur Principal",
      description:
          "Développement d'une application complète et intuitive pour la gestion d'un établissement scolaire : gestion des inscriptions d'élèves, suivi des paiements, saisie et calcul automatique des bulletins de notes, gestion des enseignants et des horaires de cours.",
      technologies: ["Flutter", "Dart", "Firebase / SQLite", "UI/UX Material 3", "Web"],
    ),
  ];

  // Compétences techniques
  static const List<TechnicalSkill> technicalSkills = [
    TechnicalSkill(
      name: "Développeur FLUTTER",
      level: 0.90,
      category: "Développement Mobile",
      details: ["Dart", "Architecture MVVM / Provider", "Material 3", "API REST", "Cross-Platform Android & iOS"],
    ),
    TechnicalSkill(
      name: "Développement Web",
      level: 0.85,
      category: "Développement Web",
      details: ["HTML5", "CSS3", "JavaScript", "Frameworks Web", "Responsive Design", "Intégration d'APIs"],
    ),
    TechnicalSkill(
      name: "Réseau, Système & Télécom",
      level: 0.88,
      category: "Infrastructures & Télécommunications",
      details: [
        "Réseaux IP & Adressage IPv4/IPv6",
        "Routage & Commutation (Cisco, MikroTik)",
        "Administration Linux & Windows Server",
        "Télécoms Mobiles (GSM/4G/Faisceaux Hertziens)",
        "Fibre Optique & Sécurité Réseau",
      ],
    ),
  ];

  // Compétences linguistiques
  static const List<LanguageSkill> languages = [
    LanguageSkill(
      language: "Français",
      level: "Courant / Langue d'enseignement et professionnelle",
      proficiency: 0.95,
    ),
    LanguageSkill(
      language: "Lingala",
      level: "Langue maternelle / Excellente maîtrise",
      proficiency: 1.0,
    ),
    LanguageSkill(
      language: "Anglais",
      level: "Intermédiaire / Anglais technique et professionnel",
      proficiency: 0.75,
    ),
  ];

  // Centres d'intérêt
  static const List<HobbyItem> hobbies = [
    HobbyItem(
      name: "Boxe",
      description: "Discipline, maîtrise de soi, concentration et dépassement personnel.",
      iconCode: "sports_mma",
    ),
    HobbyItem(
      name: "Football",
      description: "Esprit d'équipe, stratégie tactique et persévérance sur le terrain.",
      iconCode: "sports_soccer",
    ),
    HobbyItem(
      name: "Volleyball",
      description: "Dynamisme collectif, communication rapide et agilité athlétique.",
      iconCode: "sports_volleyball",
    ),
    HobbyItem(
      name: "Les Recherches",
      description: "Veille constante sur l'Intelligence Artificielle, le Cloud et les réseaux télécoms du futur.",
      iconCode: "travel_explore",
    ),
    HobbyItem(
      name: "Lire / Lecture",
      description: "Livres scientifiques, ouvrages de développement personnel et innovations numériques.",
      iconCode: "menu_book",
    ),
  ];
}
