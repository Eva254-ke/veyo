import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // For loading .env variables
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from the .env file before app starts
  await dotenv.load(fileName: ".env");

  // Initialize Firebase before running the app
  await Firebase.initializeApp();

  runApp(const NairobiGoApp());
}
