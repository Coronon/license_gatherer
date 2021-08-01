import 'located_dependency.dart';
import 'license.dart';

/// Represents a dependency with gathered license
class GatheredLicense extends LocatedDependency {
  /// Concrete gathered license for dependency
  final License license;

  const GatheredLicense(
    String name,
    String? version,
    String path,
    this.license,
  ) : super(name, version, path);

  /// Use values from existing [LocatedDependency]
  GatheredLicense.fromLocatedDependency(
    LocatedDependency dependency,
    this.license,
  ) : super(dependency.name, dependency.version, dependency.path);
}
