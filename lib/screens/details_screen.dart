import 'package:flutter/material.dart';
import 'package:assignment/models/movie_model.dart';
import 'package:html/parser.dart' as html_parser;

class DetailsScreen extends StatelessWidget {
  final Movie movie;

  const DetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          movie.name ?? 'Unknown Movie',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: movie.name ?? 'movie_${movie.hashCode}',
              child: movie.imageUrl != null
                  ? Image.network(
                      movie.imageUrl!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      height: 200,
                    )
                  : const Icon(Icons.image_not_supported),
            ),
            const SizedBox(height: 16.0),
            Text(
              movie.name ?? 'No name available',
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: const Color(0xffe6ccb9),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Text(
                html_parser.parse(movie.summary ?? '').documentElement?.text ??
                    'No summary available',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
