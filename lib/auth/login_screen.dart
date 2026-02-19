import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../core/services/secure_storage_service.dart';
import '../map/map_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _secureStorage = SecureStorageService();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // จำลองโหลด API

    // Mock JWT Token (มีข้อมูล Role: "member")
    const mockJwt =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoibWVtYmVyIiwiZXhwIjoxOTk5OTk5OTk5fQ.signature";

    await _secureStorage.saveToken(mockJwt); // 1. Secure Storage

    // 2. Role-based: ถอดรหัสเพื่อดู Role
    Map<String, dynamic> decodedToken = JwtDecoder.decode(mockJwt);
    String userRole = decodedToken['role'];

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Login สำเร็จ! สิทธิ์ของคุณคือ: $userRole')),
    );

    // พาไปหน้าแผนที่
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MapScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('FuelNear',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue)),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('จำลองเข้าสู่ระบบ (Login)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
