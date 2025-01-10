// lib/models/movie_model.dart

class Movie {
  final String name;
  final List<String> genres;
  final String? imageUrl;
  final String? summary;

  Movie({
    required this.name,
    required this.genres,
    this.imageUrl,
    this.summary,
  });

  // Factory constructor to create a Movie from JSON
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      name: json['name'] ?? 'No name available',
      genres: List<String>.from(json['genres'] ?? []),
      imageUrl: json['image']
          ?['medium'], // This might differ depending on API response
      summary: json['summary'] ?? 'No summary available',
    );
  }
}
