import 'goal.dart';
import 'accomplishment.dart';
import 'member.dart';

class ProjectData {
  String projectName;
  String tagline;
  double overallProgress;
  String adminPassword;
  String memberPassword;
  Goal currentGoal;
  List<Accomplishment> accomplishments;
  List<Member> members;

  ProjectData({
    this.projectName = 'ProWork',
    this.tagline = 'Next-Gen Collaborative Project Acceleration',
    this.overallProgress = 0.68,
    this.adminPassword = 'ro696969ho',
    this.memberPassword = 'user2026',
    required this.currentGoal,
    List<Accomplishment>? accomplishments,
    List<Member>? members,
  })  : accomplishments = accomplishments ?? [],
        members = members ?? [];

  static ProjectData createInitialSeed() {
    final now = DateTime.now();

    final initialGoal = Goal(
      id: 'goal_v1',
      title: 'Complete Project Setup & Milestone Planning',
      description: 'Ship initial project foundations, track team deliverables, and define core goals.',
      targetDate: now.add(const Duration(days: 14)),
      priority: GoalPriority.high,
      checklist: [
        GoalCheckItem(id: 'c1', title: 'Define project architecture and milestone deliverables', isCompleted: true),
        GoalCheckItem(id: 'c2', title: 'Onboard team members and assign technical focus', isCompleted: false),
        GoalCheckItem(id: 'c3', title: 'Ship core features and review team activity', isCompleted: false),
      ],
    );

    final initialAccomplishments = [
      Accomplishment(
        id: 'acc_1',
        title: 'Project Workspace Initialized',
        description: 'Initialized ProWork environment with dual-tier security and collaborative tracking.',
        completedAt: now.subtract(const Duration(days: 1)),
        contributorNames: [],
        category: 'Milestone',
        impactTag: 'High Impact',
      ),
    ];

    return ProjectData(
      projectName: 'ProWork',
      tagline: 'Collaborative Project Tracker & Velocity Engine',
      overallProgress: 0.33,
      adminPassword: 'ro696969ho',
      memberPassword: 'user2026',
      currentGoal: initialGoal,
      accomplishments: initialAccomplishments,
      members: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'projectName': projectName,
      'tagline': tagline,
      'overallProgress': overallProgress,
      'adminPassword': adminPassword,
      'memberPassword': memberPassword,
      'currentGoal': currentGoal.toJson(),
      'accomplishments': accomplishments.map((a) => a.toJson()).toList(),
      'members': members.map((m) => m.toJson()).toList(),
    };
  }

  factory ProjectData.fromJson(Map<String, dynamic> json) {
    return ProjectData(
      projectName: (json['projectName'] as String?) ?? 'ProWork',
      tagline: (json['tagline'] as String?) ?? '',
      overallProgress: (json['overallProgress'] as num?)?.toDouble() ?? 0.0,
      adminPassword: (json['adminPassword'] as String?) ?? 'ro696969ho',
      memberPassword: (json['memberPassword'] as String?) ?? 'user2026',
      currentGoal: json['currentGoal'] != null
          ? Goal.fromJson(json['currentGoal'] as Map<String, dynamic>)
          : Goal(
              id: 'default',
              title: 'Initial Goal',
              description: '',
              targetDate: DateTime.now().add(const Duration(days: 7)),
            ),
      accomplishments: (json['accomplishments'] as List<dynamic>?)
              ?.map((e) => Accomplishment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      members: (json['members'] as List<dynamic>?)
              ?.map((e) => Member.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
