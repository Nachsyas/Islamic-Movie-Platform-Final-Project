import 'package:flutter/foundation.dart';
import 'package:myapp/model/movie_model.dart';

class RecentlyViewedService {
  // LIST 1: KHUSUS FILM
  static final ValueNotifier<List<Movie>> movieHistoryNotifier = ValueNotifier([]);
  
  // LIST 2: KHUSUS TV
  static final ValueNotifier<List<Movie>> tvHistoryNotifier = ValueNotifier([]);

  // LOGIKA PEMISAH
  static void addToHistory(Movie movie) {
    if (movie.mediaType == 'tv') {
      // Jika TV, masuk ke list TV
      _addToList(tvHistoryNotifier, movie);
    } else {
      // Jika Film, masuk ke list Film
      _addToList(movieHistoryNotifier, movie);
    }
  }

  static void _addToList(ValueNotifier<List<Movie>> notifier, Movie movie) {
    final list = List<Movie>.from(notifier.value);
    list.removeWhere((m) => m.id == movie.id); // Hapus duplikat
    list.insert(0, movie); // Masukkan ke depan
    notifier.value = list;
  }

  static void removeFromHistory(Movie movie) {
    // Hapus dari list yang sesuai
    if (movie.mediaType == 'tv') {
      final list = List<Movie>.from(tvHistoryNotifier.value);
      list.removeWhere((m) => m.id == movie.id);
      tvHistoryNotifier.value = list;
    } else {
      final list = List<Movie>.from(movieHistoryNotifier.value);
      list.removeWhere((m) => m.id == movie.id);
      movieHistoryNotifier.value = list;
    }
  }

  static void toggleFavorite(Movie movie) {
    final notifier = (movie.mediaType == 'tv') ? tvHistoryNotifier : movieHistoryNotifier;
    final list = List<Movie>.from(notifier.value);
    
    final index = list.indexWhere((m) => m.id == movie.id);
    if (index != -1) {
      list[index].isFavorite = !list[index].isFavorite;
      notifier.value = [...list]; 
    }
  }
}