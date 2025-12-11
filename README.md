Laporan Pengembangan Aplikasi: Islamic Movie Platform
1. Penjelasan Arsitektur Aplikasi
Untuk memastikan aplikasi berjalan stabil dan mudah dikembangkan di masa depan, kami menerapkan konsep Layered Architecture (Arsitektur Berlapis). Secara sederhana, struktur ini bekerja mirip dengan sebuah restoran yang terbagi menjadi tiga bagian vital: Ruang Makan (tempat pelanggan melihat menu), Pelayan (yang mencatat dan mengantar pesanan), dan Dapur (tempat bahan baku diolah).

Dalam implementasi teknis menggunakan framework Flutter, kode program dipisahkan ke dalam tiga lapisan utama berikut:

A. Struktur Lapisan (Layers)
1. Presentation Layer (UI/View) – "Ruang Makan" Lapisan ini adalah segala sesuatu yang dilihat dan berinteraksi langsung dengan pengguna di layar ponsel. Secara teknis, kode-kode ini berada di dalam folder screens dan widgets.

Screens (Layar): Halaman utama seperti Login, Register, Home, dan Detail Film dibangun menggunakan StatefulWidget. Ini memungkinkan tampilan aplikasi berubah secara dinamis, misalnya menampilkan animasi loading saat data sedang diambil dan memunculkan poster film setelah data tersedia.

Widgets (Komponen): Kami memecah tampilan menjadi komponen-komponen kecil yang dapat digunakan ulang, seperti MovieCard untuk kartu poster film dan AuthBackground untuk animasi latar belakang, agar kode lebih rapi dan efisien.

2. Business Logic & Service Layer (ViewModel) – "Pelayan" Lapisan ini berfungsi sebagai "otak" aplikasi yang bekerja di belakang layar. Saat pengguna menekan tombol, lapisan inilah yang bekerja menghubungi server atau menyimpan data. Kode tersimpan dalam folder viewmodel.

TmdbApiService: Bertugas menghubungi internet untuk mengambil data film terbaru.

AuthService: Berperan sebagai penjaga keamanan yang memverifikasi email dan password pengguna ke sistem (Firebase).

RecentlyViewedService: Bertugas mencatat riwayat tontonan pengguna ke dalam memori aplikasi menggunakan fitur ValueNotifier, sehingga data riwayat dapat muncul secara instan tanpa memuat ulang halaman.

3. Data Layer (Model) – "Bahan Baku" Agar aplikasi tidak mengalami kesalahan dalam membaca data (seperti tertukar antara judul film dan rating), kami membuat standarisasi format data di folder model. Komponen utamanya adalah Class Movie, yang bertugas menerjemahkan data mentah (JSON) dari server menjadi objek yang dapat dimengerti dan diolah oleh aplikasi.

B. Alur Data (Cara Kerja)
Proses kerja aplikasi dimulai saat pengguna membuka aplikasi atau menekan tombol (Request). Selanjutnya, sistem di lapisan layanan akan pergi ke internet untuk mengambil data film (Processing). Setelah data didapatkan dan diolah, data tersebut disajikan kembali ke layar pengguna (Display). Terakhir, setiap kali pengguna memilih film, aplikasi secara otomatis mencatatnya ke dalam sistem penyimpanan sementara agar muncul di menu Riwayat (Interaction).

Getty Images

2. Penjelasan API yang Digunakan
Aplikasi ini tidak memproduksi konten film sendiri, melainkan "meminjam" data dari penyedia layanan eksternal melalui teknologi yang disebut API (Application Programming Interface). API bertindak sebagai jembatan penghubung antara aplikasi kita dengan gudang data film dunia.

A. The Movie Database (TMDb) API
Kami menggunakan layanan dari TMDb, salah satu penyedia database film terbesar, dengan menggunakan "kunci akses" (API Key) khusus. Implementasinya mencakup:

Search Movie: Secara spesifik mencari film dengan kata kunci "Islam".

Search TV: Untuk mendapatkan hasil yang lebih komprehensif, aplikasi secara cerdas menggabungkan pencarian dua kata kunci sekaligus, yaitu "Islam" dan "Ottoman/Turki", lalu menyatukannya menjadi satu daftar tontonan yang lengkap.

Multi Search: Fitur yang memberikan kebebasan kepada pengguna untuk mencari judul film atau serial apa saja sesuai keinginan.

B. Firebase Services
Untuk keamanan dan manajemen pengguna, kami menggunakan layanan Google Firebase:

Authentication: Bertindak sebagai satpam digital yang memvalidasi kebenaran email dan password saat pengguna Login atau Daftar.

Cloud Firestore: Berfungsi sebagai buku induk digital yang menyimpan data administratif, seperti tanggal pembuatan akun pengguna.

