
part of D3Dart;

Future<List> csv(String url) {
  return HttpRequest.getString(url).then((String response) {
    // FIXME: Super naieve
    List keys;
    List ret = [];
    for (String line in response.split("\n")) {
      List<String> values = line.split(",");
      if (keys == null) {
        keys = values;
        continue;
      }
      
      Map m = {};
      Iterator<String> value_it = values.iterator;
      for (String key in keys) {
        value_it.moveNext();
        m[key] = value_it.current;
      }
      
      ret.add(m);
    }
    return ret;
  });
}
