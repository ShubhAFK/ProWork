class Accomplishment {
  final String id;
  final String title;
  final String description;
  final DateTime completedAt;
  final List<String> contributorNames;
  final String category;
  final String impactTag;

  Accomplishment({
    required this.id,
    required this.title,
    required this.description,
    required this.completedAt,
    this.contributorNames = const [],
    this.category = 'Milestone',
    this.impactTag = 'Major',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completedAt': completedAt.toIso8601String(),
      'contributorNames': contributorNames,
      'category': category,
      'impactTag': impactTag,
    };
  }

  factory Accomplishment.fromJson(Map<String, dynamic> json) {
    return Accomplishment(
      id: json['id'] as String,
      title: json['title'] as String,
      description: (json['description'] as String?) ?? '',
      completedAt: DateTime.parse(json['completedAt'] as String),
      contributorNames: (json['contributorNames'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      category: (json['category'] as String?) ?? 'Milestone',
      impactTag: (json['impactTag'] as String?) ?? 'Major',
    );
  }
}
