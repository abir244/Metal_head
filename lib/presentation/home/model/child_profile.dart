class ChildProfile {
  final String name;
  final String school; // e.g., 'UIA - Real School'
  final String? jersey; // e.g., '15'
  final String? position; // e.g., 'Midfielder'
  final int? height; // e.g., 172 (cm)
  final String? imageUrl; // network or asset path

  // Additional optional fields used across the UI
  final int? age;
  final String? status;
  final int? weight;
  final String? foot;
  final String? notes;

  const ChildProfile({
    required this.name,
    required this.school,
    this.jersey,
    this.position,
    this.height,
    this.imageUrl,
    this.age,
    this.status,
    this.weight,
    this.foot,
    this.notes,
  });

  static ChildProfile mock() => const ChildProfile(
    name: 'Michael Smith',
    school: 'UIA - Real School',
    jersey: '15',
    position: 'Midfielder',
    height: 172,
    imageUrl: 'assets/images/child.png',
    age: 12,
    status: 'active',
    weight: 40,
    foot: 'Right',
    notes: 'Hardworking midfielder',
  );
}
