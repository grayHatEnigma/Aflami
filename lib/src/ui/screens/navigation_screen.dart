import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../blocs/response_bloc.dart';

class NavigationScreen extends StatefulWidget {
  static final routeName = 'navigation';

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  //
  int currentPageIndex;
  int newPageIndex;
  ResponseBloc responseBloc;
  //

  @override
  void didChangeDependencies() {
    // BLoC
    responseBloc = Provider.of<ResponseBloc>(context);
    currentPageIndex = responseBloc.currentPageIndex;
    newPageIndex = currentPageIndex;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text('Navigation', style: Theme.of(context).textTheme.title),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Select a Page',
              style: const TextStyle(
                  color: Colors.amber, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            const Text(
              'to navigate to',
              style: const TextStyle(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 5,
                  fontWeight: FontWeight.w100),
            ),
            const SizedBox(height: 30),
            Text(
              newPageIndex.toString(),
              style: TextStyle(
                  color: Colors.teal,
                  fontSize: 27,
                  fontWeight: FontWeight.w800),
            ),
            const SizedBox(
              height: 50,
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 13),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 25),
                thumbColor: Colors.amber[700],
                overlayColor: Colors.white.withOpacity(0.25),
                activeTrackColor: Colors.amber,
                inactiveTrackColor: Colors.white,
              ),
              child: Slider(
                value: newPageIndex.toDouble(),
                onChanged: (value) {
                  setState(() {
                    newPageIndex = value.toInt();
                  });
                },
                max: 500,
                min: 1,
                divisions: 500,
              ),
            ),
            const SizedBox(height: 50),
            InkWell(
              onTap: () {
                if (newPageIndex != currentPageIndex) {
                  responseBloc.navigateTo(newPageIndex);
                }
                Navigator.pop(context);
              },
              child: const Text('Go',
                  style: const TextStyle(
                      color: Colors.amber,
                      fontSize: 20,
                      letterSpacing: 0.75,
                      fontWeight: FontWeight.w600)),
            )
          ],
        ),
      ),
    );
  }
}
