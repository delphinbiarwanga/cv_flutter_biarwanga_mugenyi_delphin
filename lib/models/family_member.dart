class FamilyMember {
  final String id;
  final String name;
  final String relation;
  final String profession;
  final String imagePath;
  final bool isAsset;
  final String description;
  final String location;
  final String phone;

  const FamilyMember({
    required this.id,
    required this.name,
    required this.relation,
    required this.profession,
    required this.imagePath,
    this.isAsset = true,
    required this.description,
    required this.location,
    required this.phone,
  });

  static List<FamilyMember> getSampleFamily() {
    return const [
      FamilyMember(
        id: '1',
        name: 'Jean-Paul BIARWANGA',
        relation: 'Père',
        profession: 'Ingénieur & Cadre Technique',
        imagePath: 'assets/images/family_3.jpg',
        isAsset: true,
        description:
            'Pilier de la famille, passionné par les projets d\'ingénierie et la transmission des valeurs de rigueur, de travail et d\'intégrité.',
        location: 'Kinshasa, RDC',
        phone: '+243 810 001 001',
      ),
      FamilyMember(
        id: '2',
        name: 'Christian MUGENYI',
        relation: 'Grand Frère',
        profession: 'Architecte Logiciel & Ingénieur Cloud',
        imagePath: 'assets/images/family_2.jpg',
        isAsset: true,
        description:
            'Mentor technologique et aîné bienveillant, toujours de bon conseil dans le domaine du développement et de la gestion de projets.',
        location: 'Lubumbashi, RDC',
        phone: '+243 810 002 002',
      ),
      FamilyMember(
        id: '3',
        name: 'David MUGENYI',
        relation: 'Grand Frère',
        profession: 'Chef de Projet Numérique & Designer UI/UX',
        imagePath: 'assets/images/family_4.jpg',
        isAsset: true,
        description:
            'Passionné de nouvelles technologies, de créativité numérique et d\'innovation mobile au sein du cercle familial.',
        location: 'Kinshasa, RDC',
        phone: '+243 810 003 003',
      ),
      FamilyMember(
        id: '4',
        name: 'Samuel BIARWANGA',
        relation: 'Frère Cadet',
        profession: 'Étudiant en Sciences & Robotique',
        imagePath: 'assets/images/family_1.jpg',
        isAsset: true,
        description:
            'Le cadet dynamique et ambitieux, passionné par les nouvelles technologies, la programmation et l\'intelligence artificielle.',
        location: 'Kinshasa, RDC',
        phone: '+243 810 004 004',
      ),
    ];
  }
}
