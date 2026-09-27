import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/member.dart';
import '../theme/app_theme.dart';

class ContributionGraph extends StatefulWidget {
  final Member member;
  final int weeksToShow;

  const ContributionGraph({
    super.key,
    required this.member,
    this.weeksToShow = 26,
  });

  @override
  State<ContributionGraph> createState() => _ContributionGraphState();
}

class _ContributionGraphState extends State<ContributionGraph> {
  DateTime? _selectedDate;
  int? _selectedCount;

  @override
  Widget build(BuildContext context) {
    final dailyMap = widget.member.dailyContributionCounts;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final int totalDays = widget.weeksToShow * 7;
    final startDate = today.subtract(Duration(days: totalDays - 1));
    final firstDayOfWeek = startDate.weekday % 7;
    final adjustedStartDate =
        startDate.subtract(Duration(days: firstDayOfWeek));

    final List<List<DateTime>> weeks = [];
    DateTime currentCursor = adjustedStartDate;

    while (currentCursor.isBefore(today) ||
        currentCursor.isAtSameMomentAs(today) ||
        weeks.length < widget.weeksToShow) {
      final List<DateTime> week = [];
      for (int day = 0; day < 7; day++) {
        week.add(currentCursor);
        currentCursor = currentCursor.add(const Duration(days: 1));
      }
      weeks.add(week);
      if (week.any((d) => d.isAfter(today)) &&
          weeks.length >= widget.weeksToShow) {
        break;
      }
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: AppTheme.sleekGlassDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.grid_view_rounded,
                      size: 14, color: AppTheme.accentGreen),
                  const SizedBox(width: 8),
                  Text(
                    'CONTRIBUTION MATRIX',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.1,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildMetricPill(
                    icon: Icons.local_fire_department_rounded,
                    label: '${widget.member.currentStreak}d Streak',
                    color: AppTheme.accentYellow,
                  ),
                  const SizedBox(width: 8),
                  _buildMetricPill(
                    icon: Icons.commit_rounded,
                    label: '${widget.member.totalContributions} Total',
                    color: AppTheme.accentGreen,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_selectedDate != null) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.surfaceSecondary,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: AppTheme.accentGreen.withValues(alpha: 0.5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('EEEE, MMM dd, yyyy').format(_selectedDate!),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${_selectedCount ?? 0} ${_selectedCount == 1 ? "contribution" : "contributions"}',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.accentGreen,
                    ),
                  ),
                ],
              ),
            ),
          ],
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            physics: const BouncingScrollPhysics(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 6, top: 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDayLabel(''),
                      _buildDayLabel('Mon'),
                      _buildDayLabel(''),
                      _buildDayLabel('Wed'),
                      _buildDayLabel(''),
                      _buildDayLabel('Fri'),
                      _buildDayLabel(''),
                    ],
                  ),
                ),
                ...weeks.map((week) {
                  return Column(
                    children: week.map((date) {
                      final isFuture = date.isAfter(today);
                      final normalized =
                          DateTime(date.year, date.month, date.day);
                      final count = dailyMap[normalized] ?? 0;
                      final isSelected = _selectedDate != null &&
                          _selectedDate!.year == date.year &&
                          _selectedDate!.month == date.month &&
                          _selectedDate!.day == date.day;

                      return GestureDetector(
                        onTap: isFuture
                            ? null
                            : () {
                                setState(() {
                                  _selectedDate = date;
                                  _selectedCount = count;
                                });
                              },
                        child: Container(
                          width: 14,
                          height: 14,
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: isFuture
                                ? Colors.transparent
                                : AppTheme.getContributionColor(count),
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.white
                                  : (isFuture
                                      ? Colors.transparent
                                      : const Color(0x33FFFFFF)),
                              width: isSelected ? 1.5 : 0.5,
                            ),
                            boxShadow: count > 2
                                ? [
                                    BoxShadow(
                                      color: AppTheme.accentGreen
                                          .withValues(alpha: 0.3),
                                      blurRadius: 4,
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Learn how we count contributions',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: AppTheme.textMuted,
                ),
              ),
              Row(
                children: [
                  Text(
                    'Less',
                    style: GoogleFonts.inter(
                        fontSize: 10, color: AppTheme.textMuted),
                  ),
                  const SizedBox(width: 4),
                  _buildLegendBox(AppTheme.ghEmpty),
                  _buildLegendBox(AppTheme.ghLevel1),
                  _buildLegendBox(AppTheme.ghLevel2),
                  _buildLegendBox(AppTheme.ghLevel3),
                  _buildLegendBox(AppTheme.ghLevel4),
                  const SizedBox(width: 4),
                  Text(
                    'More',
                    style: GoogleFonts.inter(
                        fontSize: 10, color: AppTheme.textMuted),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricPill({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayLabel(String label) {
    return Container(
      height: 14,
      margin: const EdgeInsets.symmetric(vertical: 2),
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 8,
          color: AppTheme.textMuted,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildLegendBox(Color color) {
    return Container(
      width: 10,
      height: 10,
      margin: const EdgeInsets.symmetric(horizontal: 1.5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: const Color(0x33FFFFFF), width: 0.5),
      ),
    );
  }
}
