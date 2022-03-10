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
-j, --formatfile=<path>       File that contains JSON representation of format to use (see README)
                              (defaults to "")

=== Miscellaneous
-f, --[no-]flutter-version    Whether to dynamically determine flutter version if in dependencies
                              (defaults to on)
-p, --pedantic                Fail at the slightest sign of trouble (warning)
-c, --color                   Colorize output (CLI)
-h, --help                    Display this usage description
-v, --version                 Display current version
```

### Custom format

You can specify a custom format for your notices in JSON syntax.
Create a file with your format and provide license_gatherer with the path using `-j` or `--formatfile`.

Below is an example using the default format with documentation on each configuration option.

```json5
// notices_format.json
{
    // Header text at top of file
    "header": "",
    
    // Format for each individual license
    //
    // Variables: {{NAME}}, {{VERSION}}, {{LICENSE}}
    "license": "{{NAME}} ({{VERSION}}):\n\n{{LICENSE}}\n\n",

    // Separator inserted between every license
    "licenseSeparator": "-----------------------------------------------------------------------------\n\n",

    // Footer text at bottom of file
    "footer": "",

    // What to use as version if not available
    "nullVersion": "?",

    // What to use as license text if not available
    "nullText": "?",

    // Trim whitespace and newlines from front and back
    //
    // For better control, trim is applied before the header
    // and footer are added (-> only applies to main body).
    "trim": true,

    // Add a trailing newline (`\n`) to the end of the file
    //
    // Combine this option with [trim] to achieve a single
    // empty line at the end.
    "trailingNewline": true
}
```

## License

BSD 3-Clause “New” or “Revised” License
