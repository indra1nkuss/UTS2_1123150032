🚲 RentBike Premium — Flutter App
UTS Mobile Lanjutan | NIM: 1123150032
RentBike Premium adalah aplikasi mobile berbasis Flutter untuk platform penyewaan sepeda. Aplikasi ini dirancang menggunakan Clean Architecture (Domain → Data → Presentation) untuk memisahkan logika bisnis dari tampilan antarmuka, serta menggunakan Provider untuk pengelolaan state.
Di sisi backend, aplikasi ini terhubung ke REST API yang dibangun dengan Golang, dan memanfaatkan Firebase Authentication sebagai lapis keamanan awal sebelum menerbitkan token akses dari sistem internal.
✨ Fitur Utama
• Autentikasi Berlapis: Menggabungkan Firebase Auth (Email/Password & Google Sign-In) dengan sistem verifikasi token dari backend Golang untuk menghasilkan JWT yang aman.
• Verifikasi Email Otomatis: Fitur polling di latar belakang yang mendeteksi status verifikasi email secara real-time tanpa perlu interaksi manual dari pengguna.
• Dashboard Katalog Interaktif: Menampilkan grid produk dengan indikator stok (hijau, oranye, merah), shimmer loading, dan manajemen fallback image.
• Keamanan Data: Penyimpanan sesi dan token secara terenkripsi menggunakan Secure Storage perangkat (bukan sekadar shared preferences biasa).
• Komponen UI Reusable: Penggunaan desain Material 3 dengan kumpulan widget custom (tombol, input field, overlay) yang konsisten di seluruh aplikasi.
🛠️ Tech Stack & Dependencies
• Framework: Flutter
• State Management: provider
• Networking: dio (lengkap dengan auth, retry, dan log interceptors)
• Keamanan Sesi: flutter_secure_storage
• Autentikasi: firebase_auth, google_sign_in
• Validasi & Utilities: equatable, email_validator, flutter_svg
📁 Gambaran Arsitektur Proyek
Proyek ini dipisahkan secara modular untuk memudahkan maintenance dan pengembangan fitur di masa depan:

lib/
├── main.dart             # Entry point & inisialisasi awal
├── core/                 # Fondasi global aplikasi
│   ├── constants/        # URL API, palet warna, dan teks statis
│   ├── routes/           # Manajemen navigasi & proteksi halaman (Auth Guard)
│   ├── services/         # Konfigurasi HTTP client dan Secure Storage
│   └── widgets/          # Kumpulan UI komponen yang bisa dipakai ulang
│
└── features/             # Modul berbasis fitur (Clean Architecture)
    ├── auth/             # Layer autentikasi (login, register, verifikasi)
    │   ├── data/         # Komunikasi ke API Golang
    │   ├── domain/       # Kontrak/Interface
    │   └── presentation/ # UI dan State (Provider)
    │
    └── product/          # Layer dashboard dan katalog sepeda
        ├── data/         # Fetch produk dari API
        ├── domain/       # Kontrak/Interface
        └── presentation/ # UI Dashboard

🔄 Alur Sistem Aplikasi
1.	Inisialisasi Sistem: Saat dibuka, aplikasi melakukan check session. Jika pengguna belum memiliki token aktif, akan diarahkan ke layar Login.
2.	Proses Autentikasi: * Pengguna login via Firebase.
• Jika email belum diverifikasi, pengguna diarahkan ke layar tunggu (sistem akan melakukan polling otomatis setiap 4 detik).
• Setelah diverifikasi, aplikasi menukar token Firebase dengan JWT resmi dari backend Golang.
3.	Penyimpanan Aman: JWT dan profil pengguna disimpan di keystore internal perangkat.
4.	Masuk ke Dashboard: Pengguna diarahkan ke layar beranda. Aplikasi memanggil endpoint /products untuk merender katalog sepeda secara dinamis berdasarkan data terbaru dari database.
