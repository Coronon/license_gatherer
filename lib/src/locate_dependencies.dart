import 'dart:convert';
import 'dart:io';

import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:path/path.dart' as p;

import 'storage/located_dependency.dart';

/// Locate all dependencies of a 'pubspec.yaml' (Name, Version, Path)
List<LocatedDependency> locateDependencies(String pubSpecFilePath) {
  //* Check file exists and convert to PubSpec
  final pubSpecFile = File(pubSpecFilePath);
  if (!pubSpecFile.existsSync()) {
    throw ArgumentError(
      'Provided path to pubspec.yaml invalid - file does not exist',
    );
  }
  final pubSpec = Pubspec.parse(pubSpecFile.readAsStringSync());

  // Get corresponding package_config.json and parse it
  final packageConfigFile = File(
    p.join(p.dirname(pubSpecFilePath), '.dart_tool', 'package_config.json'),
  );
  if (!packageConfigFile.existsSync()) {
    throw ArgumentError(
      'Could not discover .dart_tool/package_config.json in same directory as pubspec.yaml',
    );
  }
  _Packages packages = _parsePackages(packageConfigFile);

  //* Find names of production dependencies and resolve their paths
  return pubSpec.dependencies.entries.map<LocatedDependency>(
    (MapEntry<String, Dependency> entry) {
      final name = entry.key;
      final dependency = entry.value;
      final String? path = packages[name];
      if (path == null) {
        throw StateError("Package '$name' not in package_config.json");
      }
      final String? version = _getVersionFromPath(path);

      // Determine dependency type
      if (dependency is HostedDependency) {
        return LocatedDependency(name, version, path);
      } else if (dependency is PathDependency) {
        return LocatedDependency(name, version, dependency.path);
      } else if (dependency is GitDependency) {
        return LocatedDependency(name, version, path);
      } else if (dependency is SdkDependency) {
        return LocatedDependency(name, version, path);
      }

      throw ArgumentError("Package '$name' has invalid type");
    },
  ).toList();
}

/// Try to determine package version from path
///
/// Attempts to read from end of package path e.g. '.../some_package-1.2.3'
String? _getVersionFromPath(String path) {
  return RegExp(r'^[^-]*-(.*)$').firstMatch(p.basename(path))?.group(1);
}

/// Parse 'package_config.json' to a Map of <Name, Path>
_Packages _parsePackages(File packagesFile) {
  Map<String, dynamic> json = jsonDecode(packagesFile.readAsStringSync());
  if (!json.containsKey('configVersion') || json['configVersion'] != 2) {
    throw ArgumentError(
      "package_config version '${json['configVersion']}' is not supported",
    );
  }

  return Map.fromEntries(
    (json['packages'] as List).map(
      (package) => MapEntry(
        package['name'] as String,
        (package['rootUri'] as String)
            .replaceFirst('file:///', '')
            .replaceFirst('file://', ''),
      ),
    ),
  );
}

/// Map of <Name, Path>
typedef _Packages = Map<String, String>;
