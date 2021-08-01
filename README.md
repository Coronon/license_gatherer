Collect all licenses of your dependencies into a single formatted file.

license_gatherer reads your `pubspec.yaml` to gather licenses for all your dependencies (Hosted, Git, Path and SDK supported).

## Prerequisites

Please note that in order for license_gatherer to work, you must have already run `pub get` in your project, which must have
created a `.dart_tool/package_config.json` file.


## Usage

```
license_gatherer v1.0.0 - Copyright Rubin Raithel
-i, --pubspec                 Path to pubspec.yaml to extract licenses from (mandatory)
-o, --notices                 Path to file that notices are saved to
                              (defaults to "NOTICES")

=== Miscellaneous
-f, --[no-]flutter-version    Whether to dynamically determine flutter version if in dependencies
                              (defaults to on)
-h, --help                    Display this usage description
-v, --version                 Display current version
```

## License

BSD 3-Clause “New” or “Revised” License
