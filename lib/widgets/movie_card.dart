import 'package:flutter/material.dart';
import '../model/movie_model.dart';
import '../screens/movie_detail_screen.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MovieDetailScreen(movie: movie)),
        );
      },
      child: Container(
        width: 120, // Lebar tetap
        margin: const EdgeInsets.only(right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // PENTING: Agar tidak memaksa tinggi infinity
          children: [
            // --- BAGIAN INI YANG SEBELUMNYA MENYEBABKAN ERROR ---
            // Kita gunakan ClipRRect dengan Image langsung (TANPA EXPANDED)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                movie.posterURL,
                height: 180, // TINGGI PASTI (WAJIB ADA)
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, st) => Container(
                  height: 180,
                  color: Colors.grey[800],
                  child: const Icon(Icons.broken_image, color: Colors.white54),
                ),
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Judul Film
            Text(
              movie.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white, 
                fontSize: 13, 
                fontWeight: FontWeight.bold
              ),
            ),
            
            // Rating
            if (movie.rating > 0)
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 12),
                  const SizedBox(width: 4),
                  Text(
                    movie.rating.toStringAsFixed(1),
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}