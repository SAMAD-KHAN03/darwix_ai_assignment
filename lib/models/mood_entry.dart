
// Models
class MoodEntry {
  final String id;
  final DateTime date;
  final String emoji;
  final String mood;
  final String note;
  final bool isPositive;

  MoodEntry({
    required this.id,
    required this.date,
    required this.emoji,
    required this.mood,
    required this.note,
    required this.isPositive,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'emoji': emoji,
    'mood': mood,
    'note': note,
    'isPositive': isPositive,
  };

  factory MoodEntry.fromJson(Map<String, dynamic> json) => MoodEntry(
    id: json['id'],
    date: DateTime.parse(json['date']),
    emoji: json['emoji'],
    mood: json['mood'],
    note: json['note'],
    isPositive: json['isPositive'],
  );
}