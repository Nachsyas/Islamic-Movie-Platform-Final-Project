class Movie {
  final String id;
  final String title;
  final String posterURL;
  final String backdropURL;
  final double rating;
  final String synopsis;
  final String mediaType; // 'movie' atau 'tv'
  bool isFavorite; // Bisa diedit (mutable)

  Movie({
    required this.id,
    required this.title,
    required this.posterURL,
    this.backdropURL = '',
    required this.rating,
    this.synopsis = '',
    this.mediaType = 'movie',
    this.isFavorite = false,
  });

  factory Movie.fromJson(Map<String, dynamic> json, {String defaultType = 'movie'}) {
    return Movie(
      id: json['id'].toString(),
      // TV Series pakai 'name', Movie pakai 'title'
      title: json['title'] ?? json['name'] ?? 'No Title',
      posterURL: json['poster_path'] != null
          ? 'https://image.tmdb.org/t/p/w500${json['poster_path']}'
          : 'https://via.placeholder.com/500x750?text=No+Image',
      backdropURL: json['backdrop_path'] != null
          ? 'https://image.tmdb.org/t/p/w780${json['backdrop_path']}'
          : '',
      rating: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      synopsis: json['overview'] ?? 'Sinopsis tidak tersedia.',
      mediaType: json['media_type'] ?? defaultType,
    );
  }
}