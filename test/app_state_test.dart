import 'package:flutter_test/flutter_test.dart';
import 'package:prowork/models/project_data.dart';
import 'package:prowork/models/goal.dart';
import 'package:prowork/models/member.dart';
import 'package:prowork/models/contribution.dart';
import 'package:prowork/models/accomplishment.dart';

void main() {
  group('ProWork Project Data and Authentication', () {
    test('Default seed values match specifications', () {
      final seed = ProjectData.createInitialSeed();
      expect(seed.projectName, 'ProWork');
      expect(seed.adminPassword, 'ro696969ho');
      expect(seed.memberPassword, 'user2026');
      expect(seed.members.isEmpty, true);
      expect(seed.accomplishments.isNotEmpty, true);
      expect(seed.currentGoal.title.isNotEmpty, true);
    });

    test('Member contribution heatmap calculation', () {
      final now = DateTime.now();
      final member = Member(
        id: 'test_m1',
        name: 'Test Dev',
        roleTitle: 'Engineer',
        joinedDate: now,
        contributions: [
          Contribution(
            id: 'c1',
            memberId: 'test_m1',
            title: 'Refactored backend logic',
            description: '',
            timestamp: now,
            type: ContributionType.feature,
            impactScore: 3,
          ),
          Contribution(
            id: 'c2',
            memberId: 'test_m1',
            title: 'Fixed styling',
            description: '',
            timestamp: now,
            type: ContributionType.design,
            impactScore: 1,
          ),
        ],
      );

      final daily = member.dailyContributionCounts;
      final normalizedToday = DateTime(now.year, now.month, now.day);
      expect(daily[normalizedToday], 2);
      expect(member.totalContributions, 2);
      expect(member.currentStreak, 1);
    });

    test('Goal completion ratio calculates correctly', () {
      final goal = Goal(
        id: 'g1',
        title: 'MVP Goal',
        description: 'Context',
        targetDate: DateTime.now().add(const Duration(days: 7)),
        checklist: [
          GoalCheckItem(id: '1', title: 'Task 1', isCompleted: true),
          GoalCheckItem(id: '2', title: 'Task 2', isCompleted: false),
          GoalCheckItem(id: '3', title: 'Task 3', isCompleted: true),
          GoalCheckItem(id: '4', title: 'Task 4', isCompleted: false),
        ],
      );

      expect(goal.completionRatio, 0.5);
      expect(goal.completedCount, 2);
      expect(goal.totalChecklistItems, 4);
    });

    test('Project data serialization and deserialization', () {
      final seed = ProjectData.createInitialSeed();
      final json = seed.toJson();
      final restored = ProjectData.fromJson(json);

      expect(restored.projectName, seed.projectName);
      expect(restored.adminPassword, seed.adminPassword);
      expect(restored.memberPassword, seed.memberPassword);
      expect(restored.members.length, seed.members.length);
      expect(restored.accomplishments.length, seed.accomplishments.length);
      expect(restored.currentGoal.title, seed.currentGoal.title);
    });

    test('Accomplishment model serialization', () {
      final now = DateTime.now();
      final acc = Accomplishment(
        id: 'acc_test',
        title: 'Released Alpha',
        description: 'First milestone release',
        completedAt: now,
        contributorNames: ['Alex Vance'],
        category: 'Milestone',
        impactTag: 'High Impact',
      );

      final json = acc.toJson();
      final restored = Accomplishment.fromJson(json);

      expect(restored.id, 'acc_test');
      expect(restored.title, 'Released Alpha');
      expect(restored.category, 'Milestone');
      expect(restored.impactTag, 'High Impact');
      expect(restored.contributorNames, ['Alex Vance']);
    });
  });
}
