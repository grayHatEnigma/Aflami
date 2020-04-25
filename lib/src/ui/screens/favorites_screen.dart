import 'package:flutter/material.dart';
import '../widgets/favorite_button.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        body: Container(),
      ),
    );
  }
}
