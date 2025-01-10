import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/movie_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future<List<Movie>>? futureMovies;
  String searchTerm = '';
  bool showSearchButton = true;

  Future<List<Movie>> fetchMovies(String query) async {
    final response = await http.get(
      Uri.parse('https://api.tvmaze.com/search/shows?q=$query'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Movie.fromJson(e['show'])).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Movies'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onTap: () {
                setState(() {
                  showSearchButton = true;
                });
              },
              onChanged: (value) {
                setState(() {
                  searchTerm = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search for a movie...',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    if (searchTerm.isNotEmpty) {
                      setState(() {
                        futureMovies = fetchMovies(searchTerm);
                        showSearchButton = false;
                      });
                      FocusScope.of(context).unfocus();
                    }
                  },
                ),
              ),
              onSubmitted: (value) {
                if (searchTerm.isNotEmpty) {
                  setState(() {
                    futureMovies = fetchMovies(searchTerm);
                    showSearchButton = false;
                  });
                  FocusScope.of(context).unfocus();
                }
              },
            ),
          ),
          if (showSearchButton)
            ElevatedButton(
              onPressed: () {
                if (searchTerm.isNotEmpty) {
                  setState(() {
                    futureMovies = fetchMovies(searchTerm);
                    showSearchButton = false;
                  });
                  FocusScope.of(context).unfocus(); // Close keyboard
                }
              },
              child: const Text('Search'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 207, 133, 79),
                textStyle: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          Expanded(
            child: FutureBuilder<List<Movie>>(
              future: futureMovies,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No results found.'));
                } else {
                  final movies = snapshot.data!;
                  return ListView.builder(
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      return ListTile(
                        leading: Image.network(
                            movie.imageUrl ?? 'fallback-image-url'),
                        title: Text(movie.name),
                        subtitle: Text(movie.genres.join(', ')),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/details',
                            arguments: movie,
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
