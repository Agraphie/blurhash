part of blurhash;

/// Implementation for the custom Base83 algorithm. See https://github.com/woltapp/blurhash/blob/master/Algorithm.md#base-83.
class Base83 {
  /// Decode a given string from position to position from a valid Base63.
  static int decode(String str, {int from = 0, int to = -1}) {
    int result = 0;
    if (to == -1) {
      to = str.length;
    }
    for (int i = from; i < to; i++) {
      int index = _charMap[str[i]] ?? -1;
      if (index != -1) {
        result = result * 83 + index;
      }
    }
    return result;
  }

  static const Map<String, int> _charMap = <String, int>{
    '0': 0,
    '1': 1,
    '2': 2,
    '3': 3,
    '4': 4,
    '5': 5,
    '6': 6,
    '7': 7,
    '8': 8,
    '9': 9,
    'A': 10,
    'B': 11,
    'C': 12,
    'D': 13,
    'E': 14,
    'F': 15,
    'G': 16,
    'H': 17,
    'I': 18,
    'J': 19,
    'K': 20,
    'L': 21,
    'M': 22,
    'N': 23,
    'O': 24,
    'P': 25,
    'Q': 26,
    'R': 27,
    'S': 28,
    'T': 29,
    'U': 30,
    'V': 31,
    'W': 32,
    'X': 33,
    'Y': 34,
    'Z': 35,
    'a': 36,
    'b': 37,
    'c': 38,
    'd': 39,
    'e': 40,
    'f': 41,
    'g': 42,
    'h': 43,
    'i': 44,
    'j': 45,
    'k': 46,
    'l': 47,
    'm': 48,
    'n': 49,
    'o': 50,
    'p': 51,
    'q': 52,
    'r': 53,
    's': 54,
    't': 55,
    'u': 56,
    'v': 57,
    'w': 58,
    'x': 59,
    'y': 60,
    'z': 61,
    '#': 62,
    r'$': 63,
    '%': 64,
    '*': 65,
    '+': 66,
    ',': 67,
    '-': 68,
    '.': 69,
    ':': 70,
    ';': 71,
    '=': 72,
    '?': 73,
    '@': 74,
    '[': 75,
    ']': 76,
    '^': 77,
    '_': 78,
    '{': 79,
    '|': 80,
    '}': 81,
    '~': 82,
  };
}
