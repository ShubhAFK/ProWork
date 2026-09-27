import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/user_role.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String projectName;
  final UserRole? role;
  final String? memberName;
  final VoidCallback onLogout;
  final VoidCallback? onSettings;
  final VoidCallback? onEditProject;
  final VoidCallback? onEditMember;

  const CustomAppBar({
    super.key,
    required this.projectName,
    required this.role,
    this.memberName,
    required this.onLogout,
    this.onSettings,
    this.onEditProject,
    this.onEditMember,
  });

  @override
  Size get preferredSize => const Size.fromHeight(68);

  @override
  Widget build(BuildContext context) {
    final bool isAdmin = role == UserRole.admin;

    return Container(
      padding: const EdgeInsets.only(top: 12, left: 18, right: 18, bottom: 12),
      decoration: const BoxDecoration(
        color: AppTheme.background,
        border: Border(
          bottom: BorderSide(color: AppTheme.border, width: 1),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            GestureDetector(
              onTap: isAdmin ? onEditProject : null,
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceSecondary,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppTheme.accentGreen.withValues(alpha: 0.6),
                          width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.accentGreen.withValues(alpha: 0.2),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'PW',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.accentGreen,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            projectName,
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                          if (isAdmin) ...[
                            const SizedBox(width: 6),
                            const Icon(Icons.edit_outlined,
                                size: 14, color: AppTheme.textSecondary),
                          ],
                        ],
                      ),
                      Text(
                        'PROJECT HUB',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.accentGreen,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: !isAdmin ? onEditMember : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isAdmin
                      ? AppTheme.accentGreen.withValues(alpha: 0.12)
                      : AppTheme.accentCyan.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isAdmin
                        ? AppTheme.accentGreen.withValues(alpha: 0.4)
                        : AppTheme.accentCyan.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            isAdmin ? AppTheme.accentGreen : AppTheme.accentCyan,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isAdmin ? 'ADMIN' : (memberName ?? 'MEMBER').toUpperCase(),
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color:
                            isAdmin ? AppTheme.accentGreen : AppTheme.accentCyan,
                      ),
                    ),
                    if (!isAdmin) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.edit, size: 10, color: AppTheme.accentCyan),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            if (isAdmin && onSettings != null) ...[
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.shield_outlined,
                    size: 19, color: AppTheme.textSecondary),
                tooltip: 'Admin Settings',
                onPressed: onSettings,
              ),
            ],
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.logout_rounded,
                  size: 19, color: AppTheme.textSecondary),
              tooltip: 'Logout',
              onPressed: onLogout,
            ),
          ],
        ),
      ),
    );
  }
}
