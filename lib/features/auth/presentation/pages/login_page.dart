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
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: _pass, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: auth.isLoading ? null : () async {
                await context.read<AuthProvider>().login(_email.text, _pass.text);
                final status = context.read<AuthProvider>().status;
                if (status == AuthStatus.authenticated) Navigator.pushReplacementNamed(context, '/dashboard');
                if (status == AuthStatus.emailNotVerified) Navigator.pushReplacementNamed(context, '/verify');
              },
              child: auth.isLoading ? const CircularProgressIndicator() : const Text('Login'),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/register'), 
              child: const Text('Belum punya akun? Daftar')
            )
          ],
        ),
      ),
    );
  }
}