import 'package:koin/koin.dart';
import 'package:test/test.dart';

import '../components.dart';

void main() {
  test('can resolve naming from root', () {
    var scopeName = named("MY_SCOPE");

    var koin = koinApplication((app) {
      app.module(module()
        ..single((s) => MySingle(24), qualifier: named('24'))
        ..scopeWithType(scopeName, (s) {
          s.scoped((s) => MySingle(42));
        }));
    }).koin;

    var scope = koin.createScopeWithQualifier("myScope", scopeName);
    expect(24, scope.get<MySingle>(named("24")).id);
    expect(42, scope.get<MySingle>().id);
  });
}

enum MyNames { myScope, myString }

/*
class NamingTest {

    @Test
    fun `enum naming`() {
        assertEquals("my_string",named(MyNames.MY_STRING).value)
    }

    @Test
    fun `can resolve enum naming`() {
        val koin = koinApplication {
            modules(module {
                single(named(MyNames.MY_STRING)) { Simple.MySingle(24) }

            })
        }.koin

        assertEquals(24, koin.get<Simple.MySingle>(named(MyNames.MY_STRING)).id)
    }

    @Test
    fun `can resolve scope enum naming`() {
        val scopeName = named(MyNames.MY_SCOPE)
        val koin = koinApplication {
            modules(module {

                scope(scopeName) {
                    scoped { Simple.MySingle(42) }
                }
            })
        }.koin

        val scope = koin.createScope("myScope", scopeName)
        assertEquals(42, scope.get<Simple.MySingle>().id)
    }

    @Test
    fun `can resolve naming with q`() {
        val scopeName = _q("MY_SCOPE")
        val koin = koinApplication {
            modules(module {

                single(_q("24")) { Simple.MySingle(24) }

                scope(scopeName) {
                    scoped { Simple.MySingle(42) }
                }
            })
        }.koin

        val scope = koin.createScope("myScope", scopeName)
        assertEquals(24, scope.get<Simple.MySingle>(named("24")).id)
        assertEquals(42, scope.get<Simple.MySingle>().id)
    }
}

enum class MyNames {
    MY_SCOPE,
    MY_STRING
}*/
