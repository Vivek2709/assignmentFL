import 'package:flutter/material.dart';
import 'package:assignment/models/movie_model.dart';
import 'dart:async';

class MovieCard extends StatelessWidget {
  final Movie? movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    if (movie == null) {
      return const SizedBox();
    }
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: movie?.imageUrl != null
                ? FutureBuilder<ImageInfo>(
                    future: preloadImage(NetworkImage(movie!.imageUrl!)),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        // Calculate image height based on aspect ratio
                        double imageHeight = 200; // Default height
                        if (snapshot.data!.image.width != null &&
                            snapshot.data!.image.height != null) {
                          imageHeight = 200 *
                              (snapshot.data!.image.height /
                                  snapshot.data!.image.width);
                        }
                        return Image.network(
                          movie!.imageUrl!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          height: imageHeight,
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  )
                : Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.image,
                      color: Colors.white,
                    ),
                  ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie!.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      movie!.genres.isNotEmpty
                          ? movie!.genres.join(', ')
                          : 'No genres available',
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<ImageInfo> preloadImage(ImageProvider source) async {
  final Completer<ImageInfo> completer = Completer<ImageInfo>();
  final ImageStream stream = source.resolve(ImageConfiguration.empty);
  final ImageStreamListener listener =
      ImageStreamListener((ImageInfo info, bool synchronousCall) {
    completer.complete(info);
  });
  stream.addListener(listener);
  return completer.future;
}
