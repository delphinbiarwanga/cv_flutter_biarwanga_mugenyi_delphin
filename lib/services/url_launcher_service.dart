import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
  /// Ouvre une URL web externe
  static Future<void> openWebUrl(BuildContext context, String urlString) async {
    final Uri uri = Uri.parse(urlString);
    try {
      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        _showErrorSnackBar(context, "Impossible d'ouvrir le lien : $urlString");
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackBar(context, "Erreur lors de l'ouverture du lien.");
      }
    }
  }

  /// Lance un appel téléphonique
  static Future<void> makePhoneCall(BuildContext context, String phoneNumber) async {
    // Nettoyer le numéro pour l'URI
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'\s+'), '');
    final Uri uri = Uri(scheme: 'tel', path: cleanNumber);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        final bool launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (!launched && context.mounted) {
          copyToClipboard(context, phoneNumber, "Numéro de téléphone copié !");
        }
      }
    } catch (e) {
      if (context.mounted) {
        copyToClipboard(context, phoneNumber, "Numéro copié dans le presse-papier !");
      }
    }
  }

  /// Ouvre le client de messagerie pour envoyer un email
  static Future<void> sendEmail(
    BuildContext context, {
    required String email,
    String subject = "Contact depuis l'application CV Flutter",
    String body = "Bonjour Delphin,\n\n",
  }) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
    );

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        final bool launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (!launched && context.mounted) {
          copyToClipboard(context, email, "Adresse e-mail copiée !");
        }
      }
    } catch (e) {
      if (context.mounted) {
        copyToClipboard(context, email, "Adresse e-mail copiée dans le presse-papier !");
      }
    }
  }

  /// Ouvre une discussion WhatsApp
  static Future<void> openWhatsApp(
    BuildContext context, {
    required String phoneWithCountryCode,
    String message = "Bonjour Delphin, j'ai consulté votre CV Flutter !",
  }) async {
    final cleanPhone = phoneWithCountryCode.replaceAll(RegExp(r'[^0-9]'), '');
    final url = "https://wa.me/$cleanPhone?text=${Uri.encodeComponent(message)}";
    await openWebUrl(context, url);
  }

  /// Copie du texte dans le presse-papier avec confirmation Snackbar
  static void copyToClipboard(BuildContext context, String text, [String? message]) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message ?? "Texte copié dans le presse-papier",
                style: const TextStyle(fontWeight: FontWeight.w500),
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

  static void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
