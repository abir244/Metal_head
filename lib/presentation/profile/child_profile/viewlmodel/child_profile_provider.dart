import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metalheadd/presentation/home/model/child_profile.dart';
import 'package:metalheadd/presentation/home/model/parent_info.dart';
import 'package:metalheadd/presentation/home/model/performance_stats.dart';

final childProfileProvider = FutureProvider<ChildProfile>((ref) async {
  await Future.delayed(const Duration(milliseconds: 300));

  return ChildProfile(
    name: "Michael Smith",
    imageUrl:
    "https://www.planetsport.com/image-library/land/1200/k/kylian-mbappe-psg-france-3-april-2022.webp",
    school: "Highlands Academy",

    /// ✅ FIX: jersey must be int
    jersey: 15,

    position: "Midfielder",
    birthday: "16/03",
    team: "Team A",
    registeredOn: "15 Jan 2025",
    status: "Active",

    age: 12,
    height: 155,
    weight: 45,
    foot: "Right",
    notes: "Top scorer in last season",

    parent: ParentInfo(
      name: "Alex Jordan",
      email: "demo123@gmail.com",
      phone: "+999 1234 5678",
    ),

    stats: PerformanceStats(
      matches: 12,
      goals: 5,
      assists: 4,
      potm: 2,
      attendance: "92%",
    ),
  );
});
