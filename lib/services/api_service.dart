import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:cv_flutter_biarwanga_mugenyi_delphin/config/api_config.dart';
import 'package:cv_flutter_biarwanga_mugenyi_delphin/models/user_account.dart';
import 'package:cv_flutter_biarwanga_mugenyi_delphin/models/famille_membre.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  ApiException(this.message, {this.statusCode, this.errors});

  /// Retourne un texte détaillé des erreurs pour affichage utilisateur
  String get fullErrorMessage {
    if (errors != null && errors!.isNotEmpty) {
      final details = errors!.entries.map((e) => '• ${e.value}').join('\n');
      return '$message\n$details';
    }
    return message;
  }

  @override
  String toString() => fullErrorMessage;
}

class ApiService {
  static const Duration _timeout = Duration(seconds: 15);

  static Map<String, String> get _jsonHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // ==========================================
  // A. AUTHENTIFICATION (/accounts)
  // ==========================================

  /// Inscription d'un nouvel utilisateur
  /// POST /accounts/register
  static Future<UserAccount> register({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse(ApiConfig.registerEndpoint);

    try {
      final response = await http
          .post(
            uri,
            headers: _jsonHeaders,
            body: jsonEncode({
              'email': email.trim(),
              'password': password,
            }),
          )
          .timeout(_timeout);

      final Map<String, dynamic> jsonBody = _parseResponse(response);

      if (response.statusCode == 201 && jsonBody['success'] == true) {
        return UserAccount.fromJson(jsonBody['data'] as Map<String, dynamic>);
      }

      throw _handleError(response.statusCode, jsonBody);
    } on SocketException catch (_) {
      throw ApiException(
        "Impossible de contacter le serveur XAMPP.\nVérifiez qu'Apache est démarré et que la commande 'adb reverse tcp:8080 tcp:80' est active.",
      );
    } on http.ClientException catch (e) {
      throw ApiException("Erreur de connexion : ${e.message}");
    }
  }

  /// Connexion utilisateur
  /// POST /accounts/login
  static Future<UserAccount> login({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse(ApiConfig.loginEndpoint);

    try {
      final response = await http
          .post(
            uri,
            headers: _jsonHeaders,
            body: jsonEncode({
              'email': email.trim(),
              'password': password,
            }),
          )
          .timeout(_timeout);

      final Map<String, dynamic> jsonBody = _parseResponse(response);

      if (response.statusCode == 200 && jsonBody['success'] == true) {
        return UserAccount.fromJson(jsonBody['data'] as Map<String, dynamic>);
      }

      throw _handleError(response.statusCode, jsonBody);
    } on SocketException catch (_) {
      throw ApiException(
        "Serveur XAMPP inaccessible.\nVérifiez qu'Apache est allumé et que le pont USB 'adb reverse tcp:8080 tcp:80' est actif.",
      );
    } on http.ClientException catch (e) {
      throw ApiException("Erreur de connexion : ${e.message}");
    }
  }

  // ==========================================
  // B. MEMBRES DE FAMILLE (/famille-membres)
  // ==========================================

  /// Récupérer la liste de tous les membres de la famille
  /// GET /famille-membres
  static Future<List<FamilleMembre>> getFamilleMembres() async {
    final uri = Uri.parse(ApiConfig.familleMembresEndpoint);

    try {
      final response = await http
          .get(uri, headers: {'Accept': 'application/json'})
          .timeout(_timeout);

      final Map<String, dynamic> jsonBody = _parseResponse(response);

      if (response.statusCode == 200 && jsonBody['success'] == true) {
        final List<dynamic> dataList = (jsonBody['data'] as List<dynamic>?) ?? [];
        return dataList
            .map((item) => FamilleMembre.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      throw _handleError(response.statusCode, jsonBody);
    } on SocketException catch (_) {
      throw ApiException("Impossible de joindre le serveur XAMPP pour charger la famille.");
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException("Erreur lors de la récupération des membres : $e");
    }
  }

  /// Récupérer les détails d'un membre par son identifiant
  /// GET /famille-membres/{id}
  static Future<FamilleMembre> getFamilleMembreById(int id) async {
    final uri = Uri.parse('${ApiConfig.familleMembresEndpoint}/$id');

    try {
      final response = await http
          .get(uri, headers: {'Accept': 'application/json'})
          .timeout(_timeout);

      final Map<String, dynamic> jsonBody = _parseResponse(response);

      if (response.statusCode == 200 && jsonBody['success'] == true) {
        return FamilleMembre.fromJson(jsonBody['data'] as Map<String, dynamic>);
      }

      throw _handleError(response.statusCode, jsonBody);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException("Impossible de charger le membre #$id : $e");
    }
  }

  /// Création d'un membre de famille
  /// POST /famille-membres
  /// - Si image présente -> multipart/form-data
  /// - Si pas d'image -> application/json
  static Future<FamilleMembre> createFamilleMembre({
    required String nom,
    required String postnom,
    required String prenom,
    required String lieuNaissance,
    required String dateNaissance,
    required String parente,
    XFile? imageFile,
  }) async {
    final uri = Uri.parse(ApiConfig.familleMembresEndpoint);

    final fields = {
      'nom': nom.trim(),
      'postnom': postnom.trim(),
      'prenom': prenom.trim(),
      'lieu_naissance': lieuNaissance.trim(),
      'date_naissance': dateNaissance.trim(),
      'parente': parente.trim(),
    };

    try {
      http.Response response;

      if (imageFile != null) {
        // Envoi en multipart/form-data
        final request = http.MultipartRequest('POST', uri);
        request.headers['Accept'] = 'application/json';
        request.fields.addAll(fields);

        final bytes = await imageFile.readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            bytes,
            filename: imageFile.name,
          ),
        );

        final streamed = await request.send().timeout(_timeout);
        response = await http.Response.fromStream(streamed);
      } else {
        // Envoi en application/json
        response = await http
            .post(
              uri,
              headers: _jsonHeaders,
              body: jsonEncode(fields),
            )
            .timeout(_timeout);
      }

      final Map<String, dynamic> jsonBody = _parseResponse(response);

      if ((response.statusCode == 201 || response.statusCode == 200) &&
          jsonBody['success'] == true) {
        return FamilleMembre.fromJson(jsonBody['data'] as Map<String, dynamic>);
      }

      throw _handleError(response.statusCode, jsonBody);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException("Erreur lors de la création du membre : $e");
    }
  }

  /// Modification d'un membre de famille
  /// Règle critique API :
  /// - Sans changer l'image -> PUT /famille-membres/{id} en application/json
  /// - Avec nouvelle image -> POST /famille-membres/{id} en multipart/form-data
  static Future<FamilleMembre> updateFamilleMembre({
    required int id,
    required String nom,
    required String postnom,
    required String prenom,
    required String lieuNaissance,
    required String dateNaissance,
    required String parente,
    XFile? newImageFile,
  }) async {
    final fields = {
      'nom': nom.trim(),
      'postnom': postnom.trim(),
      'prenom': prenom.trim(),
      'lieu_naissance': lieuNaissance.trim(),
      'date_naissance': dateNaissance.trim(),
      'parente': parente.trim(),
    };

    try {
      http.Response response;

      if (newImageFile != null) {
        // Avec image : POST /famille-membres/{id} en multipart/form-data
        final uri = Uri.parse('${ApiConfig.familleMembresEndpoint}/$id');
        final request = http.MultipartRequest('POST', uri);
        request.headers['Accept'] = 'application/json';
        request.fields.addAll(fields);

        final bytes = await newImageFile.readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            bytes,
            filename: newImageFile.name,
          ),
        );

        final streamed = await request.send().timeout(_timeout);
        response = await http.Response.fromStream(streamed);
      } else {
        // Sans image : PUT /famille-membres/{id} en application/json
        final uri = Uri.parse('${ApiConfig.familleMembresEndpoint}/$id');
        response = await http
            .put(
              uri,
              headers: _jsonHeaders,
              body: jsonEncode(fields),
            )
            .timeout(_timeout);
      }

      final Map<String, dynamic> jsonBody = _parseResponse(response);

      if (response.statusCode == 200 && jsonBody['success'] == true) {
        return FamilleMembre.fromJson(jsonBody['data'] as Map<String, dynamic>);
      }

      throw _handleError(response.statusCode, jsonBody);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException("Erreur lors de la modification du membre : $e");
    }
  }

