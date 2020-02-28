part of blurhash;

/// Encoder class for the blur hash.
class Decoder {
  /// Decode a given Base83 string into a Uint8List representing the image.
  static Uint8List decode(String blurHash, int width, int height,
      {double punch = 1.0}) {
    if (blurHash == null || blurHash.length < 6) {
      return null;
    }
    int numCompEnc = Base83.decode(blurHash, from: 0, to: 1);
    int numCompX = (numCompEnc % 9) + 1;
    int numCompY = ((numCompEnc / 9) + 1).floor();
    if (blurHash.length != 4 + 2 * numCompX * numCompY) {
      return null;
    }
    int maxAcEnc = Base83.decode(blurHash, from: 1, to: 2);
    double maxAc = (maxAcEnc + 1) / 166.0;

    List<List<double>> colors = List<List<double>>((numCompX * numCompY));
    for (int i = 0; i < colors.length; i++) {
      if (i == 0) {
        int colorEnc = Base83.decode(blurHash, from: 2, to: 6);
        colors[i] = _decodeDc(colorEnc);
      } else {
        int from = 4 + i * 2;
        int colorEnc = Base83.decode(blurHash, from: from, to: from + 2);
        colors[i] = _decodeAc(colorEnc, maxAc * punch);
      }
    }
    Uint8List bitmap =
        _composeBitmap(width, height, numCompX, numCompY, colors);
    _RGBA32BitmapHeader header =
        _RGBA32BitmapHeader(bitmap.length, width, height);

    return header.appendContent(bitmap);
  }

  /// Decode a given Base63 string into a dart:ui Image
  static Future<ui.Image> decodeAsImage(String blurHash, int width, int height,
      {double punch = 1.0}) async {
    Uint8List list = decode(blurHash, width, height, punch: punch);

    return ui
        .instantiateImageCodec(list, targetWidth: width, targetHeight: height)
        .then((ui.Codec c) => c.getNextFrame())
        .then((ui.FrameInfo i) => i.image);
  }

  static List<double> _decodeDc(final int colorEnc) {
    final int r = colorEnc >> 16;
    final int g = (colorEnc >> 8) & 255;
    final int b = colorEnc & 255;
    return <double>[_srgbToLinear(r), _srgbToLinear(g), _srgbToLinear(b)];
  }

  static double _srgbToLinear(final int colorEnc) {
    final double v = colorEnc / 255.0;

    if (v <= 0.04045) {
      return (v / 12.92);
    } else {
      return pow((v + 0.055) / 1.055, 2.4).toDouble();
    }
  }

  static List<double> _decodeAc(int value, double maxAc) {
    double r = value / (19 * 19).floor();
    double g = (value / 19) % 19.floor();
    int b = value % 19;
    return <double>[
      _signedPow2((r - 9) / 9.0) * maxAc,
      _signedPow2((g - 9) / 9.0) * maxAc,
      _signedPow2((b - 9) / 9.0) * maxAc
    ];
  }

  static int _linearToSrgb(double value) {
    double v;
    if (value > 1) {
      v = 1.0;
    } else if (value < 0) {
      v = 0.0;
    } else {
      v = value;
    }
    if (v <= 0.0031308) {
      return (v * 12.92 * 255 + 0.5).round();
    } else {
      return ((1.055 * pow(v, 1 / 2.4) - 0.055) * 255 + 0.5).round();
    }
  }

  static double _signedPow2(double value) {
    return value.sign * pow(value.abs(), 2.0);
  }

  static Uint8List _composeBitmap(int width, int height, int numCompX,
      int numCompY, List<List<double>> colors) {
    Int32List list = Int32List(width * height);
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        double r = 0.0;
        double g = 0.0;
        double b = 0.0;
        for (int j = 0; j < numCompY; j++) {
          for (int i = 0; i < numCompX; i++) {
            double basis =
                (cos(math.pi * x * i / width) * cos(math.pi * y * j / height))
                    .toDouble();
            List<double> color = colors[j * numCompX + i];
            r += color[0] * basis;
            g += color[1] * basis;
            b += color[2] * basis;
          }
        }
        int index = y * width + x;
        ui.Color color = ui.Color.fromRGBO(
            _linearToSrgb(b), _linearToSrgb(g), _linearToSrgb(r), 1.0);
        list[index] = color.value;
      }
    }
    return list.buffer.asUint8List();
  }
}

const int _RGBA32HeaderSize = 122;

class _RGBA32BitmapHeader {
  final int contentSize;
  Uint8List headerIntList;

  /// Create a new RGBA32 header
  _RGBA32BitmapHeader(this.contentSize, int width, int height) {
    final int fileLength = contentSize + _RGBA32HeaderSize;
    headerIntList = Uint8List(fileLength);
    headerIntList.buffer.asByteData()
      ..setUint8(0x0, 0x42)
      ..setUint8(0x1, 0x4d)
      ..setInt32(0x2, fileLength, Endian.little)
      ..setInt32(0xa, _RGBA32HeaderSize, Endian.little)
      ..setUint32(0xe, 108, Endian.little)
      ..setUint32(0x12, width, Endian.little)
      ..setUint32(0x16, -height, Endian.little)
      ..setUint16(0x1a, 1, Endian.little)
      ..setUint32(0x1c, 32, Endian.little)
      ..setUint32(0x1e, 3, Endian.little)
      ..setUint32(0x22, contentSize, Endian.little)
      ..setUint32(0x36, 0x000000ff, Endian.little)
      ..setUint32(0x3a, 0x0000ff00, Endian.little)
      ..setUint32(0x3e, 0x00ff0000, Endian.little)
      ..setUint32(0x42, 0xff000000, Endian.little);
  }

  Uint8List appendContent(Uint8List contentIntList) {
    headerIntList.setRange(
      _RGBA32HeaderSize,
      contentSize + _RGBA32HeaderSize,
      contentIntList,
    );

    return headerIntList;
  }
}
