import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cv_flutter_biarwanga_mugenyi_delphin/models/famille_membre.dart';
import 'package:cv_flutter_biarwanga_mugenyi_delphin/services/api_service.dart';

class FamilleMembreFormDialog extends StatefulWidget {
  final FamilleMembre? memberToEdit;

  const FamilleMembreFormDialog({
    super.key,
    this.memberToEdit,
  });

  @override
  State<FamilleMembreFormDialog> createState() => _FamilleMembreFormDialogState();
}

class _FamilleMembreFormDialogState extends State<FamilleMembreFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nomController;
  late TextEditingController _postnomController;
  late TextEditingController _prenomController;
  late TextEditingController _lieuNaissanceController;
  late TextEditingController _dateNaissanceController;
  late TextEditingController _parenteController;

  XFile? _selectedImage;
  bool _isSubmitting = false;
  String? _errorMessage;

  final ImagePicker _picker = ImagePicker();

  final List<String> _parenteSuggestions = [
    'Père',
    'Mère',
    'Grand Frère',
    'Petite Sœur',
    'Frère Cadet',
    'Frère',
    'Sœur',
    'Fils',
    'Fille',
    'Oncle',
    'Tante',
    'Cousin',
    'Cousine',
    'Grand-père',
    'Grand-mère',
  ];

  @override
  void initState() {
    super.initState();
    final m = widget.memberToEdit;
    _nomController = TextEditingController(text: m?.nom ?? '');
    _postnomController = TextEditingController(text: m?.postnom ?? '');
    _prenomController = TextEditingController(text: m?.prenom ?? '');
    _lieuNaissanceController = TextEditingController(text: m?.lieuNaissance ?? '');
    _dateNaissanceController = TextEditingController(text: m?.dateNaissance ?? '');
    _parenteController = TextEditingController(text: m?.parente ?? '');
  }

  @override
  void dispose() {
    _nomController.dispose();
    _postnomController.dispose();
    _prenomController.dispose();
    _lieuNaissanceController.dispose();
    _dateNaissanceController.dispose();
    _parenteController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image == null) return;

      // Vérification de la taille max (2 Mo max d'après l'API)
      final bytes = await image.readAsBytes();
      if (bytes.lengthInBytes > 2 * 1024 * 1024) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("L'image dépasse la taille maximale autorisée de 2 Mo."),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      setState(() {
        _selectedImage = image;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur lors de la sélection de l'image : $e"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    DateTime initial = DateTime(2000, 1, 1);

    if (_dateNaissanceController.text.trim().isNotEmpty) {
      try {
        final parsed = DateTime.parse(_dateNaissanceController.text.trim());
        final parsedDateOnly = DateTime(parsed.year, parsed.month, parsed.day);
        if (!parsedDateOnly.isAfter(today) && !parsedDateOnly.isBefore(DateTime(1900, 1, 1))) {
          initial = parsedDateOnly;
        }
      } catch (_) {}
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900, 1, 1),
      lastDate: today,
    );

    if (picked != null) {
      final y = picked.year.toString().padLeft(4, '0');
      final m = picked.month.toString().padLeft(2, '0');
      final d = picked.day.toString().padLeft(2, '0');
      setState(() {
        _dateNaissanceController.text = '$y-$m-$d';
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validation stricte du format de la date AAAA-MM-JJ
    final datePattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!datePattern.hasMatch(_dateNaissanceController.text.trim())) {
      setState(() {
        _errorMessage = "Format de date invalide. Utilisez AAAA-MM-JJ (ex: 1998-05-14).";
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      if (widget.memberToEdit == null) {
        // CRÉATION (POST /famille-membres)
        await ApiService.createFamilleMembre(
          nom: _nomController.text.trim(),
          postnom: _postnomController.text.trim(),
          prenom: _prenomController.text.trim(),
          lieuNaissance: _lieuNaissanceController.text.trim(),
          dateNaissance: _dateNaissanceController.text.trim(),
          parente: _parenteController.text.trim(),
          imageFile: _selectedImage,
        );
      } else {
        // MODIFICATION
        // Sans nouvelle image -> PUT JSON
        // Avec nouvelle image -> POST Multipart
        await ApiService.updateFamilleMembre(
          id: widget.memberToEdit!.id,
          nom: _nomController.text.trim(),
          postnom: _postnomController.text.trim(),
          prenom: _prenomController.text.trim(),
          lieuNaissance: _lieuNaissanceController.text.trim(),
          dateNaissance: _dateNaissanceController.text.trim(),
          parente: _parenteController.text.trim(),
          newImageFile: _selectedImage,
        );
      }

      if (!mounted) return;
      Navigator.of(context).pop(true); // Succès
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
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.memberToEdit != null;
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 680),
        child: Column(
          children: [
            // En-tête de la boîte de dialogue
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: Color(0xFF1E3A8A),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Icon(
                    isEdit ? Icons.edit_note_rounded : Icons.person_add_alt_1_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isEdit ? "Modifier le Membre" : "Ajouter un Membre de Famille",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ],
              ),
            ),

            // Corps du formulaire déroulant
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
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
                                  style: TextStyle(color: Colors.red.shade800, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Sélecteur d'image & Prévisualisation
                      Center(
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: 96,
                                  height: 96,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: const Color(0xFF0D9488), width: 2.5),
                                    color: Colors.grey.shade100,
                                  ),
                                  child: ClipOval(
                                    child: _buildImagePreview(),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF1E3A8A),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton.icon(
                                  onPressed: () => _pickImage(ImageSource.gallery),
                                  icon: const Icon(Icons.photo_library_outlined, size: 18),
                                  label: const Text("Galerie", style: TextStyle(fontSize: 12)),
                                ),
                                const SizedBox(width: 8),
                                TextButton.icon(
                                  onPressed: () => _pickImage(ImageSource.camera),
                                  icon: const Icon(Icons.photo_camera_outlined, size: 18),
                                  label: const Text("Caméra", style: TextStyle(fontSize: 12)),
                                ),
                                if (_selectedImage != null) ...[
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                    tooltip: "Retirer la nouvelle image",
                                    onPressed: () {
                                      setState(() {
                                        _selectedImage = null;
                                      });
                                    },
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Champ Nom (max 50)
                      TextFormField(
                        controller: _nomController,
                        maxLength: 50,
                        textCapitalization: TextCapitalization.characters,
                        decoration: const InputDecoration(
                          labelText: "Nom *",
                          hintText: "Ex: BIARWANGA",
                          prefixIcon: Icon(Icons.badge_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Le nom est obligatoire";
                          }
                          if (value.trim().length > 50) {
                            return "50 caractères maximum";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Champ Postnom (max 50)
                      TextFormField(
                        controller: _postnomController,
                        maxLength: 50,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: "Postnom *",
                          hintText: "Ex: MUGENYI",
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Le postnom est obligatoire";
                          }
                          if (value.trim().length > 50) {
                            return "50 caractères maximum";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Champ Prénom (max 50)
                      TextFormField(
                        controller: _prenomController,
                        maxLength: 50,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: "Prénom *",
                          hintText: "Ex: Delphin",
                          prefixIcon: Icon(Icons.person_outline_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Le prénom est obligatoire";
                          }
                          if (value.trim().length > 50) {
                            return "50 caractères maximum";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Champ Lieu de naissance (max 100)
                      TextFormField(
                        controller: _lieuNaissanceController,
                        maxLength: 100,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: "Lieu de naissance *",
                          hintText: "Ex: Kinshasa",
                          prefixIcon: Icon(Icons.location_city_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Le lieu de naissance est obligatoire";
                          }
                          if (value.trim().length > 100) {
                            return "100 caractères maximum";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Champ Date de naissance (format strict AAAA-MM-JJ)
                      TextFormField(
                        controller: _dateNaissanceController,
                        readOnly: true,
                        onTap: _selectDate,
                        decoration: InputDecoration(
                          labelText: "Date de naissance (AAAA-MM-JJ) *",
                          hintText: "Sélectionnez la date",
                          prefixIcon: const Icon(Icons.calendar_today_outlined),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.date_range_rounded),
                            onPressed: _selectDate,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "La date de naissance est obligatoire";
                          }
                          if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value.trim())) {
                            return "Format strict requis : AAAA-MM-JJ";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Champ Lien de parenté (max 50) avec suggestions
                      TextFormField(
                        controller: _parenteController,
                        maxLength: 50,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: "Lien de parenté *",
                          hintText: "Ex: Père, Mère, Frère, Sœur...",
                          prefixIcon: Icon(Icons.family_restroom_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Le lien de parenté est obligatoire";
                          }
                          if (value.trim().length > 50) {
                            return "50 caractères maximum";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 4),

                      // Puces de suggestions rapides pour la parenté
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: _parenteSuggestions.map((suggestion) {
                          return ActionChip(
                            label: Text(suggestion, style: const TextStyle(fontSize: 11)),
                            backgroundColor: theme.colorScheme.surfaceContainerHighest,
                            onPressed: () {
                              setState(() {
                                _parenteController.text = suggestion;
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),

            // Barre d'actions en bas
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(false),
                    child: const Text("Annuler"),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Text(isEdit ? "Enregistrer les modifications" : "Ajouter le membre"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    if (_selectedImage != null) {
      return Image.file(
        File(_selectedImage!.path),
        width: 96,
        height: 96,
        fit: BoxFit.cover,
      );
    }

    final existingUrl = widget.memberToEdit?.resolvedImageUrl;
    if (existingUrl != null && existingUrl.isNotEmpty) {
      return Image.network(
        existingUrl,
        width: 96,
        height: 96,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.person,
          size: 48,
          color: Color(0xFF1E3A8A),
        ),
      );
    }

    return const Icon(
      Icons.person,
      size: 50,
      color: Color(0xFF94A3B8),
    );
  }
}
