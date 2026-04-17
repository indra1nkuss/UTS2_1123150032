import 'package:flutter/material.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/services/secure_storage.dart';
import '../../../../core/constants/app_colors.dart'; // Import warna
import '../../../../core/constants/app_strings.dart'; // Import teks

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Memberikan waktu splash screen tampil (2 detik)
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    // Cek token di storage
    final token = await SecureStorageService.getToken();
    
    if (!mounted) return;

    if (token != null) {
      Navigator.pushReplacementNamed(context, AppRouter.dashboard);
    } else {
      Navigator.pushReplacementNamed(context, AppRouter.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Hapus 'const' di sini karena warna/teks bisa berubah
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ganti icon tas menjadi Sepeda untuk tema RentBike
            const Icon(
              Icons.directions_bike_rounded, 
              size: 100, 
              color: AppColors.primary,
            ),
            const SizedBox(height: 20),
            // Mengambil nama aplikasi dari AppStrings
            const Text(
              AppStrings.appName,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            // Menambahkan tagline aplikasi
            Text(
              AppStrings.appTagline,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 48),
            // Loading indicator yang warnanya menyesuaikan tema
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}