import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'favorites_screen.dart';
import 'filters_screen.dart';
import '../widgets/favorite_button.dart';
import '../widgets/movie_card.dart';
import '../../blocs/response_bloc.dart';
import '../../models/response.dart';

class HomeScreen extends StatelessWidget {
  static final routeName = 'home';

  @override
  Widget build(BuildContext context) {
    final responseBloc = Provider.of<ResponseBloc>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          centerTitle: false,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Image.asset(
                'images/aflami.png',
                height: 30,
                width: 30,
              ),
              SizedBox(width: 7),
              Text(
                'Aflami',
                style: Theme.of(context).textTheme.title,
              ),
            ],
          ),
          actions: [
            Center(
              child: FavoriteButton(onTap: () {
                Navigator.pushNamed(context, FavoritesScreen.routeName);
              }),
            ),
            Center(
              child: IconButton(
                icon: const Icon(Icons.more_horiz),
                onPressed: () =>
                    Navigator.of(context).pushNamed(FiltersScreen.routeName),
              ),
            )
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: 1,
            backgroundColor: Colors.black54,
            unselectedItemColor: Theme.of(context).primaryColor,
            onTap: (index) {
              if (index == 0) {
                responseBloc.dispath(ResponseEvent.previous);
              } else if (index == 2) {
                responseBloc.dispath(ResponseEvent.next);
              }
            },
            items: [
              BottomNavigationBarItem(
                title: Text('previous'),
                icon: Icon(
                  Icons.navigate_before,
                  size: 31,
                ),
              ),
              BottomNavigationBarItem(
                title: Container(),
                icon: StreamBuilder<Object>(
                    stream: responseBloc.currentIndex,
                    initialData: '1',
                    builder: (context, snapshot) {
                      return CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          snapshot.data.toString(),
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      );
                    }),
              ),
              BottomNavigationBarItem(
                title: Text('next'),
                icon: Icon(
                  Icons.navigate_next,
                  size: 31,
                ),
              ),
            ]),
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
