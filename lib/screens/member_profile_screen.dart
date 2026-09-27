import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/member.dart';
import '../models/contribution.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/contribution_graph.dart';
import '../widgets/sleek_button.dart';
import '../widgets/sleek_text_field.dart';

class MemberProfileScreen extends StatefulWidget {
  final String memberId;
  final AppState appState;

  const MemberProfileScreen({
    super.key,
    required this.memberId,
    required this.appState,
  });

  @override
  State<MemberProfileScreen> createState() => _MemberProfileScreenState();
}

class _MemberProfileScreenState extends State<MemberProfileScreen> {
  void _showAddContributionModal(BuildContext context, Member member) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    ContributionType selectedType = ContributionType.feature;
    int impactScore = 2;

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
                          'LOG MEMBER CONTRIBUTION',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close,
                              size: 20, color: AppTheme.textSecondary),
                          onPressed: () => Navigator.pop(modalCtx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SleekTextField(
                      controller: titleController,
                      label: 'Contribution Summary',
                      hint: 'e.g. Implemented OAuth provider integration',
                      prefixIcon: Icons.commit_rounded,
                    ),
                    const SizedBox(height: 14),
                    SleekTextField(
                      controller: descController,
                      label: 'Technical Details (Optional)',
                      hint: 'e.g. Added JWT tokens & refresh mechanism',
                      maxLines: 2,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'CATEGORY / TYPE',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textSecondary,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ContributionType.values.map((type) {
                        final isSelected = selectedType == type;
                        return ChoiceChip(
                          label: Text(
                            type.name.toUpperCase(),
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isSelected
                                  ? Colors.black
                                  : AppTheme.textPrimary,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: AppTheme.accentGreen,
                          backgroundColor: AppTheme.surfaceSecondary,
                          onSelected: (_) {
                            setModalState(() {
                              selectedType = type;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Heatmap Impact Weight:',
                          style: GoogleFonts.inter(
                              fontSize: 13, color: AppTheme.textSecondary),
                        ),
                        Row(
                          children: List.generate(4, (index) {
                            final score = index + 1;
                            final isSel = impactScore == score;
                            return GestureDetector(
                              onTap: () {
                                setModalState(() {
                                  impactScore = score;
                                });
                              },
                              child: Container(
                                width: 28,
                                height: 28,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                decoration: BoxDecoration(
                                  color: AppTheme.getContributionColor(score),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: isSel
                                        ? Colors.white
                                        : Colors.transparent,
                                    width: isSel ? 2 : 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '+$score',
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SleekButton(
                      text: 'RECORD TO HEATMAP',
                      icon: Icons.check_circle_outline,
                      onPressed: () {
                        final title = titleController.text.trim();
                        if (title.isNotEmpty) {
                          final contribution = Contribution(
                            id: 'c_${DateTime.now().millisecondsSinceEpoch}',
                            memberId: member.id,
                            title: title,
                            description: descController.text.trim(),
                            timestamp: DateTime.now(),
                            type: selectedType,
                            impactScore: impactScore,
                          );
                          widget.appState
                              .addContributionToMember(member.id, contribution);
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

  void _showEditMemberModal(BuildContext context, Member member) {
    final nameController = TextEditingController(text: member.name);
    final roleController = TextEditingController(text: member.roleTitle);
    final bioController = TextEditingController(text: member.bio);
    int selectedColor = member.avatarColorValue;

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
                          widget.appState.isAdmin
                              ? 'EDIT MEMBER DETAILS'
                              : 'EDIT YOUR PROFILE',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close,
                              size: 20, color: AppTheme.textSecondary),
                          onPressed: () => Navigator.pop(modalCtx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SleekTextField(
                      controller: nameController,
                      label: 'Full Name',
                      prefixIcon: Icons.person_outline,
                    ),
                    const SizedBox(height: 14),
                    SleekTextField(
                      controller: roleController,
                      label: 'Role / Designation',
                      prefixIcon: Icons.badge_outlined,
                    ),
                    const SizedBox(height: 14),
                    SleekTextField(
                      controller: bioController,
                      label: 'Bio / Focus Area',
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
                                color:
                                    isSel ? Colors.white : Colors.transparent,
                                width: isSel ? 2.5 : 1,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    SleekButton(
                      text: 'SAVE CHANGES',
                      onPressed: () {
                        final updated = member.copyWith(
                          name: nameController.text.trim(),
                          roleTitle: roleController.text.trim(),
                          bio: bioController.text.trim(),
                          avatarColorValue: selectedColor,
                        );
                        widget.appState.updateMember(updated);
                        Navigator.pop(modalCtx);
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 10),
                    SleekButton(
                      text: 'CHANGE PASSCODE',
                      variant: SleekButtonVariant.outline,
                      icon: Icons.lock_outline,
                      onPressed: () {
                        Navigator.pop(modalCtx);
                        _showChangePasswordModal(context, member);
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

  void _showChangePasswordModal(BuildContext context, Member member) {
    final oldPassController = TextEditingController();
    final newPassController = TextEditingController();
    String? statusMsg;
    bool isSuccess = false;

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
                          'CHANGE PASSCODE',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close,
                              size: 20, color: AppTheme.textSecondary),
                          onPressed: () => Navigator.pop(modalCtx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Default passcode is "user2026". Enter your current passcode to set your personal passcode.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SleekTextField(
                      controller: oldPassController,
                      label: 'Current Passcode',
                      hint: 'Enter current passcode (default: user2026)',
                      isPassword: true,
                      prefixIcon: Icons.lock_outline,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 14),
                    SleekTextField(
                      controller: newPassController,
                      label: 'New Passcode',
                      hint: 'Enter new personalized passcode',
                      isPassword: true,
                      prefixIcon: Icons.vpn_key_outlined,
                      textInputAction: TextInputAction.done,
                    ),
                    if (statusMsg != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSuccess
                              ? AppTheme.accentGreen.withValues(alpha: 0.12)
                              : AppTheme.accentRed.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSuccess
                                ? AppTheme.accentGreen
                                : AppTheme.accentRed,
                          ),
                        ),
                        child: Text(
                          statusMsg!,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSuccess
                                ? AppTheme.accentGreen
                                : AppTheme.accentRed,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    SleekButton(
                      text: 'UPDATE PASSCODE',
                      onPressed: () {
                        final oldPass = oldPassController.text.trim();
                        final newPass = newPassController.text.trim();
                        if (newPass.isEmpty) {
                          setModalState(() {
                            statusMsg = 'New passcode cannot be empty.';
                            isSuccess = false;
                          });
                          return;
                        }
                        final ok = widget.appState.changeMemberPassword(
                            member.id, oldPass, newPass);
                        if (ok) {
                          setModalState(() {
                            statusMsg = 'Passcode updated successfully!';
                            isSuccess = true;
                          });
                          Future.delayed(const Duration(milliseconds: 700), () {
                            if (mounted && Navigator.canPop(modalCtx)) {
                              Navigator.pop(modalCtx);
                            }
                          });
                        } else {
                          setModalState(() {
                            statusMsg = 'Current passcode does not match.';
                            isSuccess = false;
                          });
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

  void _confirmDeleteMember(BuildContext context, Member member) {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppTheme.border),
          ),
          title: Text(
            'Remove Member',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          content: Text(
            'Are you sure you want to remove ${member.name} from ${widget.appState.projectData.projectName}?',
            style:
                GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: Text(
                'CANCEL',
                style: GoogleFonts.spaceGrotesk(
                    color: AppTheme.textSecondary, fontWeight: FontWeight.w700),
              ),
            ),
            TextButton(
              onPressed: () {
                widget.appState.removeMember(member.id);
                Navigator.pop(dialogCtx);
                Navigator.pop(context);
              },
              child: Text(
                'REMOVE',
                style: GoogleFonts.spaceGrotesk(
                    color: AppTheme.accentRed, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final member = widget.appState.getMemberById(widget.memberId);

    if (member == null) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: const Center(
          child: Text('Member not found',
              style: TextStyle(color: AppTheme.textSecondary)),
        ),
      );
    }

    final avatarColor = Color(member.avatarColorValue);
    final bool isAdmin = widget.appState.isAdmin;
    final bool isCurrentMember = widget.appState.currentMemberId == member.id;
    final bool canEdit = isAdmin || isCurrentMember;
    final formattedJoined = DateFormat('MMMM yyyy').format(member.joinedDate);

    final parts = member.name.trim().split(' ');
    final initials = parts.length >= 2
        ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
        : (member.name.isNotEmpty ? member.name[0].toUpperCase() : 'U');

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              size: 18, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'MEMBER PROFILE',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            color: AppTheme.textSecondary,
          ),
        ),
        actions: [
          if (canEdit) ...[
            IconButton(
              icon: const Icon(Icons.edit_outlined,
                  size: 19, color: AppTheme.accentGreen),
              tooltip: 'Edit Profile',
              onPressed: () => _showEditMemberModal(context, member),
            ),
          ],
          if (isAdmin) ...[
            IconButton(
              icon: const Icon(Icons.delete_outline,
                  size: 19, color: AppTheme.accentRed),
              tooltip: 'Delete Member',
              onPressed: () => _confirmDeleteMember(context, member),
            ),
          ],
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: AppTheme.sleekGlassDecoration(
                borderColor: avatarColor.withValues(alpha: 0.4),
                glowing: true,
              ),
              child: Column(
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.surfaceSecondary,
                      border: Border.all(color: avatarColor, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: avatarColor.withValues(alpha: 0.35),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        initials,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: avatarColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          member.name,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (canEdit) ...[
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () => _showEditMemberModal(context, member),
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceSecondary,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppTheme.border),
                            ),
                            child: const Icon(Icons.edit,
                                size: 13, color: AppTheme.accentGreen),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    member.roleTitle,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.accentGreen,
                    ),
                  ),
                  if (member.bio.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      member.bio,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.calendar_month_outlined,
                          size: 13, color: AppTheme.textMuted),
                      const SizedBox(width: 6),
                      Text(
                        'Member since $formattedJoined',
                        style: GoogleFonts.inter(
                            fontSize: 11, color: AppTheme.textMuted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            ContributionGraph(member: member),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.history_rounded,
                        size: 16, color: AppTheme.accentGreen),
                    const SizedBox(width: 8),
                    Text(
                      'ACTIVITY LOG & COMMITS',
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
                    text: '+ LOG WORK',
                    height: 34,
                    variant: SleekButtonVariant.outline,
                    onPressed: () => _showAddContributionModal(context, member),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            if (member.contributions.isEmpty) ...[
              Container(
                padding: const EdgeInsets.all(24),
                decoration: AppTheme.sleekGlassDecoration(),
                child: Center(
                  child: Text(
                    'No contributions recorded yet.',
                    style: GoogleFonts.inter(
                        fontSize: 13, color: AppTheme.textMuted),
                  ),
                ),
              ),
            ] else ...[
              ...member.contributions.map((c) {
                return _buildContributionItem(c);
              }),
            ],
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildContributionItem(Contribution c) {
    final dateStr = DateFormat('MMM dd, yyyy - hh:mm a').format(c.timestamp);

    IconData typeIcon = Icons.commit_rounded;
    Color typeColor = AppTheme.accentGreen;
    switch (c.type) {
      case ContributionType.feature:
        typeIcon = Icons.add_circle_outline;
        typeColor = AppTheme.accentGreen;
        break;
      case ContributionType.bugfix:
        typeIcon = Icons.bug_report_outlined;
        typeColor = AppTheme.accentRed;
        break;
      case ContributionType.design:
        typeIcon = Icons.palette_outlined;
        typeColor = AppTheme.accentPink;
        break;
      case ContributionType.docs:
        typeIcon = Icons.description_outlined;
        typeColor = AppTheme.accentCyan;
        break;
      case ContributionType.review:
        typeIcon = Icons.rate_review_outlined;
        typeColor = AppTheme.accentYellow;
        break;
      case ContributionType.deployment:
        typeIcon = Icons.cloud_upload_outlined;
        typeColor = AppTheme.accentPurple;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.sleekGlassDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: typeColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(typeIcon, size: 16, color: typeColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: typeColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        c.type.name.toUpperCase(),
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: typeColor,
                        ),
                      ),
                    ),
                    Text(
                      dateStr,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  c.title,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                if (c.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    c.description,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
