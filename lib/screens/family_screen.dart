import 'package:flutter/material.dart';
import 'package:cv_flutter_biarwanga_mugenyi_delphin/models/famille_membre.dart';
import 'package:cv_flutter_biarwanga_mugenyi_delphin/services/api_service.dart';
import 'package:cv_flutter_biarwanga_mugenyi_delphin/widgets/famille_membre_form_dialog.dart';

class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});

  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  List<FamilleMembre> _allMembers = [];
  bool _isLoading = true;
  String? _errorMessage;

  String _selectedFilter = "Tous";
  bool _isGridView = false;

  @override
  void initState() {
    super.initState();
    _fetchMembers();
  }

  Future<void> _fetchMembers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final list = await ApiService.getFamilleMembres();
      if (!mounted) return;
      setState(() {
        _allMembers = list;
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
        _errorMessage = "Impossible de contacter l'API XAMPP : $e";
        _isLoading = false;
      });
    }
  }

  List<FamilleMembre> get _filteredMembers {
    if (_selectedFilter == "Tous") return _allMembers;
    if (_selectedFilter == "Parents") {
      return _allMembers
          .where((m) =>
              m.parente.toLowerCase().contains("père") ||
              m.parente.toLowerCase().contains("mere") ||
              m.parente.toLowerCase().contains("mère") ||
              m.parente.toLowerCase().contains("parent"))
          .toList();
    }
    if (_selectedFilter == "Fratrie") {
      return _allMembers
          .where((m) =>
              m.parente.toLowerCase().contains("frère") ||
              m.parente.toLowerCase().contains("frere") ||
              m.parente.toLowerCase().contains("sœur") ||
              m.parente.toLowerCase().contains("soeur"))
          .toList();
    }
    return _allMembers;
  }

  // --- ACTIONS CRUD ---

  Future<void> _openAddDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const FamilleMembreFormDialog(),
    );

    if (result == true) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Membre de famille ajouté avec succès !"),
          backgroundColor: Color(0xFF0D9488),
          behavior: SnackBarBehavior.floating,
        ),
      );
      _fetchMembers();
    }
  }

  Future<void> _openEditDialog(FamilleMembre member) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => FamilleMembreFormDialog(memberToEdit: member),
    );

    if (result == true) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Membre « ${member.nomComplet} » mis à jour !"),
          backgroundColor: const Color(0xFF0D9488),
          behavior: SnackBarBehavior.floating,
        ),
      );
      _fetchMembers();
    }
  }

  Future<void> _confirmDelete(FamilleMembre member) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
            SizedBox(width: 10),
            Text("Confirmation"),
          ],
        ),
        content: Text(
          "Voulez-vous vraiment supprimer définitivement « ${member.nomComplet} » de la base de données ?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Supprimer"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await ApiService.deleteFamilleMembre(member.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("« ${member.nomComplet} » a été supprimé."),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      _fetchMembers();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur lors de la suppression : $e"),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showMemberDetails(BuildContext context, FamilleMembre member) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Poignée de glissement
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Photo et infos principales
              Row(
                children: [
                  _buildAvatar(member, size: 76),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member.nomComplet,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0D9488).withAlpha(20),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Lien : ${member.parente}",
                            style: const TextStyle(
                              color: Color(0xFF0D9488),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Détails complets depuis la BDD
              _buildDetailTile(
                icon: Icons.calendar_today_rounded,
                title: "Date de naissance",
                value: member.dateNaissance,
                color: const Color(0xFF1E3A8A),
              ),
              _buildDetailTile(
                icon: Icons.location_city_rounded,
                title: "Lieu de naissance",
                value: member.lieuNaissance,
                color: const Color(0xFF0D9488),
              ),
              _buildDetailTile(
                icon: Icons.tag_rounded,
                title: "Identifiant BDD",
                value: "#${member.id}",
                color: Colors.grey,
              ),
              const SizedBox(height: 20),

              // Boutons d'action : Modifier & Supprimer
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: const Text("Modifier"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _openEditDialog(member);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: const Text("Supprimer"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _confirmDelete(member);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildDetailTile({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              Text(
                value,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(FamilleMembre member, {required double size}) {
    final imageUrl = member.resolvedImageUrl;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          imageUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: size,
            height: size,
            color: const Color(0xFF1E3A8A).withAlpha(20),
            child: Icon(Icons.person, color: const Color(0xFF1E3A8A), size: size * 0.55),
          ),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: size,
              height: size,
              color: Colors.grey.shade100,
              child: Center(
                child: SizedBox(
                  width: size * 0.4,
                  height: size * 0.4,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          },
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF1E3A8A).withAlpha(20),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person,
        color: const Color(0xFF1E3A8A),
        size: size * 0.55,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddDialog,
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add_rounded),
        label: const Text("Ajouter"),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchMembers,
        color: const Color(0xFF1E3A8A),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Bannière En-tête
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                        : [const Color(0xFF0D9488), const Color(0xFF0F766E)],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0D9488).withAlpha(50),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(30),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.diversity_1_rounded, color: Colors.white, size: 32),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "BASE DE DONNÉES EN DIRECT",
                            style: TextStyle(
                              color: Color(0xFF99F6E4),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "Membres de ma Famille",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "${_allMembers.length} membre(s) synchronisé(s) avec l'API",
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
              const SizedBox(height: 16),

              // Filtres et Bascule Vue Liste / Grille
              Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip("Tous"),
                          _buildFilterChip("Parents"),
                          _buildFilterChip("Fratrie"),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(_isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded),
                    tooltip: _isGridView ? "Vue Liste" : "Vue Grille",
                    onPressed: () {
                      setState(() {
                        _isGridView = !_isGridView;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Contenu principal (Chargement, Erreur ou Liste)
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.0),
                  child: Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(color: Color(0xFF1E3A8A)),
                        SizedBox(height: 14),
                        Text("Chargement des membres depuis l'API..."),
                      ],
                    ),
                  ),
                )
              else if (_errorMessage != null)
                _buildErrorState()
              else if (_filteredMembers.isEmpty)
                _buildEmptyState()
              else if (_isGridView)
                _buildGridView(isDark)
              else
                _buildListView(isDark),

              const SizedBox(height: 80), // Espace pour le FAB
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = label;
          });
        },
        selectedColor: const Color(0xFF1E3A8A).withAlpha(30),
        checkmarkColor: const Color(0xFF1E3A8A),
        labelStyle: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected ? const Color(0xFF1E3A8A) : Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildListView(bool isDark) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredMembers.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final member = _filteredMembers[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: InkWell(
            onTap: () => _showMemberDetails(context, member),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF0D9488), width: 2),
                    ),
                    child: _buildAvatar(member, size: 58),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                member.nomComplet,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E3A8A).withAlpha(15),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFF1E3A8A).withAlpha(40)),
                              ),
                              child: Text(
                                member.parente,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E3A8A),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined, size: 14, color: Colors.grey.shade500),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                "${member.lieuNaissance} • Née le ${member.dateNaissance}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.grey),
                    onSelected: (val) {
                      if (val == 'edit') _openEditDialog(member);
                      if (val == 'delete') _confirmDelete(member);
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined, size: 18, color: Color(0xFF1E3A8A)),
                            SizedBox(width: 8),
                            Text("Modifier"),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                            SizedBox(width: 8),
                            Text("Supprimer", style: TextStyle(color: Colors.redAccent)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridView(bool isDark) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredMembers.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        final member = _filteredMembers[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: InkWell(
            onTap: () => _showMemberDetails(context, member),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF0D9488), width: 2),
                    ),
                    child: _buildAvatar(member, size: 68),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    member.nomComplet,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E3A8A).withAlpha(20),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      member.parente,
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    member.lieuNaissance,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(Icons.people_outline, size: 50, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          const Text(
            "Aucun membre de famille trouvé.",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            "Appuyez sur le bouton « Ajouter » pour enregistrer un premier membre dans la base de données.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _openAddDialog,
            icon: const Icon(Icons.add),
            label: const Text("Ajouter un membre"),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E3A8A)),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Icon(Icons.cloud_off_rounded, size: 48, color: Colors.redAccent),
          const SizedBox(height: 12),
          const Text(
            "Impossible de joindre l'API",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 6),
          Text(
            _errorMessage ?? "Erreur réseau inconnue.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _fetchMembers,
            icon: const Icon(Icons.refresh),
            label: const Text("Réessayer"),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E3A8A)),
          ),
        ],
      ),
    );
  }
}
