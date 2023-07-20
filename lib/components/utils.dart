import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../screens/news_detail_screen.dart';

//format date
String formatDate(String dateStr) {
  DateTime date = DateTime.parse(dateStr);
  return DateFormat('dd MMM yyyy').format(date);
}

//format time
String formatTime(String dateStr) {
  DateTime date = DateTime.parse(dateStr);
  return DateFormat('h:mm a').format(date);
}

//SnackBar Function
void showsnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text),
  ));
}