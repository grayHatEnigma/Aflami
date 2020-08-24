import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'poster.dart';
import '../screens/detail_screen.dart';
import '../../blocs/trailer_bloc.dart';
import '../../models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  const MovieCard({this.movie});

  // a function that handles the navigation code and disposing the trailer bloc
  /*
  I do this here ( trailer fetching )
  because I don't want to make the api request in either 
  didChangeDependecies() or build() methods in DetailScreen 
  because these methods may be called multiple time via the framework
  for various reasons.

  And here I used a little trick (using .then() on the Navigator Future) 
  to insure the disposing of the trailer bloc when the user comes back to the home screen
  */

  void _navigateToDetail(BuildContext context, Widget poster) {
    final trailerBloc = TrailerBloc();
    trailerBloc.findTrailers(movie.id);
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => Provider.value(
              value: trailerBloc,
              child: DetailScreen(),
            ),
            settings: RouteSettings(arguments: [movie, poster]),
          ),
        )
        .then((_) => trailerBloc.dispose);
  }

  @override
  Widget build(BuildContext context) {
    // cache the poster image
    final poster = Poster(movie);

    return InkWell(
      onTap: () => _navigateToDetail(context, poster),
      child: Card(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            ClipRect(
              clipper: _SquareClipper(),
              child: Hero(tag: movie.hashCode, child: poster),
            ),
            Container(
              decoration: _buildGradientBackground(),
              padding: const EdgeInsets.only(
                bottom: 16.0,
                left: 16.0,
                right: 16.0,
              ),
              child: _buildTextualInfo(movie),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildGradientBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        stops: <double>[0.0, 0.7, 0.7],
        colors: <Color>[
          Colors.black,
          Colors.transparent,
          Colors.transparent,
        ],
      ),
    );
  }

  Widget _buildTextualInfo(Movie movie) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          movie.title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          movie.voteAverage.toString(),
          style: const TextStyle(
            fontSize: 12.0,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}

class _SquareClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return new Rect.fromLTWH(0.0, 0.0, size.width, size.width);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return false;
  }
}
