import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:args/args.dart';

import 'package:license_gatherer/license_gatherer.dart';

const String versionStr = 'license_gatherer v1.1.0 - Copyright Rubin Raithel';

void main(List<String> args) async {
  //* Parse arguments
  final parser = ArgParser()
    ..addSeparator(versionStr)
    ..addOption(
      'pubspec',
      abbr: 'i',
      help: 'Path to pubspec.yaml to extract licenses from (mandatory)',
      valueHelp: 'path',
    )
    ..addOption(
      'notices',
      abbr: 'o',
      defaultsTo: 'NOTICES',
      help: 'Path to file that notices are saved to',
      valueHelp: 'path',
    )
    ..addSeparator('=== Format')
    ..addOption(
      'formatfile',
      abbr: 'j',
      defaultsTo: '',
      help:
          'File that contains JSON representation of format to use (see README)',
      valueHelp: 'path',
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
      'pedantic',
      abbr: 'p',
      defaultsTo: false,
      help: 'Fail at the slightest sign of trouble (warning)',
      negatable: false,
    )
    ..addFlag(
      'color',
      abbr: 'c',
      defaultsTo: false,
      help: 'Colorize output (CLI)',
      negatable: false,
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
      print(e.message);
    } else {
      print(parser.usage);
    }
    exit(1);
  }

  //* Help and version
  if (parsedArgs['help']) {
    print(parser.usage);
    exit(0);
  }
  if (parsedArgs['version']) {
    print(versionStr);
    exit(0);
  }

  //* Mandatory options
  if (!parsedArgs.wasParsed('pubspec')) {
    print('Option pubspec is mandatory\n');
    print(parser.usage);
    exit(1);
  }

  final bool pedantic = parsedArgs['pedantic'];
  final bool colorize = parsedArgs['color'];

  //* Setup logging
  final logger = Logger('license_gatherer:bin');
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((LogRecord record) {
    final message = '${record.level.name}: ${record.message}';
    if (colorize) {
      if (record.level.value >= Level.SEVERE.value) {
        printError(message);
      } else if (record.level == Level.WARNING) {
        printWarning(message);
      } else {
        print(message);
      }
    } else {
      print(message);
    }

    // Fail on critical exception or any warning if pedantic
    if (record.level.value >= Level.SHOUT.value ||
        (record.level.value >= Level.WARNING.value && pedantic)) {
      const errorMsg = 'Generating notices failed!';
      colorize ? printError(errorMsg) : print(errorMsg);
      exit(1);
    }
  });

  //* Parse optional format
  final String formatFile = parsedArgs['formatfile'];
  NoticesFormat? customFormat;
  if (formatFile != '') {
    logger.info("Using custom format from '$formatFile'");
    try {
      customFormat = NoticesFormat.fromJson(
        jsonDecode(
          await File(parsedArgs['formatfile']).readAsString(),
        ),
      );
    } catch (e) {
      logger.shout('Invalid format file');
    }
  } else {}

  //* Actual notices generation
  logger.info('Generating notices...');

  try {
    await File(parsedArgs['notices']).writeAsString(
      generateNotices(
        await gatherLicenses(
          locateDependencies(
            parsedArgs['pubspec'],
            parsedArgs['flutter-version'],
          ),
        ),
        customFormat ?? defaultNoticesFormat,
      ),
    );
  } catch (e) {
    logger.shout(e.toString());
  }

  logger.info('Generated notices!');
}
