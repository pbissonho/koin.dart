/*
 * Copyright 2017-2018 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:koin/src/core/definition/bean_definition.dart';
import 'package:koin/src/error/exceptions.dart';
import 'package:kt_dart/collection.dart';

import '../logger.dart';
import '../module.dart';
import '../qualifier.dart';

/*
 * Bean Registry
 * declare/find definitions
 *
 * @author - Arnaud GIULIANI
 * 
 * Ported to Dart from Kotlin by:
 * @author - Pedro Bissonho 
 */

class BeanRegistry {
  final definitions = KtHashSet<BeanDefinition>.empty();
  final definitionsNames = KtHashMap<String, BeanDefinition>.empty();
  final definitionsPrimaryTypes = KtHashMap<Type, BeanDefinition>.empty();
  final definitionsSecondaryTypes =
      KtHashMap<Type, List<BeanDefinition>>.empty();
  final definitionsToCreate = KtHashSet<BeanDefinition>.empty();

  ///
  /// Load definitions from a Module
  /// @param modules
  ///
  void loadModules(Iterable<Module> modules) {
    modules.forEach((module) {
      saveDefinitions(module);
    });
  }

  ///
  ///unload definitions from a Module
  /// @param modules
  ///
  void unloadModules(Iterable<Module> modules) {
    modules.forEach((module) {
      removeDefinitions(module);
    });
  }

  void removeDefinitions(Module module) {
    module.definitions.forEach((definition) {
      removeDefinition(definition);
    });
  }

  void saveDefinitions(Module module) {
    module.definitions.forEach((definition) {
      saveDefinition(definition);
    });
  }

  ///
  /// retrieve all definitions
  /// @return definitions
  ///
  KtSet<BeanDefinition> getAllDefinitions() => definitions;

  ///
  /// Remove a definition
  /// @param definition
  ///
  void removeDefinition(BeanDefinition definition) {
    definition.intance.close();
    definitions.remove(definition);
    if (definition.qualifier != null) {
      removeDefinitionForName(definition);
    } else {
      removeDefinitionForTypes(definition);
    }
    removeDefinitionForSecondaryTypes(definition);
  }

  ///
  /// Save a definition
  /// @param definition
  ///
  void saveDefinition(BeanDefinition definition) {
    definitions.add(definition);
    definition.createInstanceHolder();
    if (definition.qualifier != null) {
      saveDefinitionForName(definition);
    } else {
      saveDefinitionForTypes(definition);
    }
    if (definition.secondaryTypes.isNotEmpty) {
      saveDefinitionForSecondaryTypes(definition);
    }
    if (definition.options.isCreatedAtStart) {
      saveDefinitionForStart(definition);
    }
  }

  void removeDefinitionForSecondaryTypes(BeanDefinition definition) {
    definition.secondaryTypes.forEach((type) {
      removeDefinitionForSecondaryType(definition, type);
    });
  }

  void removeDefinitionForSecondaryType(BeanDefinition definition, Type type) {
    var removed = definitionsSecondaryTypes[type].remove(definition);
    if (logger.isAt(Level.debug) && removed) {
      logger.info("unbind secondary type:'${type.toString()}' ~ $definition");
    }
  }

  void removeDefinitionForTypes(BeanDefinition definition) {
    var key = definition.primaryType;
    if (definitionsPrimaryTypes[key] == definition) {
      definitionsPrimaryTypes.remove(key);
      if (logger.isAt(Level.debug)) {
        Logger.logger
            .info("unbind type:'${definition.primaryType}' ~ $definition");
      }
    }
  }

  List<BeanDefinition> createSecondaryType(Type type) {
    definitionsSecondaryTypes[type] = List<BeanDefinition>();
    return definitionsSecondaryTypes[type];
  }

  void saveDefinitionForStart(BeanDefinition definition) {
    definitionsToCreate.add(definition);
  }

  void addDefinition(BeanDefinition definition) {
    var added = definitions.add(definition);
    if (!added && !definition.options.override) {
      throw DefinitionOverrideException(
          "Already existing definition or try to override an existing one: $definition");
    }
    // definition.primaryType.saveCache();
  }

  void saveDefinitionForTypes(BeanDefinition definition) {
    saveDefinitionForType(definition, definition.primaryType);
  }

