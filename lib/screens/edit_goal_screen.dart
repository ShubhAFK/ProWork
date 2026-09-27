import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/goal.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/sleek_button.dart';
import '../widgets/sleek_text_field.dart';

class EditGoalScreen extends StatefulWidget {
  final AppState appState;

  const EditGoalScreen({
    super.key,
    required this.appState,
  });

  @override
  State<EditGoalScreen> createState() => _EditGoalScreenState();
}

class _EditGoalScreenState extends State<EditGoalScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late DateTime _selectedDate;
  late GoalPriority _selectedPriority;
  late List<GoalCheckItem> _checklist;
  final TextEditingController _newChecklistController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final currentGoal = widget.appState.projectData.currentGoal;
    _titleController = TextEditingController(text: currentGoal.title);
    _descController = TextEditingController(text: currentGoal.description);
    _selectedDate = currentGoal.targetDate;
    _selectedPriority = currentGoal.priority;
    _checklist = List.from(currentGoal.checklist);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _newChecklistController.dispose();
    super.dispose();
  }

  void _addChecklistItem() {
    final text = _newChecklistController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _checklist.add(GoalCheckItem(
          id: 'item_${DateTime.now().millisecondsSinceEpoch}',
          title: text,
          isCompleted: false,
        ));
        _newChecklistController.clear();
      });
    }
  }

  void _saveGoal() {
    final title = _titleController.text.trim();
    if (title.isNotEmpty) {
      final updated = Goal(
        id: widget.appState.projectData.currentGoal.id,
        title: title,
        description: _descController.text.trim(),
        targetDate: _selectedDate,
        priority: _selectedPriority,
        checklist: _checklist,
      );
      widget.appState.updateCurrentGoal(updated);
      Navigator.pop(context);
    }
  }

  Future<void> _pickTargetDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 730)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.accentGreen,
              surface: AppTheme.surfaceElevated,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
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
          icon: const Icon(Icons.close, size: 20, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'UPDATE STRATEGIC GOAL',
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
              label: 'Goal Objective / Title',
              hint: 'e.g. Deliver Phase 2 Alpha Release',
              prefixIcon: Icons.flag_outlined,
            ),
            const SizedBox(height: 16),
            SleekTextField(
              controller: _descController,
              label: 'Strategic Context / Description',
              hint: 'Describe key milestones and outcomes expected',
              maxLines: 3,
            ),
            const SizedBox(height: 18),
            Text(
              'PRIORITY LEVEL',
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
              children: GoalPriority.values.map((priority) {
                final isSel = _selectedPriority == priority;
                Color chipColor;
                switch (priority) {
                  case GoalPriority.urgent:
                    chipColor = AppTheme.accentRed;
                    break;
                  case GoalPriority.high:
                    chipColor = AppTheme.accentYellow;
                    break;
                  case GoalPriority.medium:
                    chipColor = AppTheme.accentCyan;
                    break;
                  case GoalPriority.low:
                    chipColor = AppTheme.accentGreen;
                    break;
                }
                return ChoiceChip(
                  label: Text(
                    priority.name.toUpperCase(),
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isSel ? Colors.black : chipColor,
                    ),
                  ),
                  selected: isSel,
                  selectedColor: chipColor,
                  backgroundColor: AppTheme.surfaceSecondary,
                  onSelected: (_) {
                    setState(() {
                      _selectedPriority = priority;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 18),
            Text(
              'TARGET DEADLINE',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppTheme.textSecondary,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickTargetDate,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined,
                            size: 16, color: AppTheme.accentGreen),
                        const SizedBox(width: 10),
                        Text(
                          DateFormat('EEEE, MMM dd, yyyy')
                              .format(_selectedDate),
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.chevron_right,
                        size: 18, color: AppTheme.textMuted),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'DELIVERABLES CHECKLIST',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textSecondary,
                    letterSpacing: 1.0,
                  ),
                ),
                Text(
                  '${_checklist.where((e) => e.isCompleted).length}/${_checklist.length}',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.accentGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newChecklistController,
                    style: GoogleFonts.inter(
                        color: AppTheme.textPrimary, fontSize: 13),
                    decoration: const InputDecoration(
                      hintText: 'Add new subtask / deliverable',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                    onSubmitted: (_) => _addChecklistItem(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add_circle,
                      color: AppTheme.accentGreen, size: 28),
                  onPressed: _addChecklistItem,
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...List.generate(_checklist.length, (index) {
              final item = _checklist[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: item.isCompleted,
                      activeColor: AppTheme.accentGreen,
                      checkColor: Colors.black,
                      onChanged: (val) {
                        setState(() {
                          _checklist[index] =
                              item.copyWith(isCompleted: val ?? false);
                        });
                      },
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
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          size: 16, color: AppTheme.textMuted),
                      onPressed: () {
                        setState(() {
                          _checklist.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),
            SleekButton(
              text: 'SAVE & BROADCAST GOAL',
              icon: Icons.check,
              onPressed: _saveGoal,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
