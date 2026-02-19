import 'package:flutter/material.dart';
import '../../core/services/secure_storage_service.dart';
import '../auth/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final secureStorage = SecureStorageService();
    await secureStorage.deleteToken(); // ลบ Token

    if (!context.mounted) return;
    // เด้งกลับไปหน้า Login และล้างประวัติหน้าจอทั้งหมด
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ตั้งค่าบัญชี'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blue,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text(
            'ผู้ใช้งานระบบ (Mock User)',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Text(
            'สิทธิ์การใช้งาน: Member', // ดึงจาก JWT ในแอปจริง
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const Divider(height: 40),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('ประวัติการเดินทาง'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('ฟีเจอร์นี้จะมาในอนาคต!')));
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('เปลี่ยนภาษา'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          const Divider(height: 40),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade50,
              foregroundColor: Colors.red,
            ),
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            label: const Text('ออกจากระบบ'),
          ),
        ],
      ),
    );
  }
}
