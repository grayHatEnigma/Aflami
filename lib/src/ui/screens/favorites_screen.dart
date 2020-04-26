import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../widgets/favorite_button.dart';
import '../../models/movie.dart';
import '../../blocs/favorites_bloc.dart';
import '../../blocs/movie_detail_bloc.dart';

class FavoritesScreen extends StatelessWidget {
  static final routeName = 'favorites';
  @override
  Widget build(BuildContext context) {
    final favoritesBloc = Provider.of<FavoritesBloc>(context);
    final movieDetailBloc = Provider.of<MovieDetailBloc>(context);
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
        body: StreamBuilder<List<int>>(
            stream: favoritesBloc.outFavorites,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                movieDetailBloc.fetchMovies(snapshot.data);
                return StreamBuilder<List<Movie>>(
                    stream: movieDetailBloc.movies,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemBuilder: (context, index) {
                            return FavoriteItem(snapshot.data[index]);
                          },
                          itemCount: snapshot.data.length,
                        );
                      } else
                        return CircularProgressIndicator();
                    });
              } else
                return CircularProgressIndicator();
            }),
      ),
    );
  }
}

class FavoriteItem extends StatelessWidget {
  final Movie movie;

  const FavoriteItem(this.movie);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text(
          movie.title,
        ),
      ),
    );
  }
}
