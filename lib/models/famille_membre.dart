import 'package:cv_flutter_biarwanga_mugenyi_delphin/config/api_config.dart';

class FamilleMembre {
  final int id;
  final String nom;
  final String postnom;
  final String prenom;
  final String lieuNaissance;
  final String dateNaissance;
  final String parente;
  final String? imageUrl;
  final String? createdAt;

  const FamilleMembre({
    required this.id,
    required this.nom,
    required this.postnom,
    required this.prenom,
    required this.lieuNaissance,
    required this.dateNaissance,
    required this.parente,
    this.imageUrl,
    this.createdAt,
  });

  /// Nom complet formaté : NOM Postnom Prénom
  String get nomComplet {
    return '$nom $postnom $prenom'.trim();
  }

  /// URL de l'image prête à être chargée sur le téléphone physique
  String? get resolvedImageUrl {
    return ApiConfig.resolveImageUrl(imageUrl);
  }

  factory FamilleMembre.fromJson(Map<String, dynamic> json) {
    return FamilleMembre(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) ?? 0 : 0,
      nom: json['nom']?.toString() ?? '',
      postnom: json['postnom']?.toString() ?? '',
      prenom: json['prenom']?.toString() ?? '',
      lieuNaissance: json['lieu_naissance']?.toString() ?? '',
      dateNaissance: json['date_naissance']?.toString() ?? '',
      parente: json['parente']?.toString() ?? '',
      imageUrl: (json['image_url'] ?? json['image'])?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'postnom': postnom,
      'prenom': prenom,
      'lieu_naissance': lieuNaissance,
      'date_naissance': dateNaissance,
      'parente': parente,
      if (imageUrl != null) 'image_url': imageUrl,
    };
  }

  /// Retourne la map pour les requêtes POST/PUT vers l'API
  Map<String, String> toApiFields() {
    return {
      'nom': nom.trim(),
      'postnom': postnom.trim(),
      'prenom': prenom.trim(),
      'lieu_naissance': lieuNaissance.trim(),
      'date_naissance': dateNaissance.trim(),
      'parente': parente.trim(),
    };
  }
}
