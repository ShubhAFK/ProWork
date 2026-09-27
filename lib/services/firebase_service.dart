import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/project_data.dart';
import '../models/goal.dart';
import '../models/accomplishment.dart';
import '../models/member.dart';
import '../models/contribution.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Collection references
  CollectionReference get _projectRef => _firestore.collection('project');
  CollectionReference get _goalsRef => _firestore.collection('goals');
  CollectionReference get _accomplishmentsRef => _firestore.collection('accomplishments');
  CollectionReference get _membersRef => _firestore.collection('members');

  // Stream controllers for real-time updates
  final StreamController<ProjectData> _projectDataController = StreamController<ProjectData>.broadcast();
  Stream<ProjectData> get projectDataStream => _projectDataController.stream;

  StreamSubscription? _projectSub;
  StreamSubscription? _goalsSub;
  StreamSubscription? _accomplishmentsSub;
  StreamSubscription? _membersSub;

  // Initialize real-time listeners
  void initRealtimeListeners() {
    // Listen to project settings
    _projectSub = _projectRef.doc('settings').snapshots().listen((doc) {
      _emitUpdatedData();
    });

    // Listen to goals
    _goalsSub = _goalsRef.snapshots().listen((snapshot) {
      _emitUpdatedData();
    });

    // Listen to accomplishments
    _accomplishmentsSub = _accomplishmentsRef.orderBy('completedAt', descending: true).snapshots().listen((snapshot) {
      _emitUpdatedData();
    });

    // Listen to members
    _membersSub = _membersRef.snapshots().listen((snapshot) {
      _emitUpdatedData();
    });
  }

  // Emit updated data to all listeners
  Future<void> _emitUpdatedData() async {
    try {
      final data = await loadProjectData();
      _projectDataController.add(data);
    } catch (e) {
      // Handle error silently
    }
  }

  // Load all project data from Firestore
  Future<ProjectData> loadProjectData() async {
    try {
      // Load project settings
      final projectDoc = await _projectRef.doc('settings').get();
      
      String projectName = 'ProWork';
      String tagline = 'Collaborative Project Tracker & Velocity Engine';
      double overallProgress = 0.33;
      String adminPassword = 'ro696969ho';
      String memberPassword = 'user2026';

      if (projectDoc.exists) {
        final data = projectDoc.data() as Map<String, dynamic>;
        projectName = data['projectName'] ?? projectName;
        tagline = data['tagline'] ?? tagline;
        overallProgress = (data['overallProgress'] as num?)?.toDouble() ?? overallProgress;
        adminPassword = data['adminPassword'] ?? adminPassword;
        memberPassword = data['memberPassword'] ?? memberPassword;
      }

      // Load goals
      final goalsSnapshot = await _goalsRef.get();
      Goal currentGoal = Goal(
        id: 'default',
        title: 'Initial Goal',
        description: '',
        targetDate: DateTime.now().add(const Duration(days: 7)),
      );

      if (goalsSnapshot.docs.isNotEmpty) {
        final doc = goalsSnapshot.docs.first;
        currentGoal = Goal.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id});
      }

      // Load accomplishments
      final accomplishmentsSnapshot = await _accomplishmentsRef.orderBy('completedAt', descending: true).get();
      final accomplishments = accomplishmentsSnapshot.docs.map((doc) {
        return Accomplishment.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id});
      }).toList();

      // Load members
      final membersSnapshot = await _membersRef.get();
      final members = membersSnapshot.docs.map((doc) {
        return Member.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id});
      }).toList();

      return ProjectData(
        projectName: projectName,
        tagline: tagline,
        overallProgress: overallProgress,
        adminPassword: adminPassword,
        memberPassword: memberPassword,
        currentGoal: currentGoal,
        accomplishments: accomplishments,
        members: members,
      );
    } catch (e) {
      // Return seed data if error
      return ProjectData.createInitialSeed();
    }
  }

  // Save project settings
  Future<void> saveProjectSettings({
    required String projectName,
    required String tagline,
    required double overallProgress,
    required String adminPassword,
    required String memberPassword,
  }) async {
    await _projectRef.doc('settings').set({
      'projectName': projectName,
      'tagline': tagline,
      'overallProgress': overallProgress,
      'adminPassword': adminPassword,
      'memberPassword': memberPassword,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Update project name
  Future<void> updateProjectName(String name) async {
    await _projectRef.doc('settings').set({
      'projectName': name,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // Update overall progress
  Future<void> updateOverallProgress(double progress) async {
    await _projectRef.doc('settings').set({
      'overallProgress': progress,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // Update admin password
  Future<void> updateAdminPassword(String password) async {
    await _projectRef.doc('settings').set({
      'adminPassword': password,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // Update member password
  Future<void> updateMemberPassword(String password) async {
    await _projectRef.doc('settings').set({
      'memberPassword': password,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // Save/update goal
  Future<void> saveGoal(Goal goal) async {
    await _goalsRef.doc(goal.id).set({
      ...goal.toJson(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Toggle goal check item
  Future<void> toggleGoalCheckItem(String goalId, String itemId, bool isCompleted) async {
    final doc = await _goalsRef.doc(goalId).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      final checklist = List<Map<String, dynamic>>.from(data['checklist'] ?? []);
      final updatedChecklist = checklist.map((item) {
        if (item['id'] == itemId) {
          return {...item, 'isCompleted': isCompleted};
        }
        return item;
      }).toList();
      
      await _goalsRef.doc(goalId).update({
        'checklist': updatedChecklist,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // Add accomplishment
  Future<void> addAccomplishment(Accomplishment accomplishment) async {
    await _accomplishmentsRef.doc(accomplishment.id).set({
      ...accomplishment.toJson(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Remove accomplishment
  Future<void> removeAccomplishment(String id) async {
    await _accomplishmentsRef.doc(id).delete();
  }

  // Add member
  Future<void> addMember(Member member) async {
    await _membersRef.doc(member.id).set({
      ...member.toJson(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Update member
  Future<void> updateMember(Member member) async {
    await _membersRef.doc(member.id).set({
      ...member.toJson(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Remove member
  Future<void> removeMember(String memberId) async {
    await _membersRef.doc(memberId).delete();
  }

  // Add contribution to member
  Future<void> addContributionToMember(String memberId, Contribution contribution) async {
    final doc = await _membersRef.doc(memberId).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      final contributions = List<Map<String, dynamic>>.from(data['contributions'] ?? []);
      contributions.insert(0, contribution.toJson());
      
      await _membersRef.doc(memberId).update({
        'contributions': contributions,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // Dispose listeners
  void dispose() {
    _projectSub?.cancel();
    _goalsSub?.cancel();
    _accomplishmentsSub?.cancel();
    _membersSub?.cancel();
    _projectDataController.close();
  }
}
