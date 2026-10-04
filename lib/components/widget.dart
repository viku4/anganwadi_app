import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<String?> pickEndDate(BuildContext context, {String? firstDate}) async {
  DateTime? dt;

  if (firstDate != null && firstDate.isNotEmpty) {
    dt = DateFormat('dd/MM/yyyy').parse(firstDate);
  }
  final picked = await showDatePicker(
    context: context,
    initialDate: dt ?? DateTime.now(),
    firstDate: dt ?? DateTime(2000),
    lastDate: DateTime(2100),
  );

  if (picked == null) return null;

  return DateFormat('dd/MM/yyyy').format(picked);
}

Future<String?> pickTime(BuildContext context) async {
  final picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );

  if (picked == null) return null;

  final now = DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);

  return DateFormat('HH:mm:ss').format(dt.copyWith(second: 0));
}

Map<String, int> getDateTimeDifference({
  required String startDate,
  required String endDate,
  required String startTime,
  required String endTime,
}) {
  final formatter = DateFormat("dd MMM yyyy hh:mm a");

  final start = formatter.parse("$startDate $startTime");
  final end = formatter.parse("$endDate $endTime");

  final duration = end.difference(start);

  return {
    "hours": duration.inHours,
    "days": duration.inDays,
    "nights": duration.inDays,
  };
}

double fullWidth(BuildContext context) => MediaQuery.of(context).size.width;

double fullHeight(BuildContext context) => MediaQuery.of(context).size.height;

String formatDate(String? date) {
  if (date == null || date.isEmpty) return "";

  try {
    return DateFormat("dd MMM yyyy").format(DateTime.parse(date));
  } catch (e) {
    return date;
  }
}

String getCurrentTime() {
  return DateFormat('hh:mm a').format(DateTime.now());
}

int calculateLateHours({
  required String checkOutDate,
  required String checkOutTime,
}) {
  DateTime now = DateTime.now();

  DateTime outDate = DateTime.parse(checkOutDate);
  DateTime outTime = DateFormat("hh:mm a").parse(checkOutTime);

  DateTime checkOut = DateTime(
    outDate.year,
    outDate.month,
    outDate.day,
    outTime.hour,
    outTime.minute,
  );

  if (now.isBefore(checkOut)) return 0;

  final diff = now.difference(checkOut);

  return diff.inHours;
}

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
}
