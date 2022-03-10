import '../license_types.dart';

/// Represents a raw license
class License {
  /// Concrete license text
  final String? text;

  /// Determined type of license
  ///
  /// **Currently unsupported!**
  LicenseType? type;

  License(this.text);

  /// Create an empty license to still show
  /// the name of the package
  License.notFound() : text = null;

  @override
  String toString() {
    if (type != null) return '($type)\n$text';

    return text.toString();
  }
}
