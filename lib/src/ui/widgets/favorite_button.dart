import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../blocs/favorites_bloc.dart';

class FavoriteButton extends StatelessWidget {
  final Function onTap;

  const FavoriteButton({@required this.onTap});

  @override
  Widget build(BuildContext context) {
    final favoritesBloc = Provider.of<FavoritesBloc>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Stack(overflow: Overflow.visible, children: [
          Icon(
            Icons.favorite,
            color: Colors.black,
            size: 32,
          ),
          Positioned(
            top: -5,
            right: -5,
            child: Material(
              type: MaterialType.circle,
              elevation: 2.0,
              color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: StreamBuilder<int>(
                    stream: favoritesBloc.outTotalFavorites,
                    initialData: 0,
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.data.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      );
                    }),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
