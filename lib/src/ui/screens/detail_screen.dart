import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../models/movie.dart';
import '../../models/trailer.dart';
import '../../resources/tmdb_api.dart';
import '../../blocs/trailer_bloc.dart';
import '../../blocs/favorites_bloc.dart';

class DetailScreen extends StatefulWidget {
  static final routeName = 'detail';

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Movie movie;
  Image poster;
  TrailerBloc trailerBloc;
  FavoritesBloc favoritesBloc;
  bool isFavorite;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    trailerBloc = Provider.of<TrailerBloc>(context);
    favoritesBloc = Provider.of<FavoritesBloc>(context);
    final arguments = ModalRoute.of(context).settings.arguments as List;
    movie = arguments[0] as Movie;
    poster = arguments[1] as Image;
    favoritesBloc.checkMovie(movie.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        top: false,
        bottom: false,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StreamBuilder<bool>(
                        stream: favoritesBloc.isFavorite,
                        initialData: false,
                        builder: (context, snapshot) {
                          return GestureDetector(
                            onTap: () {
                              snapshot.data
                                  ? favoritesBloc.inRemoveFavorite(movie.id)
                                  : favoritesBloc.inAddFavorite(movie.id);
                              favoritesBloc.checkMovie(movie.id);
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.black87,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Icon(
                                  snapshot.data
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color:
                                      snapshot.data ? Colors.red : Colors.white,
                                  size: 27,
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
                expandedHeight: 250.0,
                floating: false,
                pinned: true,
                elevation: 0.0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: movie.hashCode,
                    child: movie.posterPath == null ? Container() : poster,
                  ),
                ),
              ),
            ];
          },
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children: <Widget>[
                Container(margin: EdgeInsets.only(top: 5.0)),
                Text(
                  movie.title,
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 1.0, right: 1.0),
                    ),
                    Text(
                      movie.voteAverage.toString(),
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10.0, right: 10.0),
                    ),
                    Text(
                      movie.releaseDate.toString(),
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
                Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
                Text(movie.overview),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 30, bottom: 25),
                    width: 150,
                    height: 1,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  "Trailer",
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
                StreamBuilder(
                    stream: trailerBloc.trailers,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data.trailers.length > 0
                            ? trailerLayout(snapshot.data)
                            : noTrailer();
                      } else
                        return lodingTrailer();
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget noTrailer() {
    return Center(
      child: Container(
        child: Text("No trailer available"),
      ),
    );
  }

  Widget lodingTrailer() {
    return Center(
      child: Column(children: [
        Text("Loading ..."),
        SizedBox(
          height: 10,
        ),
        CircularProgressIndicator(),
      ]),
    );
  }

  Widget trailerLayout(TrailerModel data) {
    // Show only the first result in the trailer model
    return Container(
      height: 350,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          trailerItem(data, 0),
        ],
      ),
    );
  }

  trailerItem(TrailerModel data, int index) {
    final _controller = YoutubePlayerController(
      initialVideoId: '${data.trailers[index].key}',
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );

    return Expanded(
      child: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.amber,
        progressColors: ProgressBarColors(
          playedColor: Colors.amber,
          handleColor: Colors.amberAccent,
        ),
        onReady: () {
          print('Player is ready.');
        },
      ),
    );
  }
}
