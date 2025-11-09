import 'package:dailypulse/models/mood_entry.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Add Mood Page
class AddMoodPage extends StatefulWidget {
  final Function(MoodEntry) onSave;

  const AddMoodPage({super.key, required this.onSave});

  @override
  State<AddMoodPage> createState() => _AddMoodPageState();
}

class _AddMoodPageState extends State<AddMoodPage> {
  final _noteController = TextEditingController();
  String? _selectedMood;
  String? _selectedEmoji;
  bool? _isPositive;

  final List<Map<String, dynamic>> _moods = [
    {'emoji': '😊', 'mood': 'Happy', 'positive': true},
    {'emoji': '😄', 'mood': 'Excited', 'positive': true},
    {'emoji': '😌', 'mood': 'Calm', 'positive': true},
    {'emoji': '🥰', 'mood': 'Loved', 'positive': true},
    {'emoji': '😴', 'mood': 'Tired', 'positive': false},
    {'emoji': '😔', 'mood': 'Sad', 'positive': false},
    {'emoji': '😰', 'mood': 'Anxious', 'positive': false},
    {'emoji': '😤', 'mood': 'Frustrated', 'positive': false},
    {'emoji': '😐', 'mood': 'Neutral', 'positive': false},
  ];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _saveMood() {
    if (_selectedMood == null || _selectedEmoji == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a mood')),
      );
      return;
    }

    final entry = MoodEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      emoji: _selectedEmoji!,
      mood: _selectedMood!,
      note: _noteController.text.trim(),
      isPositive: _isPositive!,
    );

    widget.onSave(entry);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mood logged successfully!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Your Mood'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Greeting Card
            Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How are you feeling today?',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('EEEE, MMMM d, y').format(DateTime.now()),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Mood Selection
            Text(
              'Select Your Mood',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _moods.map((mood) {
                final isSelected = _selectedMood == mood['mood'];
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedMood = mood['mood'];
                      _selectedEmoji = mood['emoji'];
                      _isPositive = mood['positive'];
                    });
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(mood['emoji'], style: const TextStyle(fontSize: 24)),
                        const SizedBox(width: 8),
                        Text(
                          mood['mood'],
                          style: TextStyle(
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected
                                ? Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Note Section
            Text(
              'Add a Note (optional)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Write a short note about your mood...',
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Save Button
            ElevatedButton.icon(
              onPressed: _saveMood,
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Save Mood'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}