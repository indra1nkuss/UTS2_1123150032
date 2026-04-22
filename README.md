# 🚲 RentBike Premium — Flutter App
### UTS Mobile Lanjutan | NIM: 1123150032

Aplikasi mobile **RentBike Premium** adalah platform sewa sepeda berbasis Flutter yang terhubung ke backend Golang dan Firebase Authentication. Dibangun dengan arsitektur Clean Architecture (Domain → Data → Presentation) dan state management menggunakan Provider.

---

## 📁 Struktur Folder Proyek

```
lib/
├── main.dart                          # Entry point aplikasi
├── firebase_options.dart              # Konfigurasi Firebase (auto-generated)
│
├── core/                              # Fondasi & komponen global
│   ├── constants/
│   │   ├── app_colors.dart            # Semua warna aplikasi
│   │   ├── app_strings.dart           # Semua teks/label
│   │   └── api_constants.dart         # URL & endpoint API
│   ├── theme/
│   │   └── app_theme.dart             # Tema visual Material 3
│   ├── services/
│   │   ├── secure_storage.dart        # Penyimpanan token terenkripsi
│   │   └── dio_client.dart            # HTTP client dengan interceptor
│   ├── routes/
│   │   ├── app_router.dart            # Manajemen navigasi halaman
│   │   └── auth_guard.dart            # Proteksi halaman (autentikasi)
│   └── widgets/
│       ├── auth_header.dart           # Header ikon + judul halaman auth
│       ├── custom_text_field.dart     # Input field reusable
│       ├── custom_button.dart         # Tombol reusable (3 varian)
│       ├── divider_with_text.dart     # Garis pemisah berteks
│       ├── google_sign_in_button.dart # Tombol login Google
│       └── loading_overlay.dart       # Overlay loading di atas halaman
│
└── features/
    ├── auth/                          # Fitur Autentikasi
    │   ├── data/
    │   │   ├── model/
    │   │   │   └── auth_response_model.dart   # Model respon API auth
    │   │   └── repositories/
    │   │       └── auth_repository_impl.dart  # Implementasi koneksi ke backend
    │   ├── domain/
    │   │   └── repositories/
    │   │       └── auth_repository.dart       # Kontrak/antarmuka repository
    │   └── presentation/
    │       ├── providers/
    │       │   └── auth_provider.dart         # State management autentikasi
    │       └── pages/
    │           ├── login_page.dart            # Halaman login
    │           ├── register_page.dart         # Halaman daftar akun
    │           └── verify_email_page.dart     # Halaman verifikasi email
    │
    └── product/                       # Fitur Dashboard & Produk
        ├── data/
        │   ├── Models/
        │   │   └── product_model.dart         # Model data produk
        │   └── repositories/
        │       └── product_repository_impl.dart # Implementasi fetch produk
        ├── domain/
        │   └── repositories/
        │       └── product_repository.dart    # Kontrak repository produk
        └── presentation/
            ├── providers/
            │   └── product_provider.dart      # State management produk
            └── pages/
                └── dashboard_page.dart        # Halaman utama katalog sepeda
```

---

## 📦 Dependencies Utama

| Package | Versi | Fungsi |
|---|---|---|
| `provider` | ^6.1.5 | State management (ChangeNotifier) |
| `firebase_core` | ^4.6.0 | Inisialisasi Firebase |
| `firebase_auth` | ^6.3.0 | Autentikasi email & Google |
| `google_sign_in` | ^7.2.0 | Login dengan akun Google |
| `dio` | ^5.9.2 | HTTP client untuk koneksi ke backend Golang |
| `flutter_secure_storage` | ^10.0.0 | Penyimpanan token JWT terenkripsi |
| `equatable` | ^2.0.8 | Perbandingan objek data |
| `email_validator` | ^3.0.0 | Validasi format email |
| `flutter_svg` | ^2.2.4 | Render ikon SVG (logo Google) |

---

## 🔧 FASE 1 — Setup Proyek

### 1. `flutter create utsw5_1123150032`
Perintah ini membuat kerangka proyek Flutter baru secara otomatis. Semua folder awal seperti `lib/`, `android/`, `ios/`, dan file konfigurasi seperti `pubspec.yaml` dibuat di sini. Ini adalah titik awal sebelum menulis satu baris kode pun.

### 2. `pubspec.yaml` — Konfigurasi Dependencies
File ini adalah "daftar belanja" semua package yang dibutuhkan proyek. Di sini kita menambahkan:
- **Firebase** untuk autentikasi
- **Dio** untuk HTTP request ke backend Golang
- **Provider** untuk state management
- **flutter_secure_storage** untuk menyimpan token dengan aman

