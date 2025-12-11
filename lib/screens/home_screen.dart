import 'package:flutter/material.dart';
import 'package:myapp/model/movie_model.dart';
import 'package:myapp/viewmodel/tmdb_api_service.dart';
import 'package:myapp/viewmodel/recently_viewed_service.dart';
import 'package:myapp/widgets/for_you_carousel.dart';
import 'package:myapp/widgets/movie_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TmdbApiService _apiService = TmdbApiService();
  
  // Data sumber untuk dialog "Tambah Manual"
  List<Movie> _islamicMovies = [];
  List<Movie> _islamicSeries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllData();
  }

  Future<void> _fetchAllData() async {
    try {
      final movies = await _apiService.fetchIslamicMovies();
      final series = await _apiService.fetchIslamicSeries();
      
      if (mounted) {
        setState(() {
          _islamicMovies = movies;
          _islamicSeries = series;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      debugPrint("Error fetching data: $e");
    }
  }

  // --- DIALOG DENGAN LIST YANG RAPI (BERJARAK) ---
  void _showAddDialog(String type) {
    // Tentukan sumber data: Jika tipe 'movie' ambil list film, jika 'tv' ambil list series
    final List<Movie> sourceList = (type == 'movie') ? _islamicMovies : _islamicSeries;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1B1D2A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text("Tambah ke Riwayat ${type == 'movie' ? 'Film' : 'TV'}", 
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: sourceList.isEmpty 
              ? const Center(child: Text("Data belum dimuat...", style: TextStyle(color: Colors.white54)))
              : ListView.separated(
                  // Memberi jarak antar item di list dialog
                  separatorBuilder: (ctx, i) => const SizedBox(height: 12), 
                  itemCount: sourceList.length,
                  itemBuilder: (context, index) {
                    final movie = sourceList[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        // --- LOGIKA KUNCI: MEMISAHKAN FILM DAN TV ---
                        // Kita buat objek baru dengan mediaType yang dipaksa sesuai kategori
                        final movieToAdd = Movie(
                          id: movie.id,
                          title: movie.title,
                          posterURL: movie.posterURL,
                          backdropURL: movie.backdropURL,
                          rating: movie.rating,
                          synopsis: movie.synopsis,
                          mediaType: type, // <--- INI YANG MEMISAHKAN LIST (movie/tv)
                          isFavorite: movie.isFavorite
                        );

                        // Masukkan ke service
                        RecentlyViewedService.addToHistory(movieToAdd);
                        
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("${movie.title} berhasil ditambahkan!"),
                            backgroundColor: const Color(0xFF6C63FF),
                            duration: const Duration(milliseconds: 800),
                          )
                        );
                      },
                      // Tampilan Item Dialog
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8)
                        ),
                        child: Row(
                          children: [
                            // Gambar Kecil
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(
                                movie.posterURL, 
                                width: 50, height: 75, fit: BoxFit.cover,
                                errorBuilder: (ctx, err, st) => Container(width: 50, height: 75, color: Colors.grey),
                              ),
                            ),
                            const SizedBox(width: 16), // Jarak teks dengan gambar
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movie.title, 
                                    style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                                    maxLines: 2, overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Rating: ${movie.rating}", 
                                    style: const TextStyle(color: Colors.white54, fontSize: 12)
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.add_circle_outline, color: Color(0xFF6C63FF)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Tutup", style: TextStyle(color: Colors.grey)),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                // Carousel
                if (_islamicMovies.isNotEmpty)
                  ForYouCarousel(
                    title: "Trending Islami", 
                    movies: _islamicMovies.take(5).toList(), 
                    onSeeAllTap: () {}
                  ),

                const SizedBox(height: 20),
                _buildSection("Film Sejarah Islam", _islamicMovies),
                const SizedBox(height: 20),
                _buildSection("Serial TV Kekaisaran", _islamicSeries),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 15),
                  child: Divider(color: Colors.grey),
                ),

                // --- BAGIAN RIWAYAT (DIPISAH) ---
                _buildHistorySection("Riwayat: Film", RecentlyViewedService.movieHistoryNotifier, 'movie'),
                _buildHistorySection("Riwayat: TV Series", RecentlyViewedService.tvHistoryNotifier, 'tv'),

                const SizedBox(height: 50),
              ],
            ),
          ),
    );
  }

  Widget _buildSection(String title, List<Movie> movies) {
    if (movies.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
        SizedBox(
          height: 230,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: movies.length,
            itemBuilder: (ctx, i) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: MovieCard(movie: movies[i]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistorySection(String title, ValueNotifier<List<Movie>> notifier, String type) {
    return ValueListenableBuilder<List<Movie>>(
      valueListenable: notifier,
      builder: (context, movies, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  // Tombol Tambah di Header
                  InkWell(
                    onTap: () => _showAddDialog(type),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: const [
                          Icon(Icons.add, color: Color(0xFF6C63FF), size: 16),
                          SizedBox(width: 4),
                          Text("Tambah", style: TextStyle(color: Color(0xFF6C63FF), fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            
            if (movies.isEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.history, color: Colors.white24, size: 30),
                    const SizedBox(height: 8),
                    Text("Belum ada riwayat $type", style: const TextStyle(color: Colors.white38, fontSize: 12)),
                  ],
                ),
              )
            else
              SizedBox(
                // Tinggi harus cukup untuk MovieCard(230-an) + Tombol(40-an)
                height: 280, 
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Column(
                        children: [
                          // 1. Kartu Film (Sudah Diperbaiki)
                          MovieCard(movie: movie),
                          
                          const SizedBox(height: 8),

                          // 2. Tombol Aksi (Edit Fav & Hapus)
                          Container(
                            width: 120, // Lebar sama dengan MovieCard
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1B1D2A),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white24, width: 0.5)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Edit Favorite
                                InkWell(
                                  onTap: () {
                                    RecentlyViewedService.toggleFavorite(movie);
                                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(movie.isFavorite ? "Jadi Favorit ❤️" : "Hapus Favorit"), duration: const Duration(milliseconds: 500)));
                                  },
                                  child: Icon(movie.isFavorite ? Icons.favorite : Icons.favorite_border, color: movie.isFavorite ? Colors.red : Colors.grey, size: 20),
                                ),
                                // Pemisah
                                Container(width: 1, height: 16, color: Colors.white24),
                                // Hapus Item
                                InkWell(
                                  onTap: () => RecentlyViewedService.removeFromHistory(movie),
                                  child: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}