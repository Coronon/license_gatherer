import '../license_types.dart';

/// Represents a raw license
class License {
  /// Concrete license text
  final String text;

  /// Determined type of license
  /// 
  /// **Currently unsupported!**
  LicenseType? type;

  License(this.text);

  @override
  String toString() {
    if (type != null) return '($type)\n$text';

    return text;
  }
}