  void saveDefinitionForSecondaryTypes(BeanDefinition definition) {
    definition.secondaryTypes.forEach((type) {
      saveDefinitionForSecondaryType(definition, type);
    });
  }

  void saveDefinitionForSecondaryType(BeanDefinition definition, Type type) {
    var secondaryTypeDefinitions = definitionsSecondaryTypes[type];
    if (secondaryTypeDefinitions == null) {
      secondaryTypeDefinitions = createSecondaryType(type);
    }
    if (secondaryTypeDefinitions.contains(definition)) {
      secondaryTypeDefinitions[secondaryTypeDefinitions.indexOf(definition)] =
          definition;
    } else {
      secondaryTypeDefinitions.add(definition);
    }
    if (logger.isAt(Level.info)) {
      logger.info("bind secondary type:'${type.toString()}' ~ $definition");
    }
  }

  void saveDefinitionForType(BeanDefinition definition, Type type) {
    var registed = definitionsPrimaryTypes[type];
    if (registed != null && !definition.options.override) {
      throw DefinitionOverrideException(
          """Already existing definition or try to override an existing one with 
            type'${type.toString()}' and $definition but has already registered 
            ${registed}""");
    } else {
      definitionsPrimaryTypes[type] = definition;
      if (logger.isAt(Level.info)) {
        logger.info("bind type:'${type.toString()}' ~ $definition");
      }
    }
  }

  void removeDefinitionForName(BeanDefinition definition) {
    if (definition.qualifier != null) {
      var key = definition.qualifier.toString();
      if (definitionsNames[key] == definition) {
        definitionsNames.remove(key);
        if (logger.isAt(Level.debug)) {
          logger.info("unbind qualifier:'$key' ~ $definition");
        }
      }
    }
  }

  void saveDefinitionForName(BeanDefinition definition) {
    if (definition.qualifier != null) {
      var key = definition.qualifier.toString();
      BeanDefinition definitionName = definitionsNames[key];
      if (definitionName != null && !definition.options.override) {
        throw DefinitionOverrideException(
            "Already existing definition or try to override an existing one with qualifier '${definitionName}");
      } else {
        definitionsNames[key] = definition;
        if (logger.isAt(Level.info)) {
          logger.info("bind qualifier:'${definition.qualifier}' ~ $definition");
        }
      }
    }
  }

  KtSet<BeanDefinition> findAllDefinition() {
    return definitions;
  }

  ///
  /// Find a definition
  ///@param qualifier
  /// @param clazz
  ///
  BeanDefinition findDefinition(
    Qualifier qualifier,
    Type type,
  ) {
    // Todo
    // Verificar a ordem
    var byType = findDefinitionByType(type);

    if (byType != null) return byType;

    byType = findDefinitionBySecondaryType(type);
    if (byType != null) return byType;

    if (qualifier != null) {
      return findDefinitionByName(qualifier.toString());
    }
  }

  BeanDefinition findDefinitionByType(Type type) {
    return definitionsPrimaryTypes[type];
  }

  BeanDefinition findDefinitionBySecondaryType(Type type) {
    var foundTypes = definitionsSecondaryTypes[type];

    if (foundTypes != null && foundTypes.length == 1) {
      return foundTypes[0];
    } else if (foundTypes != null && foundTypes.length > 1) {
      throw NoBeanDefFoundException(
          "Found multiple definitions for type '${type.toString()}': $foundTypes. Please use the 'bind<P,S>()' function to bind your instance from primary and secondary types.");
    } else {
      return null;
    }
  }

  BeanDefinition findDefinitionByName(String name) {
    return definitionsNames[name];
  }

  KtSet<BeanDefinition> findAllCreatedAtStartDefinition() {
    return definitionsToCreate;
  }

  ///
  /// Total number of definitions
  ///
  int size() => definitions.size;

  ///
  /// Retrieve a definition
  /// @param clazz
  ///
  BeanDefinition getDefinition(Type type) {
    return definitions.firstOrNull((definition) {
      return definition.primaryType == type ||
          definition.secondaryTypes.contains(type);
    });
  }

  void close() {
    definitions.forEach((defi) => defi.close());
    definitions.clear();
    definitionsNames.clear();
    definitionsPrimaryTypes.clear();
    definitionsToCreate.clear();
  }

