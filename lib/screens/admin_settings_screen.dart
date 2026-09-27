import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/sleek_button.dart';
import '../widgets/sleek_text_field.dart';

class AdminSettingsScreen extends StatefulWidget {
  final AppState appState;

  const AdminSettingsScreen({
    super.key,
    required this.appState,
  });

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  late TextEditingController _projectNameController;
  late TextEditingController _taglineController;
  final TextEditingController _oldAdminPassController = TextEditingController();
  final TextEditingController _newAdminPassController = TextEditingController();
  late TextEditingController _memberPassController;

  String? _statusMessage;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    final data = widget.appState.projectData;
    _projectNameController = TextEditingController(text: data.projectName);
    _taglineController = TextEditingController(text: data.tagline);
    _memberPassController = TextEditingController(text: data.memberPassword);
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    _taglineController.dispose();
    _oldAdminPassController.dispose();
    _newAdminPassController.dispose();
    _memberPassController.dispose();
    super.dispose();
  }

  void _saveProjectDetails() {
    final name = _projectNameController.text.trim();
    final tagline = _taglineController.text.trim();
    if (name.isNotEmpty) {
      widget.appState.updateProjectName(name);
      widget.appState.projectData.tagline = tagline;
      setState(() {
        _statusMessage = 'Project details updated successfully.';
        _isSuccess = true;
      });
    }
  }

  void _changeAdminPassword() {
    final oldPass = _oldAdminPassController.text.trim();
    final newPass = _newAdminPassController.text.trim();

    if (newPass.isEmpty) {
      setState(() {
        _statusMessage = 'New password cannot be empty.';
        _isSuccess = false;
      });
      return;
    }

    final ok = widget.appState.changeAdminPassword(oldPass, newPass);
    if (ok) {
      setState(() {
        _oldAdminPassController.clear();
        _newAdminPassController.clear();
        _statusMessage = 'Admin password changed successfully!';
        _isSuccess = true;
      });
    } else {
      setState(() {
        _statusMessage = 'Current admin password does not match.';
        _isSuccess = false;
      });
    }
  }

  void _updateMemberPassword() {
    final newPass = _memberPassController.text.trim();
    if (newPass.isNotEmpty) {
      widget.appState.projectData.memberPassword = newPass;
      setState(() {
        _statusMessage = 'Member passcode updated to "$newPass"';
        _isSuccess = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          'ADMIN CONTROLS & SECURITY',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            color: AppTheme.textSecondary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_statusMessage != null) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _isSuccess
                      ? AppTheme.accentGreen.withValues(alpha: 0.12)
                      : AppTheme.accentRed.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color:
                        _isSuccess ? AppTheme.accentGreen : AppTheme.accentRed,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isSuccess ? Icons.check_circle : Icons.error_outline,
                      size: 18,
                      color: _isSuccess
                          ? AppTheme.accentGreen
                          : AppTheme.accentRed,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _statusMessage!,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _isSuccess
                              ? AppTheme.accentGreen
                              : AppTheme.accentRed,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            Container(
              padding: const EdgeInsets.all(20),
              decoration: AppTheme.sleekGlassDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.edit_note_rounded,
                          size: 16, color: AppTheme.accentGreen),
                      const SizedBox(width: 8),
                      Text(
                        'PROJECT IDENTITY',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SleekTextField(
                    controller: _projectNameController,
                    label: 'Project Name (Default: ProWork)',
                    prefixIcon: Icons.folder_outlined,
                  ),
                  const SizedBox(height: 14),
                  SleekTextField(
                    controller: _taglineController,
                    label: 'Tagline / Focus',
                    prefixIcon: Icons.description_outlined,
                  ),
                  const SizedBox(height: 16),
                  SleekButton(
                    text: 'UPDATE PROJECT INFO',
                    onPressed: _saveProjectDetails,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: AppTheme.sleekGlassDecoration(
                  borderColor: AppTheme.accentGreen.withValues(alpha: 0.3)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.shield_outlined,
                          size: 16, color: AppTheme.accentGreen),
                      const SizedBox(width: 8),
                      Text(
                        'CHANGE ADMIN PASSCODE',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Default passcode is "ro696969ho". Change it below to lock your leader privileges.',
                    style: GoogleFonts.inter(
                        fontSize: 12, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 14),
                  SleekTextField(
                    controller: _oldAdminPassController,
                    label: 'Current Admin Passcode',
                    hint: 'Enter ro696969ho or current pass',
                    isPassword: true,
                    prefixIcon: Icons.lock_outline,
                  ),
                  const SizedBox(height: 14),
                  SleekTextField(
                    controller: _newAdminPassController,
                    label: 'New Admin Passcode',
                    hint: 'Enter your new secure passcode',
                    isPassword: true,
                    prefixIcon: Icons.vpn_key_outlined,
                  ),
                  const SizedBox(height: 16),
                  SleekButton(
                    text: 'UPDATE ADMIN PASSCODE',
                    variant: SleekButtonVariant.outline,
                    onPressed: _changeAdminPassword,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: AppTheme.sleekGlassDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.people_alt_outlined,
                          size: 16, color: AppTheme.accentCyan),
                      const SizedBox(width: 8),
                      Text(
                        'TEAM MEMBER PASSCODE',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Default member passcode is "user2026". All team members use this to access the shared workspace.',
                    style: GoogleFonts.inter(
                        fontSize: 12, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 14),
                  SleekTextField(
                    controller: _memberPassController,
                    label: 'Shared Member Passcode',
                    isPassword: true,
                    prefixIcon: Icons.group_outlined,
                  ),
                  const SizedBox(height: 16),
                  SleekButton(
                    text: 'SET MEMBER PASSCODE',
                    variant: SleekButtonVariant.secondary,
                    onPressed: _updateMemberPassword,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
