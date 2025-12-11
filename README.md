🎬 Islamic Movie Platform
Islamic Movie Platform adalah aplikasi mobile berbasis Flutter yang dirancang khusus untuk memudahkan pengguna menemukan, menelusuri, dan melacak film serta serial TV bertema sejarah Islam dan Kekaisaran (Ottoman). Aplikasi ini menerapkan Layered Architecture untuk memastikan kode yang bersih, terstruktur, dan mudah dikembangkan.

📱 Fitur Utama
Otentikasi Pengguna: Login dan Registrasi aman menggunakan Firebase Authentication.

Jelajah Konten:

Carousel "Trending Islami" di halaman utama.

Kategori khusus untuk "Film Sejarah Islam" dan "Serial TV Kekaisaran".

Pencarian Cerdas: Fitur pencarian (Multi-search) untuk menemukan film atau serial TV spesifik.

Manajemen Riwayat & Favorit:

Menyimpan riwayat tontonan secara lokal (In-memory State).

Memisahkan riwayat antara Film dan TV Series.

Fitur "Tambah Manual" ke riwayat tanpa harus memutar video.

Menandai konten sebagai Favorit.

Detail & Trailer: Informasi lengkap sinopsis, rating, dan tautan langsung untuk menonton trailer di YouTube.

Profil Pengguna: Tampilan profil sederhana dengan fitur Logout.

🛠 Teknologi & Arsitektur
Aplikasi ini dibangun menggunakan:

Frontend: Flutter (Dart SDK ^3.9.0)

Backend (Auth & DB): Firebase Auth & Cloud Firestore.

Data Source: The Movie Database (TMDb) API v3.

State Management: Native ValueNotifier & setState.

Struktur Arsitektur
Proyek ini menggunakan pendekatan Layered Architecture:

Presentation Layer (/screens, /widgets): Menangani UI dan interaksi pengguna.

ViewModel Layer (/viewmodel): Menangani logika bisnis, komunikasi API, dan manajemen state.

Model Layer (/model): Menangani parsing data JSON dan struktur objek.

🔗 Daftar Endpoint API
Aplikasi ini menggunakan The Movie Database (TMDb) API. Berikut adalah daftar endpoint yang diimplementasikan di dalam TmdbApiService:

1. Mencari Film Bertema Islam
Mengambil daftar film yang relevan dengan kata kunci "Islam".

Endpoint: GET /search/movie

Query Params: query=Islam, page=1

2. Mencari Serial TV (Gabungan)
Aplikasi melakukan strategi Parallel Fetching untuk menggabungkan dua kata kunci pencarian agar hasil lebih komprehensif.

Endpoint 1: GET /search/tv (Query: Islam)

Endpoint 2: GET /search/tv (Query: Ottoman)

Catatan: Hasil dari kedua request digabungkan dan duplikasi dihapus.

3. Pencarian Umum (Search)
Digunakan pada halaman pencarian untuk menemukan Film atau TV Series berdasarkan input pengguna.

Endpoint: GET /search/multi

Query Params: query={user_input}

4. Mendapatkan Trailer
Mengambil "Key" video untuk membuat URL YouTube (https://www.youtube.com/watch?v={key}).

Endpoint Movie: GET /movie/{id}/videos

Endpoint TV: GET /tv/{id}/videos

Filter: Hanya mengambil video dengan tipe Trailer dan site YouTube.

🚀 Cara Instalasi & Menjalankan Aplikasi
Ikuti langkah-langkah berikut untuk menjalankan proyek ini di mesin lokal Anda:

Prasyarat
Flutter SDK terinstal.

Akun Firebase & Proyek TMDb (API Key).

Langkah 1: Clone Repositori
Bash

git clone https://github.com/Nachsyas/Islamic-Movie-Plaform-Final-Project.git
cd Islamic-Movie-Plaform-Final-Project
Langkah 2: Instal Dependensi
Jalankan perintah berikut di terminal untuk mengunduh semua library yang dibutuhkan (seperti firebase_core, http, url_launcher, dll).

Bash

flutter pub get
Langkah 3: Konfigurasi Firebase
File firebase_options.dart sudah disertakan dalam source code. Namun, pastikan konfigurasi google-services.json (Android) atau GoogleService-Info.plist (iOS) sudah sesuai jika Anda mengganti proyek Firebase.

Pastikan Email/Password Sign-in provider diaktifkan di konsol Firebase Authentication.

Pastikan Cloud Firestore sudah dibuat dalam mode Test Mode atau Production.

Langkah 4: Konfigurasi API Key (Opsional)
API Key TMDb saat ini sudah tertanam di file lib/viewmodel/tmdb_api_service.dart. Jika ingin menggantinya dengan key Anda sendiri:

Buka lib/viewmodel/tmdb_api_service.dart.

Ganti nilai variabel _apiKey:

Dart

final String _apiKey = "MASUKKAN_API_KEY_ANDA_DISINI";
Langkah 5: Jalankan Aplikasi
Hubungkan device (Android/iOS) atau gunakan Emulator, lalu jalankan:

Bash

flutter run
📂 Struktur Folder
Plaintext

lib/
├── main.dart                  # Titik awal aplikasi
├── firebase_options.dart      # Konfigurasi Firebase
├── model/
│   └── movie_model.dart       # Model data Film/TV
├── screens/
│   ├── login_screen.dart      # Halaman Login
│   ├── register_screen.dart   # Halaman Daftar
│   ├── main_screen.dart       # Navigasi Bottom Bar
│   ├── home_screen.dart       # Halaman Utama (Dashboard)
│   ├── search_screen.dart     # Halaman Pencarian
│   ├── profile_screen.dart    # Halaman Profil
│   └── movie_detail_screen.dart # Halaman Detail & Trailer
├── viewmodel/
│   ├── auth_service.dart      # Logika Firebase Auth
│   ├── firestore_service.dart # Logika Firestore Database
│   ├── recently_viewed_service.dart # Logika History & Favorit
│   └── tmdb_api_service.dart  # Komunikasi ke API TMDb
└── widgets/
    ├── auth_background.dart   # Widget Background Animasi
    ├── for_you_carousel.dart  # Widget Carousel Slider
    └── movie_card.dart        # Widget Kartu Poster Film
⚠️ Catatan Penting
Error Handling Gambar: Jika poster film tidak muncul (link rusak), aplikasi akan menampilkan ikon broken image dengan background abu-abu agar UI tetap rapi.
