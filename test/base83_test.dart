import 'package:blurhash/blurhash.dart';
import 'package:test/test.dart';

void main() {
  test('Decode base83 empty string', () async {
    int result = Base83.decode('');
    expect(result, 0);
  });

  test('Decode base83 "foobar"', () async {
    int result = Base83.decode('foobar');
    expect(result, 163902429697);
  });

  test('Decode base83 "LFE.@D9F01_2%L%MIVD*9Goe-;WB"', () async {
    int result = Base83.decode(r'LFE.@D9F01_2%L%MIVD*9Goe-;WB');
    expect(result, -1597651267176502418);
  });
}
