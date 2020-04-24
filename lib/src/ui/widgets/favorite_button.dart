import 'package:flutter/material.dart';

class FavoriteButton extends StatelessWidget {
  final Function onTap;

  const FavoriteButton({@required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Stack(overflow: Overflow.visible, children: [
          Icon(
            Icons.favorite,
            color: Colors.red,
            size: 40,
          ),
          Positioned(
            top: 7,
            right: 10,
            child: Text(
              '13',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ]),
      ),
    );
  }
}