  ///
  /// Find all definition compatible with given type
  ///
  getDefinitionsForClass(Type type) {
    getAllDefinitions().filter((it) =>
        it.primaryType == type ||
        it.secondaryTypes.contains(type) && !it.hasScopeSet());
  }
}
/*
class BeanRegistry {
  final definitions = List<BeanDefinition>();
  final definitionsNames = Map<String, BeanDefinition>();
  final definitionsPrimaryTypes = Map<Type, BeanDefinition>();
  final definitionsSecondaryTypes = Map<Type, List<BeanDefinition>>();
  final definitionsToCreate = List<BeanDefinition>();

  ///
  /// Load definitions from a Module
  /// @param modules
  ///
  void loadModules(Iterable<Module> modules) {
    modules.forEach((module) {
      saveDefinitions(module);
    });
  }

  ///
  ///unload definitions from a Module
  /// @param modules
  ///
  void unloadModules(Iterable<Module> modules) {
    modules.forEach((module) {
      removeDefinitions(module);
    });
  }

  void removeDefinitions(Module module) {
    module.definitions.forEach((definition) {
      removeDefinition(definition);
    });
  }

  void saveDefinitions(Module module) {
    module.definitions.forEach((definition) {
      saveDefinition(definition);
    });
  }

  ///
  /// retrieve all definitions
  /// @return definitions
  ///
  List<BeanDefinition> getAllDefinitions() => definitions;

  ///
  /// Remove a definition
  /// @param definition
  ///
  void removeDefinition(BeanDefinition definition) {
    definition.intance.close();
    definitions.remove(definition);
    if (definition.qualifier != null) {
      removeDefinitionForName(definition);
    } else {
      removeDefinitionForTypes(definition);
    }
    removeDefinitionForSecondaryTypes(definition);
  }

  ///
  /// Save a definition
  /// @param definition
  ///
  void saveDefinition(BeanDefinition definition) {
    definitions.add(definition);
    definition.createInstanceHolder();
    if (definition.qualifier != null) {
      saveDefinitionForName(definition);
    } else {
      saveDefinitionForTypes(definition);
    }
    if (definition.secondaryTypes.isNotEmpty) {
      saveDefinitionForSecondaryTypes(definition);
    }
    if (definition.options.isCreatedAtStart) {
      saveDefinitionForStart(definition);
    }
  }

  void removeDefinitionForSecondaryTypes(BeanDefinition definition) {
    definition.secondaryTypes.forEach((type) {
      removeDefinitionForSecondaryType(definition, type);
    });
  }

  void removeDefinitionForSecondaryType(BeanDefinition definition, Type type) {
    var removed = definitionsSecondaryTypes[type].remove(definition);
    if (logger.isAt(Level.debug) && removed) {
      logger.info("unbind secondary type:'${type.toString()}' ~ $definition");
    }
  }

  void removeDefinitionForTypes(BeanDefinition definition) {
    var key = definition.primaryType;
    if (definitionsPrimaryTypes[key] == definition) {
      definitionsPrimaryTypes.remove(key);
      if (logger.isAt(Level.debug)) {
        Logger.logger
            .info("unbind type:'${definition.primaryType}' ~ $definition");
      }
    }
  }

  List<BeanDefinition> createSecondaryType(Type type) {
    definitionsSecondaryTypes[type] = List<BeanDefinition>();
    return definitionsSecondaryTypes[type];
  }

  void saveDefinitionForStart(BeanDefinition definition) {
    definitionsToCreate.add(definition);
  }

  void addDefinition(BeanDefinition definition) {
    var added = definitions.add(definition);
    //if (!added && !definition.options.override) {
    //  throw DefinitionOverrideException(
    //      "Already existing definition or try to override an existing one: $definition");
    //}
    // definition.primaryType.saveCache();
  }

  void saveDefinitionForTypes(BeanDefinition definition) {
    saveDefinitionForType(definition, definition.primaryType);
  }

  void saveDefinitionForSecondaryTypes(BeanDefinition definition) {
    definition.secondaryTypes.forEach((type) {
      saveDefinitionForSecondaryType(definition, type);
    });
  }

  void saveDefinitionForSecondaryType(BeanDefinition definition, Type type) {
    var secondaryTypeDefinitions = definitionsSecondaryTypes[type];
    if (secondaryTypeDefinitions == null) {
      secondaryTypeDefinitions = createSecondaryType(type);
    }
    if (secondaryTypeDefinitions.contains(definition)) {
      secondaryTypeDefinitions[secondaryTypeDefinitions.indexOf(definition)] =
          definition;
    } else {
      secondaryTypeDefinitions.add(definition);
    }
    if (logger.isAt(Level.info)) {
      logger.info("bind secondary type:'${type.toString()}' ~ $definition");
    }
  }

  void saveDefinitionForType(BeanDefinition definition, Type type) {
    var registed = definitionsPrimaryTypes[type];
    if (registed != null && !definition.options.override) {
      throw DefinitionOverrideException(
          """Already existing definition or try to override an existing one with 
            type'${type.toString()}' and $definition but has already registered 
            ${registed}""");
    } else {
      definitionsPrimaryTypes[type] = definition;
      if (logger.isAt(Level.info)) {
        logger.info("bind type:'${type.toString()}' ~ $definition");
      }
    }
  }

  void removeDefinitionForName(BeanDefinition definition) {
    if (definition.qualifier != null) {
      var key = definition.qualifier.toString();
      if (definitionsNames[key] == definition) {
        definitionsNames.remove(key);
        if (logger.isAt(Level.debug)) {
          logger.info("unbind qualifier:'$key' ~ $definition");
        }
      }
    }
  }

  void saveDefinitionForName(BeanDefinition definition) {
    if (definition.qualifier != null) {
      var key = definition.qualifier.toString();
      BeanDefinition definitionName = definitionsNames[key];
      if (definitionName != null && !definition.options.override) {
        throw DefinitionOverrideException(
            "Already existing definition or try to override an existing one with qualifier '${definitionName}");
      } else {
        definitionsNames[key] = definition;
        if (logger.isAt(Level.info)) {
          logger.info("bind qualifier:'${definition.qualifier}' ~ $definition");
        }
      }
    }
  }

  List<BeanDefinition> findAllDefinition() {
    return definitions;
  }

  ///
  /// Find a definition
  ///@param qualifier
  /// @param clazz
  ///
  BeanDefinition findDefinition(
    Qualifier qualifier,
    Type type,
  ) {
    if (qualifier != null) {
      return findDefinitionByName(qualifier.toString());
    } else {
      var byType = findDefinitionByType(type);

      if (byType == null) {
        byType = findDefinitionBySecondaryType(type);
      }

      return byType;
    }
  }

  BeanDefinition findDefinitionByType(Type type) {
    return definitionsPrimaryTypes[type];
  }

  BeanDefinition findDefinitionBySecondaryType(Type type) {
    var foundTypes = definitionsSecondaryTypes[type];

    if (foundTypes != null && foundTypes.length == 1) {
      return foundTypes[0];
    } else if (foundTypes != null && foundTypes.length > 1) {
      throw NoBeanDefFoundException(
          "Found multiple definitions for type '${type.toString()}': $foundTypes. Please use the 'bind<P,S>()' function to bind your instance from primary and secondary types.");
    } else {
      return null;
    }
  }

  BeanDefinition findDefinitionByName(String name) {
    return definitionsNames[name];
  }

  List<BeanDefinition> findAllCreatedAtStartDefinition() {
    return definitionsToCreate;
  }

  ///
  /// Total number of definitions
  ///
  int size() => definitions.length;

  ///
  /// Retrieve a definition
  /// @param clazz
  ///
  BeanDefinition getDefinition(Type type) {
    return definitions.firstWhere((definition) {
      return definition.primaryType == type ||
          definition.secondaryTypes.contains(type);
    });
  }

  void close() {
    definitions.forEach((defi) => defi.close());
    definitions.clear();
    definitionsNames.clear();
    definitionsPrimaryTypes.clear();
    definitionsToCreate.clear();
  }

  ///
  /// Find all definition compatible with given type
  ///
  getDefinitionsForClass(Type type) {
    getAllDefinitions().where((it) =>
        it.primaryType == type ||
        it.secondaryTypes.contains(type) && !it.hasScopeSet());
  }
}
*/
