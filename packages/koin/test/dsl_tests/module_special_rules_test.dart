import 'package:koin/koin.dart';
import 'package:test/test.dart';

void main() {
  test('generic type declaration', () {
    var koin = koinApplication((app) {
      app.modules([module()..single((s) => <String>[])]);
    }).koin;

    expect(koin.get<List<String>>(), isNotNull);
  });

  // TODO
  // Check for correct functioning.
  test('generic types declaration', () {
    var koin = koinApplication((app) {
      app.modules([
        module()
          ..single((s) => <String>[], qualifier: named("strings"))
          ..single((s) => <int>[], qualifier: named("ints"))
      ]);
    }).koin;

    var strings = koin.get<List<String>>(named("strings"));
    strings.add("test");
    expect(1, koin.get<List<String>>(named("strings")).length);
    expect(0, koin.get<List<int>>(named("ints")).length);
  });
}
/*
class ModuleSpecialRulesTest {


    @Test
    fun `generic types declaration`() {
        val koin = koinApplication {
            modules(module {
                single(named("strings")) { arrayListOf<String>() }
                single(named("ints")) { arrayListOf<Int>() }
            })
        }.koin

        val strings = koin.get<ArrayList<String>>(named("strings"))
        strings.add("test")

        assertEquals(1, koin.get<ArrayList<String>>(named("strings")).size)

        assertEquals(0, koin.get<ArrayList<String>>(named("ints")).size)
    }
}*/
