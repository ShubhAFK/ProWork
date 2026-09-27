import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/goal.dart';
import '../theme/app_theme.dart';

class GoalCard extends StatelessWidget {
  final Goal goal;
  final bool isAdmin;
  final VoidCallback? onEdit;
  final ValueChanged<String>? onToggleItem;

  const GoalCard({
    super.key,
    required this.goal,
    required this.isAdmin,
    this.onEdit,
    this.onToggleItem,
  });

  Color _getPriorityColor(GoalPriority priority) {
    switch (priority) {
      case GoalPriority.urgent:
        return AppTheme.accentRed;
      case GoalPriority.high:
        return AppTheme.accentYellow;
      case GoalPriority.medium:
        return AppTheme.accentCyan;
      case GoalPriority.low:
        return AppTheme.accentGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    final priorityColor = _getPriorityColor(goal.priority);
    final daysRemaining = goal.targetDate.difference(DateTime.now()).inDays;
    final formattedDate = DateFormat('MMM dd, yyyy').format(goal.targetDate);

    return Container(
      decoration: AppTheme.sleekGlassDecoration(),
      padding: const EdgeInsets.all(20),
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
                    decoration: BoxDecoration(
                      color: priorityColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'CURRENT STRATEGIC GOAL',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: priorityColor.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color: priorityColor.withValues(alpha: 0.4),
                          width: 1),
                    ),
                    child: Text(
                      goal.priority.name.toUpperCase(),
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: priorityColor,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  if (isAdmin && onEdit != null) ...[
                    const SizedBox(width: 8),
                    InkWell(
                      borderRadius: BorderRadius.circular(6),
                      onTap: onEdit,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceSecondary,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.edit_outlined,
                                size: 12, color: AppTheme.accentGreen),
                            const SizedBox(width: 4),
                            Text(
                              'EDIT',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.accentGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            goal.title,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
              height: 1.3,
            ),
          ),
          if (goal.description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              goal.description,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppTheme.textSecondary,
                height: 1.4,
              ),
            ),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined,
                  size: 13, color: AppTheme.textMuted),
              const SizedBox(width: 6),
              Text(
                'Target: $formattedDate',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppTheme.textMuted,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                daysRemaining >= 0
                    ? '$daysRemaining days remaining'
                    : 'Past deadline',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: daysRemaining <= 3
                      ? AppTheme.accentRed
                      : AppTheme.accentCyan,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (goal.checklist.isNotEmpty) ...[
            const SizedBox(height: 18),
            const Divider(color: AppTheme.border, height: 1),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'DELIVERABLES & ROADMAP',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                    color: AppTheme.textSecondary,
                  ),
                ),
                Text(
                  '${goal.completedCount}/${goal.totalChecklistItems}',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.accentGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...goal.checklist.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    if (onToggleItem != null) {
                      onToggleItem!(item.id);
                    }
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          margin: const EdgeInsets.only(top: 2, right: 10),
                          decoration: BoxDecoration(
                            color: item.isCompleted
                                ? AppTheme.accentGreen
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: item.isCompleted
                                  ? AppTheme.accentGreen
                                  : AppTheme.borderGlow,
                              width: 1.5,
                            ),
                          ),
                          child: item.isCompleted
                              ? const Icon(Icons.check,
                                  size: 13, color: Colors.black)
                              : null,
                        ),
                        Expanded(
                          child: Text(
                            item.title,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: item.isCompleted
                                  ? AppTheme.textMuted
                                  : AppTheme.textPrimary,
                              decoration: item.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              decorationColor: AppTheme.textMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}
