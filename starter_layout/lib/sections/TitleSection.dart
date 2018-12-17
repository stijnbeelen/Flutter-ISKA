import 'package:flutter/material.dart';

class TitleSection extends StatelessWidget {

  static var _title = Container(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(
      'Oeshinen Lake Campground',
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  static var _location = Text(
    'Kandersteg, Switzerland',
    style: TextStyle(
      color: Colors.grey,
    ),
  );

  var _infoContainer = Row(
    children: [
      Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _title,
              _location
            ],
          )
      ),
      StarWidget(),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32.0),
      child: _infoContainer,
    );
  }
}

class StarWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new StarWidgetState();
}

class StarWidgetState extends State<StarWidget> {
  bool _isFavorited = true;
  int _favoriteCount = 41;

  void _toggleFavorite() {
    setState(() {
      if (_isFavorited) {
        _favoriteCount -= 1;
        _isFavorited = false;
      } else {
        _favoriteCount += 1;
        _isFavorited = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: [
        IconButton(
          icon: (_isFavorited
            ? Icon(Icons.star)
            : Icon(Icons.star_border)
          ),
          color: Colors.red,
          onPressed: _toggleFavorite,
        ),
        Text('$_favoriteCount'),
      ],
    );
  }
}