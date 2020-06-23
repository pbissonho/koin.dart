import 'package:koin/koin.dart';
import 'package:test/test.dart';
import 'package:kt_dart/kt.dart';
import '../components.dart';

void main() {
  var scopeKey = named("KEY");

  test('can declare a scoped definition', () {
    var koin = koinApplication((app) {
      app.module(module()
        ..scopeWithType(scopeKey, (s) {
          s.scoped((s) => ComponentA());
        }));
    }).koin;

    var def = koin.scopeRegistry.scopeDefinitions.values
        .first((def) => def.qualifier == scopeKey);
    expect(def.qualifier, scopeKey);

    var scope = koin.createScope("id", scopeKey);
    expect(scope.scopeDefinition, def);
  });

  test('can declare 2 scoped definitions from same type without naming', () {
    var koin = koinApplication((app) {
      app.module(module()
        ..scopeWithType(named("A"), (s) {
          s.scoped((s) => ComponentA());
        })
        ..scopeWithType(named("B"), (s) {
          s.scoped((s) => ComponentA());
        }));
    }).koin;

    var defA = koin.scopeRegistry.scopeDefinitions.values
        .first((def) => def.qualifier == named("A"));
    expect(defA.qualifier, StringQualifier("A"));

    var defB = koin.scopeRegistry.scopeDefinitions.values
        .first((def) => def.qualifier == named("B"));
    expect(defB.qualifier, StringQualifier("B"));

    var scopeA = koin.createScope("A", named("A")).get<ComponentA>();
    var scopeB = koin.createScope("B", named("B")).get<ComponentA>();
    expect(true, scopeA != scopeB);
  });
}

/*

    @Test
    fun `can declare 2 scoped definitions from same type without naming`() {
        val koin = koinApplication {
            modules(
                    module {
                        scope(named("B")) {
                            scoped { Simple.ComponentA() }
                        }
                        scope(named("A")) {
                            scoped { Simple.ComponentA() }
                        }
                    }
            )
        }.koin
        val defA = koin._scopeRegistry.scopeDefinitions.values.first { def -> def.qualifier == _q("A") }
        assertTrue(defA.qualifier == StringQualifier("A"))

        val defB = koin._scopeRegistry.scopeDefinitions.values.first { def -> def.qualifier == _q("B") }
        assertTrue(defB.qualifier == StringQualifier("B"))

        val scopeA = koin.createScope("A", named("A")).get<Simple.ComponentA>()
        val scopeB = koin.createScope("B", named("B")).get<Simple.ComponentA>()
        assertNotEquals(scopeA, scopeB)
    }

    @Test
    fun `can declare a scope definition`() {
        val koin = koinApplication {
            modules(
                    module {
                        scope(scopeKey) {
                        }
                    }
            )
        }.koin
        val def = koin._scopeRegistry.scopeDefinitions.values.first { def -> def.qualifier == scopeKey }
        assertTrue(def.qualifier == scopeKey)
    }

    @Test
    fun `can't declare 2 scoped same definitions`() {
        try {
            koinApplication {
                printLogger(Level.DEBUG)
                modules(
                        module {
                            scope(scopeKey) {
                                scoped { Simple.ComponentA() }
                                scoped { Simple.ComponentA() }
                            }
                        }
                )
            }
            fail()
        } catch (e: DefinitionOverrideException) {
            e.printStackTrace()
        }
    }
}

 */
