import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../utils/app_theme.dart';
import '../widgets/progress_circle.dart';
import '../widgets/task_tile.dart';
import '../widgets/streak_card.dart';
import '../widgets/task_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showAddDialog(BuildContext context) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => const TaskDialog(),
    );
    if (result != null && context.mounted) {
      await context.read<AppState>().addTask(
            result['name'] as String,
            result['weight'] as double,
          );
    }
  }

  void _showEditDialog(BuildContext context, task) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => TaskDialog(task: task),
    );
    if (result != null && context.mounted) {
      await context.read<AppState>().updateTask(
            task.id,
            result['name'] as String,
            result['weight'] as double,
          );
    }
  }

  void _confirmDelete(BuildContext context, task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Task',
            style: TextStyle(color: AppTheme.textPrimary)),
        content: Text(
          'Delete "${task.name}"? This cannot be undone.',
          style: const TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel',
                style: TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: AppTheme.danger),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await context.read<AppState>().deleteTask(task.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final data = state.data;
    final tasks = data.tasks;
    final pct = data.completionPercentage;
    final completedCount = tasks.where((t) => t.isCompleted).length;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mission 100',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge
                                  ?.copyWith(
                                    color: AppTheme.accent,
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                            const Text(
                              'Daily Progress Tracker',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.card,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppTheme.divider),
                          ),
                          child: Text(
                            '$completedCount/${tasks.length} done',
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Center(child: ProgressCircle(percentage: pct)),
                    const SizedBox(height: 20),
                    StreakCard(
                      currentStreak: state.currentStreak,
                      longestStreak: state.longestStreak,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Today's Tasks",
                            style: Theme.of(context).textTheme.titleLarge),
                        if (tasks.isNotEmpty)
                          Text(
                            'Total weight: ${data.totalWeight % 1 == 0 ? data.totalWeight.toInt() : data.totalWeight}',
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            if (tasks.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppTheme.card,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add_task,
                              size: 36, color: AppTheme.textSecondary),
                        ),
                        const SizedBox(height: 16),
                        const Text('No tasks yet',
                            style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        const Text('Add your first task to start tracking',
                            style: TextStyle(
                                color: AppTheme.textSecondary, fontSize: 14)),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) {
                      final task = tasks[i];
                      return TaskTile(
                        task: task,
                        appData: data,
                        onToggle: () => state.toggleTask(task.id),
                        onEdit: () => _showEditDialog(context, task),
                        onDelete: () => _confirmDelete(context, task),
                      );
                    },
                    childCount: tasks.length,
                  ),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Task',
            style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}
