
part of D3Dart;

class Scale {
  /*
   * This product includes color specifications and designs developed by Cynthia
   * Brewer (http://colorbrewer.org/). See lib/colorbrewer for more information.
   */
  static final List<int> _category10 = [
    0x1f77b4, 0xff7f0e, 0x2ca02c, 0xd62728, 0x9467bd,
    0x8c564b, 0xe377c2, 0x7f7f7f, 0xbcbd22, 0x17becf
  ];
  
  static final List<int> _category20 = [
    0x1f77b4, 0xaec7e8,
    0xff7f0e, 0xffbb78,
    0x2ca02c, 0x98df8a,
    0xd62728, 0xff9896,
    0x9467bd, 0xc5b0d5,
    0x8c564b, 0xc49c94,
    0xe377c2, 0xf7b6d2,
    0x7f7f7f, 0xc7c7c7,
    0xbcbd22, 0xdbdb8d,
    0x17becf, 0x9edae5
  ];
  
  static final List<int> _category20b = [
    0x393b79, 0x5254a3, 0x6b6ecf, 0x9c9ede,
    0x637939, 0x8ca252, 0xb5cf6b, 0xcedb9c,
    0x8c6d31, 0xbd9e39, 0xe7ba52, 0xe7cb94,
    0x843c39, 0xad494a, 0xd6616b, 0xe7969c,
    0x7b4173, 0xa55194, 0xce6dbd, 0xde9ed6
  ];
  
  static final List<int> _category20c = [
    0x3182bd, 0x6baed6, 0x9ecae1, 0xc6dbef,
    0xe6550d, 0xfd8d3c, 0xfdae6b, 0xfdd0a2,
    0x31a354, 0x74c476, 0xa1d99b, 0xc7e9c0,
    0x756bb1, 0x9e9ac8, 0xbcbddc, 0xdadaeb,
    0x636363, 0x969696, 0xbdbdbd, 0xd9d9d9
  ];
  
  static final List<int> _gar = [
    0x109933, 0xffcc00, 0xff0000, 0xBBBBBB, 0x909090, 0x505050 
  ];

  static final List<int> _brewer9 = [
    0xe41a1c,
    0x377eb8,
    0x4daf4a,
    0x984ea3,
    0xff7f00,
    0xffff33,
    0xa65628,
    0xf781bf,
    0x999999
  ];
  
  static final List<int> _brewerSequential = [
    0xfff7fb,
    0xece7f2,
    0xd0d1e6,
    0xa6bddb,
    0x74a9cf,
    0x3690c0,
    0x0570b0,
    0x045a8d,
    0x023858
  ];

  static final List<int> _kite = [
    0x415A6C,
    0xEA3592,
    0x5A186B,
    0xE6E8ED,
    0x25B1E6,
    0x333391,
    0xCDD2DA,
    0x96D22D,
    0x009933,
    0x009AA6,
    0x66BDC9,
    0xFFCC00,
    0xFF6428,
    0xC60C30
  ];

  static Ordinal get category10 => new Ordinal(range: _category10);
  static Ordinal get category20 => new Ordinal(range: _category20);
  static Ordinal get category20b => new Ordinal(range: _category20b);
  static Ordinal get category20c => new Ordinal(range: _category20c);
  static Ordinal get gar => new Ordinal(range: _gar);
  static Ordinal get brewer9 => new Ordinal(range: _brewer9);
  static Ordinal get brewerSequential => new Ordinal(range: _brewerSequential);
  static Ordinal get kite => new Ordinal(range: _kite);
  static Ordinal get kiteReversed => new Ordinal(range: _kite.reversed.toList());

  static Ordinal ordinal() {
    return new Ordinal();
  }
}
