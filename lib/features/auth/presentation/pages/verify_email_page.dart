import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});
  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  late final AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _authProvider = context.read<AuthProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authProvider.startVerificationCheck(() {
        if (mounted) Navigator.pushReplacementNamed(context, '/dashboard');
      });
    });
  }

  @override
  void dispose() {
    // Memanggil stopCheck langsung dari referensi provider yang sudah disimpan
    _authProvider.stopCheck();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.email, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            const Text('Cek Email Anda untuk Verifikasi', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
            TextButton(
              onPressed: () {
                context.read<AuthProvider>().logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Batal'),
            )
          ],
        ),
      ),
    );
  }
}