  /// Suppression d'un membre de famille
  /// DELETE /famille-membres/{id}
  static Future<bool> deleteFamilleMembre(int id) async {
    final uri = Uri.parse('${ApiConfig.familleMembresEndpoint}/$id');

    try {
      final response = await http
          .delete(uri, headers: {'Accept': 'application/json'})
          .timeout(_timeout);

      final Map<String, dynamic> jsonBody = _parseResponse(response);

      if (response.statusCode == 200 && jsonBody['success'] == true) {
        return true;
      }

      throw _handleError(response.statusCode, jsonBody);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException("Erreur lors de la suppression du membre : $e");
    }
  }

  // ==========================================
  // HELPERS PRIVÉS
  // ==========================================

  static Map<String, dynamic> _parseResponse(http.Response response) {
    try {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      return {
        'success': false,
        'message': 'Réponse serveur inattendue (code ${response.statusCode})',
      };
    }
  }

  static ApiException _handleError(int statusCode, Map<String, dynamic> jsonBody) {
    final String message = jsonBody['message']?.toString() ??
        (statusCode == 401
            ? "Identifiants incorrects."
            : statusCode == 409
                ? "Cet enregistrement existe déjà."
                : statusCode == 422
                    ? "Données de formulaire invalides."
                    : "Une erreur est survenue (code $statusCode).");

    final Map<String, dynamic>? errors =
        jsonBody['errors'] is Map<String, dynamic> ? jsonBody['errors'] as Map<String, dynamic> : null;

    return ApiException(message, statusCode: statusCode, errors: errors);
  }
}
