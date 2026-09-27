import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/accomplishment.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/sleek_button.dart';
import '../widgets/sleek_text_field.dart';

class AddAccomplishmentScreen extends StatefulWidget {
  final AppState appState;

  const AddAccomplishmentScreen({
    super.key,
    required this.appState,
  });

  @override
  State<AddAccomplishmentScreen> createState() =>
      _AddAccomplishmentScreenState();
}

class _AddAccomplishmentScreenState extends State<AddAccomplishmentScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String _selectedCategory = 'Milestone';
  String _selectedImpact = 'High Impact';
  final DateTime _completedDate = DateTime.now();
  final Set<String> _selectedContributors = {};

  final List<String> _categories = [
    'Milestone',
    'Feature',
    'Architecture',
    'Security & Auth',
    'UI Components',
    'DevOps',
    'Optimization',
  ];

  final List<String> _impactTags = [
    'Core Feature',
    'High Impact',
    'Major',
    'Critical Fix',
    'Polish',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _saveAccomplishment() {
    final title = _titleController.text.trim();
    if (title.isNotEmpty) {
      final accomplishment = Accomplishment(
        id: 'acc_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        description: _descController.text.trim(),
        completedAt: _completedDate,
        contributorNames: _selectedContributors.toList(),
        category: _selectedCategory,
        impactTag: _selectedImpact,
      );
      widget.appState.addAccomplishment(accomplishment);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final members = widget.appState.projectData.members;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, size: 20, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'LOG TEAM ACCOMPLISHMENT',
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
            SleekTextField(
              controller: _titleController,
              label: 'Accomplishment Headline',
              hint: 'e.g. Completed Zero-Latency State Engine',
              prefixIcon: Icons.emoji_events_outlined,
            ),
            const SizedBox(height: 16),
            SleekTextField(
              controller: _descController,
              label: 'Impact & Execution Details',
              hint: 'Describe what was accomplished and team results',
              maxLines: 3,
            ),
            const SizedBox(height: 18),
            Text(
              'CATEGORY',
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
              children: _categories.map((cat) {
                final isSel = _selectedCategory == cat;
                return ChoiceChip(
                  label: Text(
                    cat.toUpperCase(),
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: isSel ? Colors.black : AppTheme.textPrimary,
                    ),
                  ),
                  selected: isSel,
                  selectedColor: AppTheme.accentCyan,
                  backgroundColor: AppTheme.surfaceSecondary,
                  onSelected: (_) {
                    setState(() {
                      _selectedCategory = cat;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 18),
            Text(
              'IMPACT BADGE',
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
              children: _impactTags.map((tag) {
                final isSel = _selectedImpact == tag;
                return ChoiceChip(
                  label: Text(
                    tag,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: isSel ? Colors.black : AppTheme.accentGreen,
                    ),
                  ),
                  selected: isSel,
                  selectedColor: AppTheme.accentGreen,
                  backgroundColor: AppTheme.surfaceSecondary,
                  onSelected: (_) {
                    setState(() {
                      _selectedImpact = tag;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 18),
            Text(
              'CONTRIBUTORS ATTRIBUTION',
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
              children: members.map((m) {
                final isSel = _selectedContributors.contains(m.name);
                return FilterChip(
                  label: Text(
                    m.name,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSel ? Colors.black : AppTheme.textPrimary,
                    ),
                  ),
                  selected: isSel,
                  selectedColor: AppTheme.accentGreen,
                  backgroundColor: AppTheme.surfaceSecondary,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedContributors.add(m.name);
                      } else {
                        _selectedContributors.remove(m.name);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            SleekButton(
              text: 'PUBLISH ACCOMPLISHMENT',
              icon: Icons.check_circle_outline,
              onPressed: _saveAccomplishment,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
