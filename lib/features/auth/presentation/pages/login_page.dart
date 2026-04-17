import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final _email = TextEditingController();
  final _pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: Colors.grey[50], // Latar belakang abu terang serasi dashboard
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Aplikasi
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue[900],
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))
                  ]
                ),
                child: const Icon(Icons.directions_bike_rounded, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 24),
              const Text(
                'RentBike Premium',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.black87, letterSpacing: 1.0),
              ),
              const SizedBox(height: 8),
              Text(
                'Masuk dan mulai menyewa sepeda impianmu.',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 40),
              
              // Kotak Form Modern
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 20, spreadRadius: 5, offset: const Offset(0, 10))
                  ]
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _email,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined, color: Colors.blue[800]),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.blue.shade900, width: 2)),
                      )
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _pass,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline, color: Colors.blue[800]),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.blue.shade900, width: 2)),
                      )
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[900],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        onPressed: auth.isLoading ? null : () async {
                          await context.read<AuthProvider>().login(_email.text, _pass.text);
                          if (!context.mounted) return;
                          
                          final status = context.read<AuthProvider>().status;
                          if (status == AuthStatus.authenticated) {
                            Navigator.pushReplacementNamed(context, '/dashboard');
                          } else if (status == AuthStatus.emailNotVerified) {
                            Navigator.pushReplacementNamed(context, '/verify');
                          }
                        },
                        child: auth.isLoading 
                            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3)) 
                            : const Text('MASUK', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Tombol Daftar
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/register'), 
                child: RichText(
                  text: TextSpan(
                    text: 'Belum punya akun? ',
                    style: TextStyle(color: Colors.grey[600]),
                    children: [
                      TextSpan(text: 'Daftar Sekarang', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900]))
                    ]
                  ),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}