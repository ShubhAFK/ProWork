import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user_role.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/sleek_button.dart';
import '../widgets/sleek_text_field.dart';

class LoginScreen extends StatefulWidget {
  final AppState appState;

  const LoginScreen({
    super.key,
    required this.appState,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserRole _selectedRole = UserRole.admin;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _memberNameController = TextEditingController();
  String? _selectedMemberId;
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.appState.projectData.members.isNotEmpty) {
      _selectedMemberId = widget.appState.projectData.members.first.id;
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _memberNameController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 300));

    final password = _passwordController.text.trim();
    bool success = false;

    if (_selectedRole == UserRole.admin) {
      success = widget.appState.loginAdmin(password);
      if (!success) {
        setState(() {
          _errorMessage = 'Invalid admin passcode.';
          _isLoading = false;
        });
      }
    } else {
      final name = _memberNameController.text.trim();
      success = widget.appState.loginMember(
        password,
        _selectedMemberId,
        name.isNotEmpty ? name : null,
      );
      if (!success) {
        setState(() {
          _errorMessage = 'Invalid member passcode.';
          _isLoading = false;
        });
      }
    }

    if (mounted && success) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final members = widget.appState.projectData.members;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceSecondary,
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: AppTheme.accentGreen, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.accentGreen.withValues(alpha: 0.35),
                            blurRadius: 24,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'PW',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.accentGreen,
                            letterSpacing: -1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.appState.projectData.projectName,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textPrimary,
                      letterSpacing: -1.0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.appState.projectData.tagline,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildRoleTab(
                            role: UserRole.admin,
                            label: 'Admin Lead',
                            icon: Icons.shield_outlined,
                          ),
                        ),
                        Expanded(
                          child: _buildRoleTab(
                            role: UserRole.member,
                            label: 'Team Member',
                            icon: Icons.people_outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: AppTheme.sleekGlassDecoration(
                      borderColor: _selectedRole == UserRole.admin
                          ? AppTheme.accentGreen.withValues(alpha: 0.3)
                          : AppTheme.accentCyan.withValues(alpha: 0.3),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_selectedRole == UserRole.member) ...[
                          if (members.isNotEmpty) ...[
                            Text(
                              'SELECT YOUR PROFILE',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.1,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceSecondary,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppTheme.border),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedMemberId,
                                  isExpanded: true,
                                  dropdownColor: AppTheme.surfaceElevated,
                                  icon: const Icon(Icons.keyboard_arrow_down,
                                      color: AppTheme.textSecondary),
                                  items: members.map((m) {
                                    return DropdownMenuItem<String>(
                                      value: m.id,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 10,
                                            height: 10,
                                            margin: const EdgeInsets.only(
                                                right: 10),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(m.avatarColorValue),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${m.name} (${m.roleTitle})',
                                              style: GoogleFonts.inter(
                                                fontSize: 13,
                                                color: AppTheme.textPrimary,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      _selectedMemberId = val;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                          ] else ...[
                            SleekTextField(
                              controller: _memberNameController,
                              label: 'Your Full Name',
                              hint: 'Enter your name',
                              prefixIcon: Icons.person_outline,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => _handleLogin(),
                            ),
                            const SizedBox(height: 18),
                          ],
                        ],
                        SleekTextField(
                          controller: _passwordController,
                          label: _selectedRole == UserRole.admin
                              ? 'Admin Passcode'
                              : 'Member Passcode',
                          hint: _selectedRole == UserRole.admin
                              ? 'Enter admin passcode'
                              : 'Enter passcode (default: user2026)',
                          prefixIcon: Icons.lock_outline,
                          isPassword: true,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _handleLogin(),
                        ),
                        if (_errorMessage != null) ...[
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppTheme.accentRed.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: AppTheme.accentRed
                                      .withValues(alpha: 0.4)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline,
                                    size: 16, color: AppTheme.accentRed),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: AppTheme.accentRed),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 22),
                        SleekButton(
                          text: _selectedRole == UserRole.admin
                              ? 'AUTHORIZE AS LEADER'
                              : 'ENTER WORKSPACE',
                          icon: _selectedRole == UserRole.admin
                              ? Icons.vpn_key_outlined
                              : Icons.login_rounded,
                          isLoading: _isLoading,
                          onPressed: _handleLogin,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.android_rounded,
                            size: 14, color: AppTheme.accentGreen),
                        const SizedBox(width: 6),
                        Text(
                          'Native Android & Cross-Platform Engine',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleTab({
    required UserRole role,
    required String label,
    required IconData icon,
  }) {
    final bool isSelected = _selectedRole == role;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = role;
          _errorMessage = null;
          _passwordController.clear();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.surfaceSecondary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? Border.all(
                  color: role == UserRole.admin
                      ? AppTheme.accentGreen
                      : AppTheme.accentCyan,
                  width: 1,
                )
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected
                  ? (role == UserRole.admin
                      ? AppTheme.accentGreen
                      : AppTheme.accentCyan)
                  : AppTheme.textMuted,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppTheme.textPrimary : AppTheme.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
