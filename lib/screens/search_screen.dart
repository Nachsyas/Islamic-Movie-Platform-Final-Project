import 'package:flutter/material.dart';
import 'package:myapp/viewmodel/tmdb_api_service.dart';
import 'package:myapp/model/movie_model.dart';
import 'package:myapp/widgets/auth_background.dart';
import 'package:myapp/widgets/movie_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TmdbApiService _apiService = TmdbApiService();
  final TextEditingController _searchController = TextEditingController();
  List<Movie> _searchResults = [];
  bool _isLoading = false;

  void _onSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      final results = await _apiService.searchContent(query);
      setState(() => _searchResults = results);
    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal mencari")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, title: const Text("Pencarian")),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Cari Film / Serial TV...", hintStyle: const TextStyle(color: Colors.white70),
                  filled: true, fillColor: Colors.white24,
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  suffixIcon: IconButton(icon: const Icon(Icons.arrow_forward, color: Colors.white), onPressed: _onSearch),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onSubmitted: (_) => _onSearch(),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, childAspectRatio: 0.55, crossAxisSpacing: 10, mainAxisSpacing: 10,
                      ),
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) => MovieCard(movie: _searchResults[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}