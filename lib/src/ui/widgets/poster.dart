import 'package:flutter/material.dart';

import 'no_poster.dart';

import '../../models/movie.dart';
import '../../resources/tmdb_api.dart';

class Poster extends StatelessWidget {
  final Movie movie;

  Poster(this.movie);

  @override
  Widget build(BuildContext context) {
    if (movie.posterPath == null) {
      return NoPosterWidget();
    }

    return Image.network(
      '${TmdbApi.coverImagePath}${movie.posterPath}',
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes
                : null,
          ),
        );
      },
      fit: BoxFit.cover,
    );
  }
}
