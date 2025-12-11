import 'package:flutter/material.dart';
import 'package:myapp/model/movie_model.dart';
import 'package:myapp/viewmodel/tmdb_api_service.dart';
import 'package:myapp/viewmodel/recently_viewed_service.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;
  const MovieDetailScreen({super.key, required this.movie});
  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final TmdbApiService _apiService = TmdbApiService();
  late Future<String?> _trailerFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      RecentlyViewedService.addToHistory(widget.movie);
    });
    _trailerFuture = _apiService.fetchTrailerKey(widget.movie.id, widget.movie.mediaType);
  }

  void _launch(String key) async {
    final url = Uri.parse('https://www.youtube.com/watch?v=$key');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal buka YouTube')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, leading: const BackButton(color: Colors.white)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.network(widget.movie.backdropURL.isNotEmpty ? widget.movie.backdropURL : widget.movie.posterURL, 
                  height: 400, width: double.infinity, fit: BoxFit.cover,
                  errorBuilder: (ctx, err, st) => Container(height: 400, color: Colors.grey[900]),
                ),
                Container(height: 400, decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black]))),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.movie.title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 10),
                  Row(children: [
                    const Icon(Icons.star, color: Colors.amber), 
                    Text(" ${widget.movie.rating.toStringAsFixed(1)}", style: const TextStyle(color: Colors.white, fontSize: 16)),
                    const SizedBox(width: 20),
                    Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(4)), child: Text(widget.movie.mediaType.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                  ]),
                  const SizedBox(height: 20),
                  FutureBuilder<String?>(
                    future: _trailerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () => _launch(snapshot.data!), icon: const Icon(Icons.play_arrow), label: const Text("Tonton Trailer"), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C63FF))));
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text("Sinopsis", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text(widget.movie.synopsis, style: const TextStyle(color: Colors.white70, height: 1.5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}