Setelah diubah, jalankan `flutter pub get` untuk mengunduh semua package.

### 3. Firebase Setup (`flutterfire configure`)
Perintah CLI ini menghubungkan proyek Flutter ke proyek Firebase yang sudah dibuat di console. Hasilnya adalah file `firebase_options.dart` yang berisi konfigurasi platform (Android/iOS/Web) secara otomatis. File ini **jangan diedit manual**.

---

## ⚙️ FASE 2 — Core Constants & Services

Semua file di fase ini adalah **pondasi global** yang dipakai oleh seluruh bagian aplikasi. Letaknya di folder `lib/core/`.

### 4. `app_colors.dart` — Palet Warna Aplikasi
Menyimpan semua warna dalam satu tempat sebagai konstanta statis. Tujuannya agar warna konsisten di seluruh aplikasi dan mudah diganti di satu titik. Contoh:
- `AppColors.primary` → Warna utama oranye (`#FF5722`)
- `AppColors.error` → Warna merah untuk pesan error
- `AppColors.googleRed` → Warna merah khusus tombol Google

### 5. `app_strings.dart` — Kumpulan Teks Statis
Menyimpan semua teks label, pesan error, dan teks tombol sebagai konstanta. Ini membuat teks tidak "tersebar" di mana-mana dan mudah diubah kapan saja, misalnya saat ganti bahasa. Contoh:
- `AppStrings.btnLogin` → `'Masuk'`
- `AppStrings.passwordTooShort` → `'Password minimal 8 karakter'`
- `AppStrings.sessionExpired` → `'Sesi telah berakhir, silakan login kembali'`

### 6. `api_constants.dart` — Alamat & Endpoint API
Menyimpan semua URL backend Golang dalam satu file. Jika IP server berubah, cukup ubah di sini saja tanpa harus mencari-cari di seluruh kode. Isinya:
- `baseUrl` → Alamat backend (`http://192.168.0.105:8080/v1`)
- Endpoint auth: `/auth/verify-token`, `/auth/refresh`, `/auth/logout`
- Endpoint produk: `/products`, `/categories`
- Timeout koneksi: 15 detik

### 7. `app_theme.dart` — Tema Visual Material 3
Mendefinisikan tampilan visual seluruh aplikasi secara global (warna, bentuk tombol, gaya input field, ukuran font, dll). Dengan ini, setiap widget Material otomatis mengikuti gaya yang sudah ditentukan tanpa perlu styling manual berulang-ulang di setiap halaman.

### 8. `secure_storage.dart` — Penyimpanan Token Aman
Lapisan abstraksi di atas `flutter_secure_storage`. Menyimpan token JWT dari backend Golang secara terenkripsi di keystore perangkat (bukan SharedPreferences biasa). Fungsi utamanya:
- `saveToken()` / `getToken()` / `deleteToken()` → Kelola access token
- `saveRefreshToken()` / `getRefreshToken()` → Kelola refresh token
- `saveUserData()` / `getUserData()` → Simpan ID dan email user
- `clearAll()` → Hapus semua data saat logout

### 9. `dio_client.dart` — HTTP Client Terpusat
Singleton Dio yang dikonfigurasi dengan 3 interceptor berlapis:
1. **Log Interceptor** → Menampilkan detail request/response di console (hanya mode debug)
2. **Auth Interceptor** → Secara otomatis menyisipkan `Bearer token` di setiap request ke backend, dan menghapus storage jika server mengembalikan `401 Unauthorized`
3. **Retry Interceptor** → Mendeteksi error koneksi/timeout untuk potensi pengulangan request

### 10. `app_router.dart` — Manajemen Navigasi
Mendaftarkan semua halaman aplikasi beserta nama rutenya (`/login`, `/register`, `/verify-email`, `/dashboard`). Dilengkapi `AuthGuard` yang memproteksi halaman dashboard — jika user belum login, secara otomatis diarahkan ke halaman login.

---

## 🧩 FASE 3 — Reusable Widgets

Widget-widget kecil yang bisa dipakai ulang di mana saja tanpa menulis ulang kode. Semua ada di `lib/core/widgets/`.

### 11. `auth_header.dart` — Header Halaman Auth
Widget yang menampilkan ikon melingkar + judul besar + subtitle kecil di bagian atas halaman login/register. Parameter-nya fleksibel: ikon, warna, judul, dan subtitle bisa dikustomisasi.

