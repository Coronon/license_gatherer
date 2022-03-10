# license_gatherer

Collect all licenses of your dependencies into a single formatted file.

license_gatherer reads your `pubspec.yaml` to gather licenses for all your dependencies (Hosted, Git, Path and SDK supported).

## Example

You can find some example-output generated by license_gatherer in its own `NOTICES` file [here](https://github.com/Coronon/license_gatherer/blob/master/NOTICES).

## Prerequisites

Please note that in order for license_gatherer to work, you must have already run `pub get` in your project, which must have
created a `.dart_tool/package_config.json` file.

## Installation

To install license_gatherer run the following command:

```bash
dart pub global activate license_gatherer
```

## Usage

### Run license_gatherer

```bash
# If your path is set up correctly
license_gatherer -h

# Otherwise
dart pub global run license_gatherer
```

### Arguments

```console
$ license_gatherer -h
license_gatherer v1.1.0 - Copyright Rubin Raithel
-i, --pubspec                 Path to pubspec.yaml to extract licenses from (mandatory)
-o, --notices                 Path to file that notices are saved to
                              (defaults to "NOTICES")

=== Miscellaneous
-f, --[no-]flutter-version    Whether to dynamically determine flutter version if in dependencies
                              (defaults to on)
-p, --pedantic                Fail at the slightest sign of trouble (warning)
-c, --color                   Colorize output (CLI)
-h, --help                    Display this usage description
-v, --version                 Display current version
```

## License

BSD 3-Clause “New” or “Revised” License
