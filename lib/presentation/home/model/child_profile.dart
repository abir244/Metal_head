// lib/presentation/home/model/child_profile.dart

class ChildProfile {
  final String name;
  final String imageUrl;
  final String school;
  final String jersey;
  final String position;
  final String birthday;
  final String team;
  final String registeredOn;
  final String status;
  final int? age;
  final double? height;
  final double? weight;
  final String? foot;
  final String? notes;
  final ParentInfo parent;      // Requires ParentInfo class below
  final PerformanceStats stats; // Requires PerformanceStats class below

  ChildProfile({
    required this.name,
    required this.imageUrl,
    required this.school,
    required this.jersey,
    required this.position,
    required this.birthday,
    required this.team,
    required this.registeredOn,
    required this.status,
    this.age,
    this.height,
    this.weight,
    this.foot,
    this.notes,
    required this.parent,
    required this.stats,
  });

  static ChildProfile mock() {
    return ChildProfile(
      name: "Michael Smith",
      imageUrl: "https://via.placeholder.com/150",
      school: "Highlands Academy",
      jersey: "15",
      position: "Midfielder",
      birthday: "16/03",
      team: "Team A",
      registeredOn: "15 Jan 2025",
      status: "Active",
      age: 12,
      height: 155,
      weight: 45,
      parent: ParentInfo( // Error here disappears once class is added below
        name: "Alex Jordan",
        email: "demo123@gmail.com",
        phone: "+999 1234 5678",
      ),
      stats: PerformanceStats( // Error here disappears once class is added below
        matches: 12,
        goals: 5,
        assists: 4,
        potm: 2,
        attendance: "92%",
      ),
    );
  }
}

// --- DEFINE THESE CLASSES AT THE BOTTOM OF THE FILE ---

class ParentInfo {
  final String name;
  final String email;
  final String phone;

  ParentInfo({
    required this.name,
    required this.email,
    required this.phone,
  });
}

class PerformanceStats {
  final int matches;
  final int goals;
  final int assists;
  final int potm;
  final String attendance;

  PerformanceStats({
    required this.matches,
    required this.goals,
    required this.assists,
    required this.potm,
    required this.attendance,
  });
}