### 12. `custom_text_field.dart` — Input Field Reusable
Input field berfitur lengkap: label di atas, hint text, ikon prefix/suffix, mode password (obscure), validasi bawaan, keyboard type, dan bisa dinonaktifkan. Dipakai di form login dan registrasi.

### 13. `custom_button.dart` — Tombol Reusable 3 Varian
Tombol serba guna dengan 3 gaya berbeda via `ButtonVariant`:
- **Primary** → Tombol solid berwarna utama (untuk aksi utama)
- **Outlined** → Tombol dengan border tanpa isian (untuk aksi sekunder)
- **Text** → Tombol teks biasa (untuk aksi minor/link)

Semua varian mendukung `isLoading` — saat loading, label diganti `CircularProgressIndicator` dan tombol dinonaktifkan otomatis.

### 14. `divider_with_text.dart` — Garis Pemisah Berteks
Membuat garis horizontal dengan teks di tengahnya (contoh: `─── atau ───`). Dipakai sebagai pemisah antara form login biasa dan tombol login Google.

### 15. `google_sign_in_button.dart` — Tombol Login Google
Tombol khusus bergaya Google: latar putih, border abu-abu, logo Google di sisi kiri, dan teks "Lanjutkan dengan Google". Mendukung state loading dan disabled saat proses login berlangsung.

### 16. `loading_overlay.dart` — Overlay Loading
Melapisi seluruh halaman dengan layer semi-transparan gelap + kotak putih berisi `CircularProgressIndicator` di tengahnya. Digunakan saat proses yang membutuhkan waktu seperti login atau fetch data agar user tidak bisa menekan tombol lain.

---

## 🔐 FASE 4 — Auth Layer

Lapisan logika autentikasi yang mengikuti pola Clean Architecture: Domain (kontrak) → Data (implementasi) → Presentation (state).

### 17. `auth_response_model.dart` — Model Respon API Auth
Dua class yang merepresentasikan data dari backend Golang:
- **`UserModel`** → Data user: `id`, `firebaseUid`, `email`, `name`, `role`, `emailVerified`, `createdAt`
- **`AuthResponseModel`** → Respon lengkap server: `success`, `message`, `accessToken`, `tokenType`, `expiresIn`, dan objek `UserModel` di dalamnya

Keduanya punya `fromJson()` untuk parsing data JSON dari API.

### 18. `auth_repository.dart` — Kontrak Repository (Abstract)
Mendefinisikan **apa yang bisa dilakukan** oleh repository autentikasi tanpa peduli bagaimana caranya. Hanya berisi satu kontrak:
```dart
abstract class AuthRepository {
  Future<String> verifyFirebaseToken(String firebaseToken);
}
```
Ini adalah prinsip Dependency Inversion — layer atas bergantung pada abstraksi, bukan implementasi.

### 19. `auth_repository_impl.dart` — Implementasi Repository
Kelas yang **benar-benar mengerjakan** komunikasi ke backend Golang menggunakan `DioClient`. Cara kerjanya:
1. Menerima Firebase ID Token dari provider
2. Mengirimkannya ke endpoint `/auth/verify-token` via POST
3. Backend Golang memvalidasi token ke Firebase, lalu menerbitkan JWT milik backend sendiri
4. JWT tersebut dikembalikan ke provider untuk disimpan di Secure Storage

### 20. `auth_provider.dart` — State Management Autentikasi
Otak dari seluruh alur autentikasi. Menggunakan `ChangeNotifier` (Provider) untuk memberi tahu UI setiap kali state berubah. Status yang dikelola:
- `AuthStatus.initial` → Belum ada aksi
- `AuthStatus.loading` → Sedang proses login/register
- `AuthStatus.authenticated` → Login berhasil, token tersimpan
- `AuthStatus.unauthenticated` → Logout
- `AuthStatus.emailNotVerified` → Akun belum verifikasi email
- `AuthStatus.error` → Ada kesalahan

Fungsi penting: `startVerificationCheck()` — polling otomatis setiap 4 detik untuk cek apakah email sudah diverifikasi, lalu redirect ke dashboard jika ya.

---

## 📱 FASE 5 — Auth Pages

Halaman-halaman yang dilihat dan digunakan langsung oleh pengguna untuk proses autentikasi.

### 21. `register_page.dart` — Halaman Daftar Akun
Halaman pendaftaran akun baru dengan form: Nama Lengkap, Email, dan Password. Setelah submit, memanggil `AuthProvider.register()` yang membuat akun di Firebase dan mengirim email verifikasi. Jika berhasil, user diarahkan ke halaman verifikasi email.

