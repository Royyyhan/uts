import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/providers/parking_provider.dart';
import 'presentation/screens/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ParkingProvider()),
      ],
      child: const SmartParkingApp(),
    ),
  );
}

class SmartParkingApp extends StatelessWidget {
  const SmartParkingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Parking',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF1a1c29),
        fontFamily: 'Inter', // Assuming Inter is standard, otherwise defaults
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
