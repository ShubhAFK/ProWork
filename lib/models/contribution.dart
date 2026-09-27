enum ContributionType {
  feature,
  bugfix,
  design,
  docs,
  review,
  deployment,
}

class Contribution {
  final String id;
  final String memberId;
  final String title;
  final String description;
  final DateTime timestamp;
  final ContributionType type;
  final int impactScore;

  Contribution({
    required this.id,
    required this.memberId,
    required this.title,
    required this.description,
    required this.timestamp,
    this.type = ContributionType.feature,
    this.impactScore = 1,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'memberId': memberId,
      'title': title,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'type': type.name,
      'impactScore': impactScore,
    };
  }

  factory Contribution.fromJson(Map<String, dynamic> json) {
    return Contribution(
      id: json['id'] as String,
      memberId: json['memberId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: ContributionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ContributionType.feature,
      ),
      impactScore: (json['impactScore'] as num?)?.toInt() ?? 1,
    );
  }
}