### 22. `login_page.dart` — Halaman Login
Halaman masuk dengan form Email dan Password bergaya premium (card putih dengan shadow, input field berbordar biru saat fokus). Setelah submit, memanggil `AuthProvider.login()` yang:
- Jika email sudah terverifikasi → sinkronisasi ke backend Golang → redirect dashboard
- Jika email belum terverifikasi → redirect halaman verifikasi

### 23. `verify_email_page.dart` — Halaman Verifikasi Email
Halaman tunggu setelah registrasi. Menampilkan instruksi untuk cek inbox email. Di balik layar, `AuthProvider.startVerificationCheck()` berjalan setiap 4 detik memeriksa status verifikasi Firebase. Begitu email dikonfirmasi, user langsung diarahkan ke dashboard tanpa perlu tekan tombol apapun.

---

## 🛍️ FASE 6 — Dashboard Layer

Lapisan data untuk fitur produk/katalog, mengikuti pola yang sama dengan auth layer.

### 24. `product_model.dart` — Model Data Produk
Merepresentasikan satu produk/sepeda dari backend. Field yang ada:
- `id`, `name`, `price` (double), `description`, `imageUrl`, `stock`, `category`

Punya `fromJson()` yang toleran terhadap perbedaan format key dari backend (mendukung `'ID'` maupun `'id'`).

### 25. `product_repository.dart` — Kontrak Repository Produk (Abstract)
Mendefinisikan kontrak sederhana:
```dart
abstract class ProductRepository {
  Future<List<ProductModel>> getProducts();
}
```

### 26. `product_repository_impl.dart` — Implementasi Fetch Produk
Mengimplementasikan kontrak di atas dengan memanggil `DioClient.instance.get(ApiConstants.products)`, mengurai list JSON dari key `'data'`, lalu mengubah setiap item menjadi `ProductModel`.

### 27. `product_provider.dart` — State Management Produk
Mengelola state pengambilan data produk dengan status:
- `ProductStatus.initial` → Belum fetch
- `ProductStatus.loading` → Sedang mengambil data
- `ProductStatus.loaded` → Data berhasil didapat
- `ProductStatus.error` → Gagal mengambil data

Menggunakan `Future.microtask()` saat memanggil `notifyListeners()` di awal fetch agar tidak terjadi konflik saat dipanggil dari `initState()`.

---

## 🏠 FASE 7 — Dashboard Page & Entry Point

### 28. `dashboard_page.dart` — Halaman Utama Katalog Sepeda
Halaman beranda aplikasi yang menampilkan katalog sepeda dalam format grid 2 kolom. Fitur-fiturnya:
- **SliverAppBar** dengan foto sepeda sebagai background header yang mengecil saat di-scroll
- **Grid katalog** dengan card produk bergaya premium
- **Badge kategori** di pojok kiri atas gambar
- **Indikator stok** dengan warna: hijau (ada), oranye (sisa ≤5), merah (habis)
- **Shimmer loading** saat gambar sedang dimuat
- **Fallback image** dari Unsplash jika URL produk kosong/error
- **Tombol logout** di pojok kanan atas AppBar

Fetch produk dilakukan sekali saja di `initState()` dengan guard `_hasFetched` agar tidak berulang.

### 29. `main.dart` — Titik Masuk Aplikasi
File pertama yang dieksekusi saat aplikasi dijalankan. Tugasnya:
1. Memastikan Flutter sudah siap (`WidgetsFlutterBinding.ensureInitialized()`)
2. Menginisialisasi Firebase (`Firebase.initializeApp()`)
3. Mendaftarkan semua Provider (`AuthProvider` dan `ProductProvider`) ke `MultiProvider`
4. Menjalankan `MaterialApp` dengan tema dari `AppTheme.light` dan rute awal `/login`

---

## 🔄 Alur Kerja Aplikasi

```
Buka App
   │
   ▼
[main.dart] → Init Firebase → Daftarkan Provider → Tampilkan /login
   │
   ▼
[login_page.dart] → User isi email & password
   │
   ▼
[auth_provider.dart] → signInWithEmailAndPassword (Firebase)
   │
   ├── Email belum verifikasi → [verify_email_page.dart]
   │       │ (polling 4 detik)
   │       └── Email verified → _verifyBackend() → Simpan JWT → /dashboard
   │
   └── Email sudah verifikasi → _verifyBackend()
           │
           ▼
     [auth_repository_impl.dart] → POST /auth/verify-token ke backend Golang
           │
           ▼
     Terima JWT Backend → simpan di SecureStorage
           │
           ▼
     [dashboard_page.dart] → fetch /products → tampilkan katalog sepeda
```

