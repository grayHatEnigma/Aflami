class Genre {
  int _id;
  String _name;

  Genre(this._id, this._name);

  Genre.fromJson(Map<String, dynamic> parsedJson) {
    _id = parsedJson['id'];
    _name = parsedJson['name'];
  }

  int get id => _id;
  String get name => _name;
}
