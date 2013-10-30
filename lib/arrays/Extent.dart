
part of D3Dart;

List extent(array, [f]) {
  var i = -1,
      n = array.length,
      a,
      b,
      c;
  if (f == null) {
    while (++i < n && !((a = c = array[i]) != null && a <= a)) a = c = null;
    while (++i < n) if ((b = array[i]) != null) {
      if (a > b) a = b;
      if (c < b) c = b;
    }
  } else {
    while (++i < n && !((a = c = f(array[i], i)) != null && a <= a)) a = null;
    while (++i < n) if ((b = f(array[i], i)) != null) {
      if (a > b) a = b;
      if (c < b) c = b;
    }
  }
  return [a, c];
}

