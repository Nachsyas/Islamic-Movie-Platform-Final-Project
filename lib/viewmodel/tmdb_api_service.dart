import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/model/movie_model.dart';

class TmdbApiService {
  final String _apiKey = "314fe67ee98c57ffa9e851b56c92bf24"; 
  final String _baseUrl = "https://api.themoviedb.org/3";

  List<Movie> _parseList(String responseBody, {String defaultType = 'movie'}) {
    try {
      final Map<String, dynamic> data = json.decode(responseBody);
      final List<dynamic> results = data['results'];
      return results.map((json) => Movie.fromJson(json, defaultType: defaultType)).toList();
    } catch (e) {
      debugPrint("Error Parsing: $e");
      return [];
    }
  }

  // 1. Film Islam
  Future<List<Movie>> fetchIslamicMovies() async {
    final uri = Uri.parse('$_baseUrl/search/movie?api_key=$_apiKey&query=Islam&language=en-US&page=1');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return _parseList(response.body, defaultType: 'movie');
    }
    throw Exception('Gagal memuat film');
  }

  // 2. TV Series (Islam + Ottoman gabungan)
  Future<List<Movie>> fetchIslamicSeries() async {
    try {
      final uriIslam = Uri.parse('$_baseUrl/search/tv?api_key=$_apiKey&query=Islam&language=en-US');
      final uriOttoman = Uri.parse('$_baseUrl/search/tv?api_key=$_apiKey&query=Ottoman&language=en-US');
      
      final responses = await Future.wait([http.get(uriIslam), http.get(uriOttoman)]);
      
      List<Movie> combined = [];
      if (responses[0].statusCode == 200) combined.addAll(_parseList(responses[0].body, defaultType: 'tv'));
      if (responses[1].statusCode == 200) combined.addAll(_parseList(responses[1].body, defaultType: 'tv'));
      
      // Hapus duplikat ID
      final ids = <String>{};
      return combined.where((m) => ids.add(m.id)).toList();
    } catch (e) {
      throw Exception('Gagal memuat TV Series');
    }
  }

  // 3. Search
  Future<List<Movie>> searchContent(String query) async {
    if (query.isEmpty) return [];
    final uri = Uri.parse('$_baseUrl/search/multi?api_key=$_apiKey&query=$query&language=en-US&page=1');
    final response = await http.get(uri);
    
    if (response.statusCode == 200) {
      final list = _parseList(response.body);
      // Hanya ambil movie dan tv
      return list.where((m) => m.mediaType == 'movie' || m.mediaType == 'tv').toList();
    }
    throw Exception('Gagal mencari');
  }

  // 4. Trailer
  Future<String?> fetchTrailerKey(String id, String type) async {
    final endpoint = type == 'tv' ? 'tv' : 'movie';
    final uri = Uri.parse('$_baseUrl/$endpoint/$id/videos?api_key=$_apiKey');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final results = json.decode(response.body)['results'] as List;
        final trailer = results.firstWhere(
          (v) => v['type'] == 'Trailer' && v['site'] == 'YouTube',
          orElse: () => null,
        );
        return trailer != null ? trailer['key'] : null;
      }
    } catch (_) {}
    return null;
  }
}