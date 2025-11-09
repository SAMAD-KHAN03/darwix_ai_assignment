
import 'package:dailypulse/models/mood_entry.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class DashboardScreen extends StatelessWidget {
  final List<MoodEntry> entries;

  const DashboardScreen({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayEntry = entries.where((e) =>
        e.date.year == today.year &&
        e.date.month == today.month &&
        e.date.day == today.day).firstOrNull;

    final recentEntries = entries.take(5).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeCard(context, todayEntry),
          const SizedBox(height: 24),
          _buildQuickStats(context),
          const SizedBox(height: 24),
          if (recentEntries.isNotEmpty) ...[
            Text(
              'Recent Entries',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            ...recentEntries.map((entry) => _buildMoodCard(context, entry)),
          ] else
            Center(
              child: Text(
                'No recent entries yet.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ),
        ],
      ),
    );
  }

  // ===================== Helper Widgets =====================

  Widget _buildWelcomeCard(BuildContext context, MoodEntry? todayEntry) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good ${_getGreeting()}!',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              DateFormat('EEEE, MMMM d, y').format(DateTime.now()),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),
            if (todayEntry != null)
              Row(
                children: [
                  Text(
                    todayEntry.emoji,
                    style: const TextStyle(fontSize: 48),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Today's Mood: ${todayEntry.mood}",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        if (todayEntry.note.isNotEmpty)
                          Text(
                            todayEntry.note,
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              )
            else
              Text(
                "You haven’t logged your mood today. How are you feeling?",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    final positiveCount = entries.where((e) => e.isPositive).length;
    final streak = _calculateStreak();

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.calendar_today,
            value: entries.length.toString(),
            label: 'Total Entries',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.sentiment_satisfied_alt,
            value: positiveCount.toString(),
            label: 'Positive Days',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.local_fire_department,
            value: streak.toString(),
            label: 'Day Streak',
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodCard(BuildContext context, MoodEntry entry) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: entry.isPositive
              ? Colors.green.withOpacity(0.2)
              : Colors.orange.withOpacity(0.2),
          child: Text(entry.emoji, style: const TextStyle(fontSize: 24)),
        ),
        title: Text(entry.mood, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateFormat('MMM d, y').format(entry.date)),
            if (entry.note.isNotEmpty)
              Text(entry.note, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
        isThreeLine: entry.note.isNotEmpty,
      ),
    );
  }

  // ===================== Helper Functions =====================

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 17) return 'afternoon';
    return 'evening';
  }

  int _calculateStreak() {
    if (entries.isEmpty) return 0;
    int streak = 1;
    final sortedEntries = List<MoodEntry>.from(entries)
      ..sort((a, b) => b.date.compareTo(a.date));

    for (int i = 0; i < sortedEntries.length - 1; i++) {
      final diff = sortedEntries[i].date.difference(sortedEntries[i + 1].date).inDays;
      if (diff == 1) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }
}