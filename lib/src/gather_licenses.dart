import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;

import 'located_dependency.dart';

/// Gather all licenses of provided packages
///
/// This will inspect the locations of packages and try to find the corresponding license.
/// The result will be a Map <Name, License text>.
Future<Map<String, String>> gatherLicenses(
        List<LocatedDependency> packages) async =>
    Map.fromEntries(await Future.wait(
      packages.map<Future<MapEntry<String, String>>>(
        (LocatedDependency package) async {
          // Iterate over all files in the root of the package to find license file
          final dir = Directory(package.path);
          if (!dir.existsSync()) {
            throw StateError(
              "Assumed location for package '${package.name}' does not exist: '${package.path}'",
            );
          }

          List<File> candidates = await _getCandidates(dir);
          if (candidates.isEmpty) {
            throw StateError(
              "Could not find license file for '${package.name}' in '${package.path}'",
            );
          } else if (candidates.length > 1) {
            throw StateError(
              "Found ${candidates.length} license files for '${package.name}' in '${package.path}'",
            );
          }

          return MapEntry(package.name, await candidates[0].readAsString());
        },
      ),
    ));

/// Get all potential license files in given directory
///
/// This is implemented a bit more complex to allow parralel processing
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
