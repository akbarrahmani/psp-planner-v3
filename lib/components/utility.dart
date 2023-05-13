String doubleToString(double value, int fixed) {
  String out = '';
  out = value.toString().split('.')[0];
  String p = value.toString().split('.')[1];
  if (p.length < fixed) {
    fixed = p.length;
  }
  List<String> pp = [];
  int newFexid = 0;
  if (p.isNotEmpty) {
    try {
      for (var i = 0; i < fixed; i++) {
        pp.add(p[i]);
        if (int.parse(p[i]) > 0) newFexid = i + 1;
      }
      // ignore: empty_catches
    } catch (e) {}

    if (newFexid > 0) {
      out += '.';
      for (var i = 0; i < newFexid; i++) {
        out += pp[i];
      }
    }
  }
  return out;
}