3. Hasil Pengujian (Source Code Representation)
Pada bagian ini, kami memisahkan pengujian menjadi dua kategori vital: Mekanisme Penanganan Error (bagaimana aplikasi bertahan saat terjadi kesalahan) dan Implementasi Skenario Sukses (bagaimana aplikasi bekerja saat kondisi normal).

A. Mekanisme Penanganan Error (Error Handling)
Kualitas aplikasi tidak hanya dinilai dari fitur yang berjalan, tetapi juga bagaimana ia menangani kegagalan tanpa mengalami kerusakan fatal (crash). Berikut adalah implementasi kode pertahanannya:

1. Validasi Input & Keamanan Login Sistem tidak akan memproses data jika input kosong. Selain itu, jika terjadi kesalahan dari server (seperti password salah), pesan teknis diterjemahkan menjadi bahasa yang dimengerti pengguna.

Dart

// [UI] Cek apakah kolom isian kosong sebelum dikirim
if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Isi Email & Password"))
  );
  return;
}

// [Service] Menangkap pesan error sistem dan menerjemahkannya
try {
  // ... proses login ke Firebase ...
} on FirebaseAuthException catch (e) {
  if (e.code == 'user-not-found') {
    throw 'Email tidak ditemukan.'; // Pesan yang mudah dimengerti user
  } else if (e.code == 'wrong-password') {
    throw 'Password salah.';
  }
}
2. Antisipasi Gambar Rusak (Broken Image) Kami mengantisipasi kemungkinan link gambar kadaluwarsa atau koneksi lambat. Daripada menampilkan area kosong (blank), aplikasi secara otomatis menampilkan ikon pengganti.

Dart

Image.network(
  movie.posterURL,
  // ... pengaturan ukuran ...
  errorBuilder: (ctx, err, st) => Container(
    height: 180,
    color: Colors.grey[800], // Menampilkan kotak abu-abu
    child: const Icon(
      Icons.broken_image, // Menampilkan ikon peringatan
      color: Colors.white54
    ),
  ),
),
3. Penanganan Data Riwayat Kosong Bagi pengguna baru, halaman riwayat tidak boleh terlihat rusak atau kosong melompong. Kode berikut memastikan adanya pesan informatif saat belum ada data.

Dart

// Cek apakah daftar riwayat kosong?
if (movies.isEmpty)
  Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.history, color: Colors.white24, size: 30),
        Text(
          "Belum ada riwayat $type", // Tulis pesan informasi ini
          style: const TextStyle(color: Colors.white38, fontSize: 12)
        ),
      ],
    ),
  )
B. Implementasi Skenario Sukses (Success State)
Bagian ini menunjukkan kode yang dieksekusi ketika sistem berjalan sesuai rencana, mulai dari navigasi halaman hingga logika penyimpanan data.

1. Transisi Halaman Login Berhasil Ketika verifikasi sukses, aplikasi segera membuka akses dan memindahkan pengguna ke layar utama secara permanen (tidak bisa kembali ke login dengan tombol back).

Dart

await _authService.signIn(email: ..., password: ...);
if (mounted) {
  // Ganti halaman Login dengan Halaman Utama (MainScreen) secara penuh
  Navigator.pushReplacement(
    context, 
    MaterialPageRoute(builder: (context) => const MainScreen())
  );
}
2. Rendering Daftar Film (Horizontal Scroll) Saat data film berhasil diambil dari API, kode ini menyusunnya menjadi deretan kartu yang rapi dan dapat digeser ke samping (scrollable).

Dart

// Tampilkan daftar film yang bisa digeser (Scroll Horizontal)
SizedBox(
  height: 230,
  child: ListView.builder(
    scrollDirection: Axis.horizontal, 
    itemCount: movies.length,
    itemBuilder: (ctx, i) => Padding(
      padding: const EdgeInsets.only(right: 12),
      child: MovieCard(movie: movies[i]), // Render komponen kartu film
    ),
  ),
),
3. Logika Cerdas Penyimpanan Riwayat & Favorit Sistem secara otomatis memilah jenis konten (TV atau Film) ke dalam daftar yang berbeda dan memungkinkan perubahan status favorit secara instan (real-time).

Dart

static void addToHistory(Movie movie) {
  // Cek jenis konten: Apakah TV Series atau Film?
  if (movie.mediaType == 'tv') {
    _addToList(tvHistoryNotifier, movie); // Masukkan ke rak TV
  } else {
    _addToList(movieHistoryNotifier, movie); // Masukkan ke rak Film
  }
}

static void toggleFavorite(Movie movie) {
  // Ubah status "Suka" atau "Tidak Suka" secara langsung
  final index = list.indexWhere((m) => m.id == movie.id);
  if (index != -1) {
    list[index].isFavorite = !list[index].isFavorite; // Balik statusnya
    notifier.value = [...list]; // Perbarui tampilan layar
  }
}
