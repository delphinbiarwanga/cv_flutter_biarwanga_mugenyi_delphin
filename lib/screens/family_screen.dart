import 'package:flutter/material.dart';
import 'package:cv_flutter_biarwanga_mugenyi_delphin/models/family_member.dart';
import 'package:cv_flutter_biarwanga_mugenyi_delphin/services/url_launcher_service.dart';

class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});

  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  final List<FamilyMember> _allMembers = FamilyMember.getSampleFamily();
  String _selectedFilter = "Tous";
  bool _isGridView = false;

  List<FamilyMember> get _filteredMembers {
    if (_selectedFilter == "Tous") return _allMembers;
    if (_selectedFilter == "Père / Parents") {
      return _allMembers.where((m) => m.relation == "Père" || m.relation == "Mère").toList();
    }
    if (_selectedFilter == "Frères") {
      return _allMembers
          .where((m) => m.relation.contains("Frère"))
          .toList();
    }
    return _allMembers;
  }

  Widget _buildMemberImage(FamilyMember member, {required double width, required double height, double radius = 0}) {
    Widget imageWidget;
    if (member.isAsset) {
      imageWidget = Image.asset(
        member.imagePath,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: width,
          height: height,
          color: const Color(0xFF1E3A8A).withAlpha(30),
          child: const Icon(Icons.person, color: Color(0xFF1E3A8A), size: 32),
        ),
      );
    } else {
      imageWidget = Image.network(
        member.imagePath,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: width,
          height: height,
          color: const Color(0xFF1E3A8A).withAlpha(30),
          child: const Icon(Icons.person, color: Color(0xFF1E3A8A), size: 32),
        ),
      );
    }

    if (radius > 0) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: imageWidget,
      );
    }
    return ClipOval(child: imageWidget);
  }

  void _showMemberDetails(BuildContext context, FamilyMember member) {
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
                  _buildMemberImage(member, width: 80, height: 80, radius: 18),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
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
                            "Lien : ${member.relation}",
                            style: const TextStyle(
                              color: Color(0xFF0D9488),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          member.profession,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Description
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white10 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "À propos",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      member.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Détails complémentaires
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.location_on, color: Color(0xFF1E3A8A)),
                title: const Text("Résidence actuelle", style: TextStyle(fontSize: 13)),
                subtitle: Text(
                  member.location,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.phone, color: Color(0xFF0D9488)),
                title: const Text("Numéro de contact", style: TextStyle(fontSize: 13)),
                subtitle: Text(
                  member.phone,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.call, color: Color(0xFF0D9488)),
                  onPressed: () => UrlLauncherService.makePhoneCall(context, member.phone),
                ),
              ),
              const SizedBox(height: 16),

              // Bouton Fermer
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                ),
                child: const Text("Fermer"),
              ),
            ],
          ),
        );
      },
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
          // Bannière En-tête Famille
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
                        "CERCLE FAMILIAL",
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
                        "${_allMembers.length} membres présentés avec leurs vraies photos",
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

          // Filtres et Bascule d'Affichage (ListView / GridView)
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip("Tous"),
                      _buildFilterChip("Père / Parents"),
                      _buildFilterChip("Frères"),
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

          // Affichage (ListView ou GridView)
          _filteredMembers.isEmpty
              ? _buildEmptyState()
              : _isGridView
                  ? _buildGridView(isDark)
                  : _buildListView(isDark),

          const SizedBox(height: 20),
        ],
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
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final member = _filteredMembers[index];
        return Card(
          elevation: 2.5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: InkWell(
            onTap: () => _showMemberDetails(context, member),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children: [
                  // Photo avec bordure
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF0D9488),
                        width: 2.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(20),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: _buildMemberImage(member, width: 62, height: 62),
                  ),
                  const SizedBox(width: 14),

                  // Informations
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                member.name,
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
                                border: Border.all(
                                  color: const Color(0xFF1E3A8A).withAlpha(50),
                                ),
                              ),
                              child: Text(
                                member.relation,
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
                        Text(
                          member.profession,
                          style: TextStyle(
                            fontSize: 12.5,
                            color: isDark ? const Color(0xFF2DD4BF) : const Color(0xFF0D9488),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 13, color: Colors.grey.shade500),
                            const SizedBox(width: 4),
                            Text(
                              member.location,
                              style: TextStyle(
                                fontSize: 11.5,
                                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.chevron_right, color: Colors.grey),
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
          elevation: 2.5,
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
                      border: Border.all(
                        color: const Color(0xFF0D9488),
                        width: 2.5,
                      ),
                    ),
                    child: _buildMemberImage(member, width: 72, height: 72),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    member.name,
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
                      member.relation,
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    member.profession,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? const Color(0xFF2DD4BF) : const Color(0xFF0D9488),
                    ),
                    maxLines: 2,
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
          Text(
            "Aucun membre trouvé pour ce filtre.",
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
