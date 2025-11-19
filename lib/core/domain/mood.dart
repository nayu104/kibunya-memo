import 'package:flutter/material.dart';

enum Mood { happy, calm, tired, fired }

extension MoodProps on Mood {
  String get label {
    switch (this) {
      case Mood.happy:
        return '嬉しい!!';
      case Mood.calm:
        return '落ち着いている。';
      case Mood.tired:
        return 'しんどい...';
      case Mood.fired:
        return 'やる気フルMAX!!!';
    }
  }

  String get emoji {
    switch (this) {
      case Mood.happy:
        return '😄';
      case Mood.calm:
        return '🙂';
      case Mood.tired:
        return '😩';
      case Mood.fired:
        return '🔥';
    }
  }

  Color get color {
    switch (this) {
      case Mood.happy:
        return const Color(0xFFFFE082); // light yellow
      case Mood.calm:
        return const Color(0xFFB3E5FC); // light blue
      case Mood.tired:
        return const Color(0xFFE1F5FE); // pale blue/gray
      case Mood.fired:
        return const Color(0xFFFFCC80); // orange
    }
  }
}
