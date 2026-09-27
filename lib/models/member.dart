import 'contribution.dart';

class Member {
  final String id;
  final String name;
  final String roleTitle;
  final int avatarColorValue;
  final String bio;
  final DateTime joinedDate;
  final String password;
  final List<Contribution> contributions;

  Member({
    required this.id,
    required this.name,
    required this.roleTitle,
    this.avatarColorValue = 0xFF00FF9D,
    this.bio = '',
    required this.joinedDate,
    this.password = 'user2026',
    List<Contribution>? contributions,
  }) : contributions = contributions ?? [];

  int get totalContributions => contributions.length;

  Map<DateTime, int> get dailyContributionCounts {
    final Map<DateTime, int> map = {};
    for (final c in contributions) {
      final normalizedDate = DateTime(c.timestamp.year, c.timestamp.month, c.timestamp.day);
      map[normalizedDate] = (map[normalizedDate] ?? 0) + 1;
    }
    return map;
  }

  int get currentStreak {
    if (contributions.isEmpty) return 0;
    final dates = dailyContributionCounts.keys.toList()
      ..sort((a, b) => b.compareTo(a));
    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);
    final yesterday = normalizedToday.subtract(const Duration(days: 1));

    if (!dates.contains(normalizedToday) && !dates.contains(yesterday)) {
      return 0;
    }

    int streak = 0;
    DateTime checkDate = dates.contains(normalizedToday) ? normalizedToday : yesterday;
    while (dates.contains(checkDate)) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }
    return streak;
  }

  Member copyWith({
    String? id,
    String? name,
    String? roleTitle,
    int? avatarColorValue,
    String? bio,
    DateTime? joinedDate,
    String? password,
    List<Contribution>? contributions,
  }) {
    return Member(
      id: id ?? this.id,
      name: name ?? this.name,
      roleTitle: roleTitle ?? this.roleTitle,
      avatarColorValue: avatarColorValue ?? this.avatarColorValue,
      bio: bio ?? this.bio,
      joinedDate: joinedDate ?? this.joinedDate,
      password: password ?? this.password,
      contributions: contributions ?? List.from(this.contributions),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'roleTitle': roleTitle,
      'avatarColorValue': avatarColorValue,
      'bio': bio,
      'joinedDate': joinedDate.toIso8601String(),
      'password': password,
      'contributions': contributions.map((c) => c.toJson()).toList(),
    };
  }

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'] as String,
      name: json['name'] as String,
      roleTitle: json['roleTitle'] as String,
      avatarColorValue: (json['avatarColorValue'] as num?)?.toInt() ?? 0xFF00FF9D,
      bio: (json['bio'] as String?) ?? '',
      joinedDate: DateTime.parse(json['joinedDate'] as String),
      password: (json['password'] as String?) ?? 'user2026',
      contributions: (json['contributions'] as List<dynamic>?)
              ?.map((item) => Contribution.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
