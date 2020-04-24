import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'detail_screen.dart';
import '../widgets/favorite_button.dart';
import '../../blocs/response_bloc.dart';
import '../../blocs/trailer_bloc.dart';
import '../../models/response.dart';
import '../../models/movie.dart';
import '../../resources/tmdb_api.dart';

class HomeScreen extends StatelessWidget {
  static final routeName = 'home';

  @override
  Widget build(BuildContext context) {
    final responseBloc = Provider.of<ResponseBloc>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text(
            'AFLAMY',
            style: Theme.of(context).textTheme.title,
          ),
          actions: [
            FavoriteButton(onTap: null),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'previous page',
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () => responseBloc.dispath(ResponseEvent.previous),
              child: Icon(
                Icons.navigate_before,
                color: Theme.of(context).backgroundColor,
                size: 31,
              ),
            ),
            FloatingActionButton(
                heroTag: 'page index',
                backgroundColor: Theme.of(context).backgroundColor,
                onPressed: null,
                child: StreamBuilder<Object>(
                    stream: responseBloc.currentIndex,
                    initialData: '1',
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.data.toString(),
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      );
                    })),
            FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () => responseBloc.dispath(ResponseEvent.next),
              child: Icon(
                Icons.navigate_next,
                color: Theme.of(context).backgroundColor,
                size: 31,
              ),
            ),
          ],
        ),
        body: StreamBuilder(
          stream: responseBloc.allMovies,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridBuilder(response: snapshot);
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

class GridBuilder extends StatelessWidget {
  final AsyncSnapshot<ResponseModel> response;
  const GridBuilder({@required this.response});
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (context, index) {
        final currentEntry = response.data.results[index];
        return MovieCard(movie: currentEntry);
      },
      itemCount: response.data.results.length,
    );
  }
}

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({this.movie});

  void _navigateToDetail(BuildContext context) {
    final trailerBloc = TrailerBloc();
    trailerBloc.findTrailers(movie.id);
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => Provider.value(
              value: trailerBloc,
              child: DetailScreen(),
            ),
            settings: RouteSettings(arguments: movie),
          ),
        )
        .then((_) => trailerBloc.dispose);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _navigateToDetail(context),
      child: Container(
        margin: EdgeInsets.all(2),
        child: Image.network(
          '${TmdbApi.movieImagePath}${movie.posterPath}',
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
        ),
      ),
    );
  }
}
