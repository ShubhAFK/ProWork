import 'package:flutter/foundation.dart';
import '../models/user_role.dart';
import '../models/project_data.dart';
import '../models/goal.dart';
import '../models/accomplishment.dart';
import '../models/member.dart';
import '../models/contribution.dart';
import '../services/firebase_service.dart';

class AppState extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  ProjectData _projectData = ProjectData.createInitialSeed();
  UserRole? _currentRole;
  String? _currentMemberId;
  bool _isLoading = true;

  AppState() {
    _initData();
  }

  ProjectData get projectData => _projectData;
  UserRole? get currentRole => _currentRole;
  String? get currentMemberId => _currentMemberId;
  bool get isLoading => _isLoading;
  bool get isAdmin => _currentRole == UserRole.admin;
  bool get isMember => _currentRole == UserRole.member;
  bool get isAuthenticated => _currentRole != null;

  Member? get currentMember {
    if (_currentMemberId == null) return null;
    return getMemberById(_currentMemberId!);
  }

  Future<void> _initData() async {
    // Load initial data from Firebase
    _projectData = await _firebaseService.loadProjectData();
    _isLoading = false;
    notifyListeners();

    // Start real-time listeners
    _firebaseService.initRealtimeListeners();
    _firebaseService.projectDataStream.listen((data) {
      _projectData = data;
      notifyListeners();
    });
  }

  Future<void> _persist() async {
    // Firebase auto-syncs via real-time listeners
    notifyListeners();
  }

  bool loginAdmin(String password) {
    if (password == _projectData.adminPassword) {
      _currentRole = UserRole.admin;
      _currentMemberId = null;
      notifyListeners();
      return true;
    }
    return false;
  }

  bool loginMember(String password, [String? memberId, String? newMemberName]) {
    if (memberId != null) {
      final member = getMemberById(memberId);
      if (member != null) {
        if (password == member.password || password == _projectData.memberPassword) {
          _currentRole = UserRole.member;
          _currentMemberId = memberId;
          notifyListeners();
          return true;
        }
        return false;
      }
    }

    if (newMemberName != null && newMemberName.trim().isNotEmpty) {
      if (password == _projectData.memberPassword) {
        _currentRole = UserRole.member;
        final newMember = Member(
          id: 'm_${DateTime.now().millisecondsSinceEpoch}',
          name: newMemberName.trim(),
          roleTitle: 'Team Member',
          joinedDate: DateTime.now(),
          password: 'user2026',
        );
        _projectData.members.add(newMember);
        _currentMemberId = newMember.id;
        _firebaseService.addMember(newMember);
        notifyListeners();
        return true;
      }
      return false;
    }

    if (_projectData.members.isNotEmpty) {
      final firstMember = _projectData.members.first;
      if (password == firstMember.password || password == _projectData.memberPassword) {
        _currentRole = UserRole.member;
        _currentMemberId = firstMember.id;
        notifyListeners();
        return true;
      }
      return false;
    }

    if (password == _projectData.memberPassword) {
      _currentRole = UserRole.member;
      final newMember = Member(
        id: 'm_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Member',
        roleTitle: 'Team Member',
        joinedDate: DateTime.now(),
        password: 'user2026',
      );
      _projectData.members.add(newMember);
      _currentMemberId = newMember.id;
      _firebaseService.addMember(newMember);
      notifyListeners();
      return true;
    }
    return false;
  }

  bool changeMemberPassword(String memberId, String oldPassword, String newPassword) {
    final member = getMemberById(memberId);
    if (member != null && newPassword.trim().isNotEmpty) {
      if (oldPassword == member.password || oldPassword == _projectData.memberPassword) {
        final updated = member.copyWith(password: newPassword.trim());
        updateMember(updated);
        return true;
      }
    }
    return false;
  }

  void switchCurrentMember(String memberId) {
    if (getMemberById(memberId) != null) {
      _currentMemberId = memberId;
      notifyListeners();
    }
  }

  void logout() {
    _currentRole = null;
    _currentMemberId = null;
    notifyListeners();
  }

  bool changeAdminPassword(String oldPassword, String newPassword) {
    if (oldPassword == _projectData.adminPassword && newPassword.trim().isNotEmpty) {
      _projectData.adminPassword = newPassword.trim();
      _firebaseService.updateAdminPassword(newPassword.trim());
      notifyListeners();
      return true;
    }
    return false;
  }

  void updateProjectName(String name) {
    if (name.trim().isNotEmpty) {
      _projectData.projectName = name.trim();
      _firebaseService.updateProjectName(name.trim());
    }
  }

  void updateOverallProgress(double progress) {
    _projectData.overallProgress = progress.clamp(0.0, 1.0);
    _firebaseService.updateOverallProgress(_projectData.overallProgress);
  }

  void updateCurrentGoal(Goal goal) {
    _projectData.currentGoal = goal;
    _recalculateProgress();
    _firebaseService.saveGoal(goal);
  }

  void toggleGoalCheckItem(String itemId) {
    final updatedList = _projectData.currentGoal.checklist.map((item) {
      if (item.id == itemId) {
        return item.copyWith(isCompleted: !item.isCompleted);
      }
      return item;
    }).toList();

    _projectData.currentGoal = _projectData.currentGoal.copyWith(checklist: updatedList);
    _recalculateProgress();
    _firebaseService.toggleGoalCheckItem(_projectData.currentGoal.id, itemId, 
        _projectData.currentGoal.checklist.firstWhere((item) => item.id == itemId).isCompleted);
  }

  void _recalculateProgress() {
    if (_projectData.currentGoal.checklist.isNotEmpty) {
      final ratio = _projectData.currentGoal.completionRatio;
      _projectData.overallProgress = ((_projectData.overallProgress * 0.4) + (ratio * 0.6)).clamp(0.0, 1.0);
    }
  }

  void addAccomplishment(Accomplishment accomplishment) {
    _projectData.accomplishments.insert(0, accomplishment);
    _firebaseService.addAccomplishment(accomplishment);
  }

  void removeAccomplishment(String id) {
    _projectData.accomplishments.removeWhere((a) => a.id == id);
    _firebaseService.removeAccomplishment(id);
  }

  void addMember(Member member) {
    _projectData.members.add(member);
    _firebaseService.addMember(member);
  }

  void updateMember(Member member) {
    final index = _projectData.members.indexWhere((m) => m.id == member.id);
    if (index != -1) {
      _projectData.members[index] = member;
      _firebaseService.updateMember(member);
    }
  }

  void removeMember(String memberId) {
    _projectData.members.removeWhere((m) => m.id == memberId);
    if (_currentMemberId == memberId) {
      _currentMemberId = _projectData.members.isNotEmpty ? _projectData.members.first.id : null;
    }
    _firebaseService.removeMember(memberId);
  }

  void addContributionToMember(String memberId, Contribution contribution) {
    final index = _projectData.members.indexWhere((m) => m.id == memberId);
    if (index != -1) {
      final member = _projectData.members[index];
      final updatedContributions = List<Contribution>.from(member.contributions)..insert(0, contribution);
      _projectData.members[index] = member.copyWith(contributions: updatedContributions);
      _firebaseService.addContributionToMember(memberId, contribution);
    }
  }

  Member? getMemberById(String id) {
    try {
      return _projectData.members.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }
}
