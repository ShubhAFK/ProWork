import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class ProgressRingCard extends StatelessWidget {
  final double progress;
  final int totalGoalsCount;
  final int completedGoalsCount;
  final int membersCount;
  final bool isAdmin;
  final ValueChanged<double>? onProgressChanged;

  const ProgressRingCard({
    super.key,
    required this.progress,
    required this.totalGoalsCount,
    required this.completedGoalsCount,
    required this.membersCount,
    this.isAdmin = false,
    this.onProgressChanged,
  });

  @override
  Widget build(BuildContext context) {
    final int percentage = (progress * 100).round();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.sleekGlassDecoration(
        glowing: true,
        borderColor: AppTheme.accentGreen,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppTheme.accentGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'OVERALL PROJECT VELOCITY',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.accentGreen.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'PHASE ACTIVE',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.accentGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 90,
                    height: 90,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 8,
                      backgroundColor: AppTheme.surfaceSecondary,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppTheme.accentGreen),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$percentage%',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        'DONE',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: [
                    _buildStatRow(
                      icon: Icons.check_circle_outline,
                      label: 'Checklist Items',
                      value: '$completedGoalsCount / $totalGoalsCount',
                      color: AppTheme.accentCyan,
                    ),
                    const SizedBox(height: 10),
                    _buildStatRow(
                      icon: Icons.people_outline,
                      label: 'Active Teammates',
                      value: '$membersCount Devs',
                      color: AppTheme.accentPurple,
                    ),
                    const SizedBox(height: 10),
                    _buildStatRow(
                      icon: Icons.bolt_outlined,
                      label: 'Sprint Health',
                      value: 'Optimal 98%',
                      color: AppTheme.accentGreen,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isAdmin && onProgressChanged != null) ...[
            const SizedBox(height: 16),
            const Divider(color: AppTheme.border, height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'Fine-tune Velocity:',
                  style: GoogleFonts.inter(
                      fontSize: 12, color: AppTheme.textSecondary),
                ),
                Expanded(
                  child: SliderTheme(
                    data: const SliderThemeData(
                      activeTrackColor: AppTheme.accentGreen,
                      inactiveTrackColor: AppTheme.surfaceSecondary,
                      thumbColor: AppTheme.accentGreen,
                      trackHeight: 3,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 12),
                    ),
                    child: Slider(
                      value: progress,
                      min: 0.0,
                      max: 1.0,
                      onChanged: onProgressChanged,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(icon, size: 15, color: color),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}