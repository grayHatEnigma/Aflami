import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/favorite_button.dart';
import '../widgets/favorite_item.dart';
import '../../blocs/favorites_bloc.dart';

import '../../models/movie.dart';

class FavoritesScreen extends StatelessWidget {
  static final routeName = 'favorites';
  @override
  Widget build(BuildContext context) {
    final favoritesBloc = Provider.of<FavoritesBloc>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text(
            'Favorites',
            style: Theme.of(context).textTheme.title,
          ),
          actions: [
            Center(child: FavoriteButton(onTap: null)),
          ],
        ),
        body: StreamBuilder<List<Movie>>(
            stream: favoritesBloc.outFavorites,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return FavoriteItem(
                      movie: snapshot.data[index],
                    );
                  },
                  itemCount: snapshot.data.length,
                );
              } else
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Loading ...'),
                      SizedBox(height: 10),
                      CircularProgressIndicator(),
                    ],
                  ),
                );
            }),
      ),
    );
  }
}
