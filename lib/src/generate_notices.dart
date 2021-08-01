import 'storage/gathered_license.dart';

/// Compile all licenses together into one notices string.
///
/// You can optionally override the [NoticesFormat] for the generated
/// notices.
String generateNotices(
  Map<String, GatheredLicense> licenses, [
  NoticesFormat format = defaultNoticesFormat,
]) {
  String licensesTexts = '';

  for (GatheredLicense license in licenses.values) {
    if (licensesTexts != '') licensesTexts += format.licenseSeparator;

    licensesTexts += format.license
        .replaceAll('{{NAME}}', license.name)
        .replaceAll('{{VERSION}}', license.version ?? format.nullVersion)
        .replaceAll('{{LICENSE}}', license.license.text);
  }

  if (format.trim) {
    return (format.header + licensesTexts + format.footer).trim();
  }

  return format.header + licensesTexts + format.footer;
}

/// Format for notices generation by [generateNotices].
///
/// Variables for [license]: {{NAME}}, {{VERSION}},
/// {{LICENSE}}
class NoticesFormat {
  /// Header text at top of file
  final String header;

  /// Format for each individual license
  final String license;

  /// Separator inserted between every license
  final String licenseSeparator;

  /// Footer text at bottom of file
  final String footer;

  /// What to use as version if not available
  final String nullVersion;

  /// Trim whitespace and newlines from front end back
  final bool trim;

  const NoticesFormat(
    this.header,
    this.license,
    this.licenseSeparator,
    this.footer,
    this.nullVersion,
    this.trim,
  );
}

const defaultNoticesFormat = NoticesFormat(
  '',
  '{{NAME}} ({{VERSION}}):\n\n{{LICENSE}}\n\n',
  '-----------------------------------------------------------------------------\n\n',
  '',
  '?',
  true,
);
