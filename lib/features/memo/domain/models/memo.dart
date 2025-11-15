import 'mood.dart';

class Memo {
  final String id;
  final String title;
  final String body;
  final Mood mood;
  final DateTime createdAt;

  Memo({
    required this.id,
    required this.title,
    this.body = '',
    this.mood = Mood.calm,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Memo.fromJson(Map<String, dynamic> json) {
    return Memo(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String? ?? '',
      mood: Mood.values.firstWhere(
        (m) => m.toString() == json['mood'],
        orElse: () => Mood.calm,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'mood': mood.toString(),
    'createdAt': createdAt.toIso8601String(),
  };
}
