import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/app_state.dart';
import '../models/member.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/progress_ring_card.dart';
import '../widgets/goal_card.dart';
import '../widgets/accomplishment_card.dart';
import '../widgets/member_card.dart';
import '../widgets/sleek_button.dart';
import '../widgets/sleek_text_field.dart';
import 'member_profile_screen.dart';
import 'edit_goal_screen.dart';
import 'add_accomplishment_screen.dart';
import 'admin_settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final AppState appState;

  const HomeScreen({
    super.key,
    required this.appState,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _showAddMemberModal(BuildContext context) {
    final nameController = TextEditingController();
    final roleController = TextEditingController();
    final bioController = TextEditingController();
    int selectedColor = 0xFF00FF9D;

    final colorOptions = [
      0xFF00FF9D,
      0xFF00D2FF,
      0xFFA855F7,
      0xFFFF2E93,
      0xFFFFD166,
      0xFFFF3B5C,
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.backgroundSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        side: BorderSide(color: AppTheme.border),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(modalCtx).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ONBOARD TEAM MEMBER',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 20, color: AppTheme.textSecondary),
                          onPressed: () => Navigator.pop(modalCtx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SleekTextField(
                      controller: nameController,
                      label: 'Full Name',
                      hint: 'e.g. Maya Lin',
                      prefixIcon: Icons.person_outline,
                    ),
                    const SizedBox(height: 14),
                    SleekTextField(
                      controller: roleController,
                      label: 'Designation / Specialty',
                      hint: 'e.g. Flutter Mobile Engineer',
                      prefixIcon: Icons.badge_outlined,
                    ),
                    const SizedBox(height: 14),
                    SleekTextField(
                      controller: bioController,
                      label: 'Focus / Responsibilities',
                      hint: 'e.g. State management, animations & performance',
                      maxLines: 2,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'AVATAR ACCENT COLOR',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textSecondary,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: colorOptions.map((c) {
                        final isSel = selectedColor == c;
                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              selectedColor = c;
                            });
                          },
                          child: Container(
                            width: 32,
                            height: 32,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(c),
                              border: Border.all(
                                color: isSel ? Colors.white : Colors.transparent,
                                width: isSel ? 2.5 : 1,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    SleekButton(
                      text: 'ADD MEMBER TO ROSTER',
                      icon: Icons.person_add_alt_1,
                      onPressed: () {
                        final name = nameController.text.trim();
                        final role = roleController.text.trim();
                        if (name.isNotEmpty) {
                          final newMember = Member(
                            id: 'm_${DateTime.now().millisecondsSinceEpoch}',
                            name: name,
                            roleTitle: role.isNotEmpty ? role : 'Developer',
                            bio: bioController.text.trim(),
                            avatarColorValue: selectedColor,
                            joinedDate: DateTime.now(),
                          );
                          widget.appState.addMember(newMember);
                          Navigator.pop(modalCtx);
                          setState(() {});
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showEditProjectNameDialog() {
    final controller = TextEditingController(text: widget.appState.projectData.projectName);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppTheme.border),
          ),
          title: Text(
            'Rename Project',
            style: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
          ),
          content: SleekTextField(
            controller: controller,
            label: 'Project Name',
            hint: 'e.g. ProWork',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('CANCEL', style: GoogleFonts.spaceGrotesk(color: AppTheme.textSecondary)),
            ),
            TextButton(
              onPressed: () {
                final name = controller.text.trim();
                if (name.isNotEmpty) {
                  widget.appState.updateProjectName(name);
                  Navigator.pop(ctx);
                  setState(() {});
                }
              },
              child: Text('SAVE', style: GoogleFonts.spaceGrotesk(color: AppTheme.accentGreen, fontWeight: FontWeight.w800)),
            ),
          ],
        );
      },
    );
  }

  void _showEditMemberNameDialog() {
    final member = widget.appState.currentMember;
    if (member == null) return;
    final controller = TextEditingController(text: member.name);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppTheme.border),
          ),
          title: Text(
            'Change Your Name',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          content: SleekTextField(
            controller: controller,
            label: 'Your Display Name',
            hint: 'Enter your name',
            prefixIcon: Icons.person_outline,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'CANCEL',
                style: GoogleFonts.spaceGrotesk(color: AppTheme.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () {
                final name = controller.text.trim();
                if (name.isNotEmpty) {
                  widget.appState.updateMember(member.copyWith(name: name));
                  Navigator.pop(ctx);
                  setState(() {});
                }
              },
              child: Text(
                'SAVE',
                style: GoogleFonts.spaceGrotesk(
                  color: AppTheme.accentGreen,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.appState.projectData;
    final bool isAdmin = widget.appState.isAdmin;
    final currentMember = widget.appState.currentMember;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: CustomAppBar(
        projectName: data.projectName,
        role: widget.appState.currentRole,
        memberName: currentMember?.name,
        onLogout: () {
          widget.appState.logout();
        },
        onSettings: isAdmin
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AdminSettingsScreen(appState: widget.appState),
                  ),
                ).then((_) => setState(() {}));
              }
            : null,
        onEditProject: isAdmin ? _showEditProjectNameDialog : null,
        onEditMember: !isAdmin ? _showEditMemberNameDialog : null,
      ),
      body: RefreshIndicator(
        color: AppTheme.accentGreen,
        backgroundColor: AppTheme.surfaceSecondary,
        onRefresh: () async {
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProgressRingCard(
                progress: data.overallProgress,
                totalGoalsCount: data.currentGoal.totalChecklistItems,
                completedGoalsCount: data.currentGoal.completedCount,
                membersCount: data.members.length,
                isAdmin: isAdmin,
                onProgressChanged: isAdmin
                    ? (val) {
                        widget.appState.updateOverallProgress(val);
                      }
                    : null,
              ),
              const SizedBox(height: 20),
              GoalCard(
                goal: data.currentGoal,
                isAdmin: isAdmin,
                onEdit: isAdmin
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditGoalScreen(appState: widget.appState),
                          ),
                        ).then((_) => setState(() {}));
                      }
                    : null,
                onToggleItem: (itemId) {
                  widget.appState.toggleGoalCheckItem(itemId);
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.group_work_outlined, size: 16, color: AppTheme.accentCyan),
                      const SizedBox(width: 8),
                      Text(
                        'PROJECT COLLABORATORS (${data.members.length})',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  if (isAdmin) ...[
                    SleekButton(
                      text: '+ ADD TEAMMATE',
                      height: 32,
                      variant: SleekButtonVariant.outline,
                      onPressed: () => _showAddMemberModal(context),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              if (data.members.isEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: AppTheme.sleekGlassDecoration(),
                  child: Center(
                    child: Text(
                      'No team members registered yet.',
                      style: GoogleFonts.inter(color: AppTheme.textMuted, fontSize: 13),
                    ),
                  ),
                ),
              ] else ...[
                ...data.members.map((member) {
                  final isCurrent = currentMember?.id == member.id;
                  return MemberCard(
                    member: member,
                    isCurrentMember: isCurrent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MemberProfileScreen(
                            memberId: member.id,
                            appState: widget.appState,
                          ),
                        ),
                      ).then((_) => setState(() {}));
                    },
                  );
                }),
              ],
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.emoji_events_outlined, size: 16, color: AppTheme.accentGreen),
                      const SizedBox(width: 8),
                      Text(
                        "WHAT WE'VE ACCOMPLISHED (${data.accomplishments.length})",
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  if (isAdmin) ...[
                    SleekButton(
                      text: '+ LOG MILESTONE',
                      height: 32,
                      variant: SleekButtonVariant.outline,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddAccomplishmentScreen(appState: widget.appState),
                          ),
                        ).then((_) => setState(() {}));
                      },
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              if (data.accomplishments.isEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: AppTheme.sleekGlassDecoration(),
                  child: Center(
                    child: Text(
                      'No accomplishments logged yet.',
                      style: GoogleFonts.inter(color: AppTheme.textMuted, fontSize: 13),
                    ),
                  ),
                ),
              ] else ...[
                ...data.accomplishments.map((acc) {
                  return AccomplishmentCard(
                    accomplishment: acc,
                    isAdmin: isAdmin,
                    onDelete: isAdmin
                        ? () {
                            widget.appState.removeAccomplishment(acc.id);
                          }
                        : null,
                  );
                }),
              ],
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
