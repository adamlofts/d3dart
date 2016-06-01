
part of D3Dart;

Future<Object> json(String url) {
  return HttpRequest.getString(url).then((String response) {
    return JSON.decode(response);
  });
}

Future<List<Map>> csv(String url, { String separator: "," }) {
  return HttpRequest.getString(url).then((String response) {
    // FIXME: Super naive
    List keys;
    List ret = [];
    for (String line in response.split("\n")) {
      List<String> values = line.split(separator);
      if (keys == null) {
        keys = values;
        continue;
      }
      
      Map m = {};
      Iterator<String> value_it = values.iterator;
      for (String key in keys) {
        value_it.moveNext();
        String value = value_it.current;
        try {
          m[key] = double.parse(value);
        } on FormatException catch (_) {
          m[key] = value;
        }
      }
      
      ret.add(m);
    }
    return ret;
  });
}

Future<List<Map>> tsv(String url) => csv(url, separator: "\t");
