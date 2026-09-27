import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/join_queue_screen.dart';
import 'screens/qr_screen.dart';
import 'screens/queue_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  initialRoute: '/',
  routes: {
  '/': (context) => const QRScreen(),
  '/join': (context) => const JoinQueueScreen(),
  '/queue': (context) => const QueueScreen(),
}
);
  }
}