import 'package:flutter/material.dart';
// 1. อย่าลืม Import Riverpod
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth/login_screen.dart';

void main() {
  // 2. เอา ProviderScope มาครอบ FuelNearApp() ตรงนี้ครับ
  runApp(const ProviderScope(child: FuelNearApp()));
}

class FuelNearApp extends StatelessWidget {
  const FuelNearApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FuelNear',
      debugShowCheckedModeBanner: false, // ปิดแถบ Debug แดงๆ มุมขวาบน
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
