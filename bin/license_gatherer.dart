import 'package:license_gatherer/license_gatherer.dart';

void main(List<String> args) async {
  //* Extract arguments
  final String pubSpecFilePath = args[0];

  // (json_annotation, path, crypto, cryptography, synchronized)
  print((await gatherLicenses(locateDependencies(pubSpecFilePath)))['synchronized']);
}
