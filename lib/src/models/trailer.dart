class TrailerModel {
  List<_Result> _list;

  TrailerModel.fromJson(Map<String, dynamic> parsedJson) {
    List<_Result> temp = [];

    for (int i = 0; i < parsedJson['results'].length; i++) {
      final result = _Result(parsedJson['results'][i]);
      temp.add(result);
    }
    _list = temp;
  }

  List<_Result> get trailers => _list;
}

class _Result {
  String _type;
  String _name;
  String _key;

  _Result(result) {
    _type = result['type'];
    _name = result['name'];
    _key = result['key'];
  }

  String get type => _type;
  String get name => _name;
  String get key => _key;
}
