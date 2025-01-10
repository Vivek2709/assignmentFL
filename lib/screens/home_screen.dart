import 'package:flutter/material.dart';
import 'package:assignment/models/movie_model.dart';
import 'package:assignment/screens/movie_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Movie> _movies = [];
  List<Movie> _filteredMovies = [];

  Future<void> fetchMovies() async {
    final response =
        await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=all'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _movies = data.map((e) => Movie.fromJson(e['show'])).toList();
        _filteredMovies = _movies;
      });
    } else {
      throw Exception('Failed to load movies');
    }
  }

  void _filterMovies(String query) {
    setState(() {
      _filteredMovies = _movies
          .where(
              (movie) => movie.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchMovies();
    _searchController.addListener(() {
      _filterMovies(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MovieSearchDelegate(movies: _movies),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Search Movies',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: _movies.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          crossAxisSpacing: 12.0,
                          mainAxisSpacing: 12.0,
                        ),
                        itemCount: _filteredMovies.length,
                        itemBuilder: (context, index) {
                          final movie = _filteredMovies[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/details',
                                  arguments: movie);
                            },
                            child: MovieCard(
                              movie: movie,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MovieSearchDelegate extends SearchDelegate {
  final List<Movie> movies;

  MovieSearchDelegate({required this.movies});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<Movie> result = movies
        .where(
            (movie) => movie.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: result.length,
      itemBuilder: (context, index) {
        final movie = result[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/details', arguments: movie);
          },
          child: MovieCard(movie: movie),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Movie> suggestionList = movies
        .where(
            (movie) => movie.name.toLowerCase().startsWith(query.toLowerCase()))
        .toList();
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final movie = suggestionList[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/details', arguments: movie);
          },
          child: MovieCard(movie: movie),
        );
      },
    );
  }
}
