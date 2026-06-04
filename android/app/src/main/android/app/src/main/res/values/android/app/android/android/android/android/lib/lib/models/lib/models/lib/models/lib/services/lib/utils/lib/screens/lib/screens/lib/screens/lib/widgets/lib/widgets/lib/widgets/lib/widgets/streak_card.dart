import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class StreakCard extends StatelessWidget {
  final int currentStreak;
  final int longestStreak;

  const StreakCard({
    super.key,
    required this.currentStreak,
    required this.longestStreak,
  });

  String _streakEmoji(int streak) {
    if (streak >= 30) return '🔥🔥🔥';
    if (streak >= 14) return '🔥🔥';
    if (streak >= 7) return '🔥';
    if (streak >= 3) return '⚡';
    return '✨';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatBox(
              label: 'Current Streak',
              value: '$currentStreak',
              suffix: currentStreak == 1 ? ' day' : ' days',
              emoji: _streakEmoji(currentStreak),
              color: currentStreak > 0
                  ? AppTheme.warning
                  : AppTheme.textSecondary,
            ),
          ),
          Container(width: 1, height: 48, color: AppTheme.divider),
          Expanded(
            child: _StatBox(
              label: 'Best Streak',
              value: '$longestStreak',
              suffix: longestStreak == 1 ? ' day' : ' days',
              emoji: '🏆',
              color: AppTheme.accent,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final String suffix;
  final String emoji;
  final Color color;

  const _StatBox({
    required this.label,
    required this.value,
    required this.suffix,
    required this.emoji,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    color: color,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text: suffix,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
