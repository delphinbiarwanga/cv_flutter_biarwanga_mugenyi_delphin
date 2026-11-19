import 'package:flutter/material.dart';
import 'package:cv_flutter_biarwanga_mugenyi_delphin/models/cv_data.dart';
import 'package:cv_flutter_biarwanga_mugenyi_delphin/services/url_launcher_service.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _nameController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _sendDirectEmail() {
    final senderName = _nameController.text.trim();
    final subject = _subjectController.text.trim().isEmpty
        ? "Contact professionnel via Application Flutter"
        : _subjectController.text.trim();
    final messageBody = _messageController.text.trim().isEmpty
        ? "Bonjour Delphin,\n\nJe vous contacte suite à la consultation de votre CV Flutter."
        : "Bonjour Delphin,\n\n${_messageController.text.trim()}\n\nCordialement,\n$senderName";

    UrlLauncherService.sendEmail(
      context,
      email: CVData.email,
      subject: subject,
      body: messageBody,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. BANNIÈRE EN-TÊTE CONTACT
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                    : [const Color(0xFF1E3A8A), const Color(0xFF0D9488)],
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
                // Mini photo
                Container(
                  padding: const EdgeInsets.all(2.5),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      CVData.profileImage,
                      width: 68,
                      height: 68,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 68,
                        height: 68,
                        color: Colors.white24,
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "DISPONIBLE POUR CONTACT",
                        style: TextStyle(
                          color: Color(0xFF2DD4BF),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        "Restons en Contact",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "Opportunités, projets Flutter/Web & réseaux télécoms",
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
          const SizedBox(height: 18),

          // Note informative sur la cliquabilité
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF0D9488).withAlpha(15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF0D9488).withAlpha(40)),
            ),
            child: const Row(
              children: [
                Icon(Icons.touch_app_rounded, color: Color(0xFF0D9488), size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Touchez une carte ci-dessous pour lancer un appel, écrire un email ou visiter un lien.",
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF0D9488),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 2. LISTE DES CONTACTS CLIQUABLES

          // A. Téléphone
          _buildClickableContactCard(
            context,
            icon: Icons.phone_in_talk_rounded,
            iconColor: const Color(0xFF059669),
            title: "Téléphone Mobile",
            value: CVData.phone,
            subtitle: "Appel direct ou SMS (+243 818 621 552)",
            actionLabel: "Appeler",
            onTap: () => UrlLauncherService.makePhoneCall(context, CVData.phone),
            onCopy: () => UrlLauncherService.copyToClipboard(
              context,
              CVData.phone,
              "Numéro de téléphone copié !",
            ),
          ),
          const SizedBox(height: 10),

          // B. Email
          _buildClickableContactCard(
            context,
            icon: Icons.alternate_email_rounded,
            iconColor: const Color(0xFFDC2626),
            title: "Adresse E-mail",
            value: CVData.email,
            subtitle: "Cliquez pour rédiger un message",
            actionLabel: "Écrire",
            onTap: () => UrlLauncherService.sendEmail(context, email: CVData.email),
            onCopy: () => UrlLauncherService.copyToClipboard(
              context,
              CVData.email,
              "Adresse e-mail copiée !",
            ),
          ),
          const SizedBox(height: 10),

          // C. WhatsApp
          _buildClickableContactCard(
            context,
            icon: Icons.chat_rounded,
            iconColor: const Color(0xFF25D366),
            title: "WhatsApp Direct",
            value: "+243 818 621 552",
            subtitle: "Discussion instantanée sur WhatsApp",
            actionLabel: "Discuter",
            onTap: () => UrlLauncherService.openWhatsApp(
              context,
              phoneWithCountryCode: CVData.phoneInternational,
            ),
            onCopy: () => UrlLauncherService.copyToClipboard(
              context,
              CVData.phoneInternational,
              "Numéro WhatsApp copié !",
            ),
          ),
          const SizedBox(height: 10),

          // D. LinkedIn
          _buildClickableContactCard(
            context,
            icon: Icons.business_center_rounded,
            iconColor: const Color(0xFF0077B5),
            title: "Profil LinkedIn",
            value: "BIARWANGA MUGENYI DELPHIN",
            subtitle: "Consulter mon réseau et mon parcours professionnel",
            actionLabel: "Consulter",
            onTap: () => UrlLauncherService.openWebUrl(context, CVData.linkedInUrl),
            onCopy: () => UrlLauncherService.copyToClipboard(
              context,
              CVData.linkedInUrl,
              "Lien LinkedIn copié !",
            ),
          ),
          const SizedBox(height: 10),

          // E. GitHub
          _buildClickableContactCard(
            context,
            icon: Icons.code_rounded,
            iconColor: isDark ? Colors.white : const Color(0xFF24292E),
            title: "Dépôts GitHub",
            value: "github.com/delphinbiarwanga",
            subtitle: "Voir mes projets de code Flutter, Dart et Web",
            actionLabel: "Explorer",
            onTap: () => UrlLauncherService.openWebUrl(context, CVData.githubUrl),
            onCopy: () => UrlLauncherService.copyToClipboard(
              context,
              CVData.githubUrl,
              "Lien GitHub copié !",
            ),
          ),
          const SizedBox(height: 24),

          // 3. FORMULAIRE D'ENVOI RAPIDE D'EMAIL
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E3A8A).withAlpha(20),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.send_rounded, color: Color(0xFF1E3A8A), size: 20),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Envoyer un message direct",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Ce formulaire pré-remplit votre client email pour m'écrire instantanément.",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Votre Nom / Entreprise",
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: _subjectController,
                    decoration: InputDecoration(
                      labelText: "Sujet du message",
                      prefixIcon: const Icon(Icons.subject_rounded),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: _messageController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Votre Message",
                      alignLabelWithHint: true,
                      prefixIcon: const Icon(Icons.message_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  ElevatedButton.icon(
                    onPressed: _sendDirectEmail,
                    icon: const Icon(Icons.email_outlined),
                    label: const Text("Envoyer le message à Delphin"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 4. LOCALISATION
          Card(
            elevation: 1.5,
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D9488).withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.location_on, color: Color(0xFF0D9488)),
              ),
              title: const Text("Localisation Géographique", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              subtitle: Text(CVData.location, style: const TextStyle(fontSize: 13)),
              trailing: IconButton(
                icon: const Icon(Icons.map_outlined, color: Color(0xFF1E3A8A)),
                tooltip: "Copier la localisation",
                onPressed: () => UrlLauncherService.copyToClipboard(
                  context,
                  CVData.location,
                  "Localisation copiée !",
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildClickableContactCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String subtitle,
    required String actionLabel,
    required VoidCallback onTap,
    required VoidCallback onCopy,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: iconColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.copy_rounded, size: 20),
                    tooltip: "Copier",
                    onPressed: onCopy,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E3A8A).withAlpha(15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      actionLabel,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
