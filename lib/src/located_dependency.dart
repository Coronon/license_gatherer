/// Represents a dependency with path (to later retrieve license)
class LocatedDependency {
  final String name;
  final String? version;
  final String path;

  const LocatedDependency(this.name, this.version, this.path);

  @override
  String toString() => '$name ($version): $path';
}
