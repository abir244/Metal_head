import 'package:metalheadd/presentation/home/model/parent_info.dart';
import 'package:metalheadd/presentation/home/model/performance_stats.dart';

class ChildProfile {
  final String name;
  final String school;
  final int jersey;
  final String status;

  final String? imageUrl;
  final String? position;
  final String? birthday;
  final String? team;
  final String? registeredOn;

  final int? age;
  final int? height;
  final int? weight;
  final String? foot;
  final String? notes;

  /// ✅ ALWAYS AVAILABLE
  final ParentInfo parent;
  final PerformanceStats stats;

  ChildProfile({
    required this.name,
    required this.school,
    required this.jersey,
    required this.status,
    required this.parent,
    required this.stats,
    this.imageUrl,
    this.position,
    this.birthday,
    this.team,
    this.registeredOn,
    this.age,
    this.height,
    this.weight,
    this.foot,
    this.notes,
  });

  /// -------------------------
  /// MOCK DATA
  /// -------------------------
  factory ChildProfile.mock() {
    return ChildProfile(
      name: "Kylian Mbappé",
      imageUrl:
      "https://www.planetsport.com/image-library/land/1200/k/kylian-mbappe-psg-france-3-april-2022.webp",
      school: "Paris Academy",
      jersey: 7,
      position: "Forward",
      birthday: "20/12",
      team: "PSG Youth",
      registeredOn: "10 Jan 2024",
      status: "Active",
      age: 25,
      height: 178,
      weight: 73,
      foot: "Right",
      notes: "Fast, technical, elite finisher",
      parent: ParentInfo(
        name: "Wilfried Mbappé",
        email: "parent@mail.com",
        phone: "+33 123 456 789",
      ),
      stats: PerformanceStats(
        matches: 34,
        goals: 29,
        assists: 12,
        potm: 8,
        attendance: "98%",
      ),
    );
  }

  /// -------------------------
  /// COPY WITH
  /// -------------------------
  ChildProfile copyWith({
    String? name,
    String? school,
    int? jersey,
    String? imageUrl,
    String? position,
    String? birthday,
    String? team,
    String? registeredOn,
    String? status,
    int? age,
    int? height,
    int? weight,
    String? foot,
    String? notes,
    ParentInfo? parent,
    PerformanceStats? stats,
  }) {
    return ChildProfile(
      name: name ?? this.name,
      school: school ?? this.school,
      jersey: jersey ?? this.jersey,
      imageUrl: imageUrl ?? this.imageUrl,
      position: position ?? this.position,
      birthday: birthday ?? this.birthday,
      team: team ?? this.team,
      registeredOn: registeredOn ?? this.registeredOn,
      status: status ?? this.status,
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      foot: foot ?? this.foot,
      notes: notes ?? this.notes,
      parent: parent ?? this.parent,
      stats: stats ?? this.stats,
    );
  }
}
