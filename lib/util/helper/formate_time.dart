



import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatTimeOfDay(TimeOfDay tod) {
  final now = DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
  return DateFormat('HH:mm').format(dt); // 24-hour format
}


// 7 December,2025
String formatCustomDate(DateTime date) {
  return DateFormat("d MMMM, y").format(date);
}