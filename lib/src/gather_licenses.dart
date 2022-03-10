import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:async/async.dart';

import 'logger.dart';
import 'storage/license.dart';
import 'storage/gathered_license.dart';
import 'storage/located_dependency.dart';

/// Gather all licenses of provided packages
///
/// This will inspect the locations of packages and try to find the corresponding license.
/// The result will be a Map <Name, License text>.
Future<Map<String, GatheredLicense>> gatherLicenses(
  List<LocatedDependency> packages,
) async {
  final located = FutureGroup<MapEntry<String, GatheredLicense>>();

  for (final LocatedDependency package in packages) {
    located.add(_gatherLicense(package));
  }
  located.close();

  return Map.fromEntries(await located.future);
}

/// Gather the license for a specific package
///
/// Used as an extra function to allow concurrent I/O
Future<MapEntry<String, GatheredLicense>> _gatherLicense(
  LocatedDependency package,
) async {
  // Iterate over all files in the root of the package to find license file
  final dir = Directory(package.path);
  if (!await dir.exists()) {
    logger.severe(
      "Assumed location for package '${package.name}' does not exist: '${package.path}'",
    );
    return MapEntry(
      package.name,
      GatheredLicense.fromLocatedDependency(package, License.notFound()),
    );
  }

  List<File> candidates = await _getCandidates(dir);
  if (candidates.isEmpty) {
    logger.severe(
      "Could not find license file for '${package.name}' in '${package.path}'",
    );
  } else if (candidates.length > 1) {
    logger.severe(
      "Found ${candidates.length} license files for '${package.name}' in '${package.path}'",
    );
  } else {
    return MapEntry(
      package.name,
      GatheredLicense.fromLocatedDependency(
        package,
        License(await candidates[0].readAsString()),
      ),
    );
  }

  return MapEntry(
    package.name,
    GatheredLicense.fromLocatedDependency(package, License.notFound()),
  );
}

/// Get all potential license files in given directory
///
/// This is implemented a bit more complex to allow parallel processing
/// (not blocking for io so often).
Future<List<File>> _getCandidates(Directory dir) async {
  final List<File> candidates = [];
  final completer = Completer<List<File>>();
  dir
      // List all files and folders
      .list(recursive: false)
      // Filter for candidates
      .where(
        (entity) =>
            entity is File &&
            _licenseNameRegex.hasMatch(p.basename(entity.path)),
      )
      // Wait for dir to be scanned
      .listen(
        (entity) => candidates.add(entity as File),
        onDone: () => completer.complete(candidates),
      );

  return completer.future;
}

final _licenseNameRegex = RegExp(
  r'^license(?:\.[^\n\r ]*)?$',
  caseSensitive: false,
);
