import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../utils/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final threshold = state.streakThreshold;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 4),
              const Text(
                'Customize your experience',
                style:
                    TextStyle(color: AppTheme.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 28),
              _SectionHeader(label: 'Streak Threshold'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.divider),
                ),
                child: Column(
                  children: [
                    _ThresholdTile(
                      value: 80,
                      selected: threshold == 80,
                      description: 'Reach 80% daily to keep streak',
                      onTap: () => state.setStreakThreshold(80),
                    ),
                    const Divider(height: 1, indent: 16),
                    _ThresholdTile(
                      value: 90,
                      selected: threshold == 90,
                      description: 'Reach 90% daily to keep streak',
                      onTap: () => state.setStreakThreshold(90),
                    ),
                    const Divider(height: 1, indent: 16),
                    _ThresholdTile(
                      value: 100,
                      selected: threshold == 100,
                      description: 'Complete everything to keep streak',
                      onTap: () => state.setStreakThreshold(100),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _SectionHeader(label: 'Statistics'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.divider),
                ),
                child: Column(
                  children: [
                    _InfoTile(
                      icon: Icons.local_fire_department_rounded,
                      label: 'Current Streak',
                      value: '${state.currentStreak} days',
                      color: AppTheme.warning,
                    ),
                    const Divider(height: 1, indent: 16),
                    _InfoTile(
                      icon: Icons.emoji_events_rounded,
                      label: 'Longest Streak',
                      value: '${state.longestStreak} days',
                      color: AppTheme.accent,
                    ),
                    const Divider(height: 1, indent: 16),
                    _InfoTile(
                      icon: Icons.task_alt_rounded,
                      label: 'Total Tasks',
                      value: '${state.tasks.length}',
                      color: AppTheme.success,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _SectionHeader(label: 'About'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppTheme.accent.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.track_changes_rounded,
                            color: AppTheme.accent,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Work Track',
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Mission 100 — v1.0.0',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Work Track is a student-focused daily progress tracker. Add tasks with weights, mark them complete, and build a daily streak. All data is stored locally — no account needed.',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        color: AppTheme.textSecondary,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _ThresholdTile extends StatelessWidget {
  final int value;
  final bool selected;
  final String description;
  final VoidCallback onTap;

  const _ThresholdTile({
    required this.value,
    required this.selected,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppTheme.accent : Colors.transparent,
                border: Border.all(
                  color: selected
                      ? AppTheme.accent
                      : AppTheme.textSecondary,
                  width: 2,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$value% threshold',
                    style: TextStyle(
                      color: selected
                          ? AppTheme.textPrimary
                          : AppTheme.textSecondary,
                      fontSize: 15,
                      fontWeight: selected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                  Text(
                    description,
                    style: const TextStyle(
                        color: AppTheme.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 14),
          Expanded(
            child: Text(label,
                style: const TextStyle(
                    color: AppTheme.textPrimary, fontSize: 15)),
          ),
          Text(value,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              )),
        ],
      ),
    );
  }
}
