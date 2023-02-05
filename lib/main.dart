import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:telebotman/present/my_app.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}
