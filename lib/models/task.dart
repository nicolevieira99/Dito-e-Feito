import 'package:flutter/material.dart';

class Task {
  String title;
  Color color;
  String urgency;
  bool isDone;

  Task({
    required this.title,
    required this.color,
    required this.urgency,
    this.isDone = false,
  });
}
