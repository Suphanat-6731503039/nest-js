import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    FocusScope.of(context).unfocus();

    // จำลองการเชื่อมต่อ API สมัครสมาชิก
    await Future.delayed(const Duration(seconds: 2));

    // TODO: ตรงนี้คือจุดที่คุณต้องนำ _name, _email, _password ส่งไปให้ Backend หรือ Firebase จริงๆ
    /* ตัวอย่างถ้ายิง API จริง:
      final response = await apiService.register(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );
    */

    if (!mounted) return;
    setState(() => _isLoading = false);

    // แสดงข้อความสำเร็จ
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 10),
            Text('สมัครสมาชิกสำเร็จ! กรุณาเข้าสู่ระบบ'),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
      ),
    );

    // กลับไปหน้า Login
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.blue.shade900),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'สร้างบัญชีใหม่',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'กรอกข้อมูลเพื่อเริ่มต้นใช้งาน FuelNear',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 40),

                  // --- ชื่อ-นามสกุล ---
                  TextFormField(
                    controller: _nameController,
                    decoration: _buildInputDecoration(
                        'ชื่อ-นามสกุล', Icons.person_outline),
                    validator: (value) =>
                        value!.isEmpty ? 'กรุณากรอกชื่อ-นามสกุล' : null,
                  ),
                  const SizedBox(height: 16),

                  // --- อีเมล ---
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        _buildInputDecoration('อีเมล', Icons.email_outlined),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'กรุณากรอกอีเมล';
                      if (!value.contains('@')) return 'รูปแบบอีเมลไม่ถูกต้อง';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // --- รหัสผ่าน ---
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: _buildPasswordDecoration(
                        'รหัสผ่าน',
                        _obscurePassword,
                        () => setState(
                            () => _obscurePassword = !_obscurePassword)),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'กรุณากรอกรหัสผ่าน';
                      if (value.length < 6)
                        return 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // --- ยืนยันรหัสผ่าน ---
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: _buildPasswordDecoration(
                        'ยืนยันรหัสผ่าน',
                        _obscureConfirmPassword,
                        () => setState(() => _obscureConfirmPassword =
                            !_obscureConfirmPassword)),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'กรุณายืนยันรหัสผ่าน';
                      if (value != _passwordController.text)
                        return 'รหัสผ่านไม่ตรงกัน';
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // --- ปุ่ม สมัครสมาชิก ---
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 3),
                          )
                        : const Text(
                            'สมัครสมาชิก',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper Methods สำหรับ UI เพื่อลดโค้ดซ้ำซ้อน ---
  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  InputDecoration _buildPasswordDecoration(
      String label, bool isObscure, VoidCallback toggle) {
    return InputDecoration(
      labelText: label,
      prefixIcon: const Icon(Icons.lock_outline),
      suffixIcon: IconButton(
        icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
        onPressed: toggle,
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }
}
