import 'dart:io';

import 'package:args/args.dart';

import 'package:license_gatherer/license_gatherer.dart';

const String versionStr = 'license_gatherer v1.0.0 - Copyright Rubin Raithel';

void main(List<String> args) async {
  //* Parse arguments
  final parser = ArgParser()
    ..addSeparator(versionStr)
    ..addOption(
      'pubspec',
      abbr: 'i',
      help: 'Path to pubspec.yaml to extract licenses from (mandatory)',
    )
    ..addOption(
      'notices',
      abbr: 'o',
      defaultsTo: 'NOTICES',
      help: 'Path to file that notices are saved to',
    )
    ..addSeparator('=== Miscellaneous')
    ..addFlag(
      'flutter-version',
      abbr: 'f',
      defaultsTo: true,
      help:
          'Whether to dynamically determine flutter version if in dependencies',
    )
    ..addFlag(
      'help',
      abbr: 'h',
      defaultsTo: false,
      help: 'Display this usage description',
      negatable: false,
    )
    ..addFlag(
      'version',
      abbr: 'v',
      defaultsTo: false,
      help: 'Display current version',
      negatable: false,
    );

  late final ArgResults parsedArgs;
  try {
    parsedArgs = parser.parse(args);
  } catch (e) {
    if (e is ArgParserException) {
      printError(e.message);
    } else {
      print(parser.usage);
    }
    exit(1);
  }

  //* Help and version
  if (parsedArgs['help']) {
    printInfo(parser.usage);
    exit(0);
  }
  if (parsedArgs['version']) {
    printInfo(versionStr);
    exit(0);
  }

  //* Mandatory options
  if (!parsedArgs.wasParsed('pubspec')) {
    printError('Option pubspec is mandatory');
    exit(1);
  }

  //* Actual notices generation
  try {
    await File(parsedArgs['notices']).writeAsString(
      generateNotices(
        await gatherLicenses(
          locateDependencies(
            parsedArgs['pubspec'],
            parsedArgs['flutter-version'],
          ),
        ),
      ),
    );
  } catch (e) {
    printError(e);
    exit(1);
  }
}
