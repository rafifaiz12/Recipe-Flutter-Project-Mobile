import 'package:flutter/material.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Nanti untuk Firebase:
  // await Firebase.initializeApp();

  runApp(const SiResepApp());
}