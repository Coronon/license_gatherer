// This is a hint to the implementor of license compatibility checking
class LicenseType {
  final String name = '';
  final RegExp regExp = RegExp('');
  final List<LicenseType> upgradableTo = [];
}

class TTT implements LicenseType {
  @override
  final String name = "t";

  @override
  final RegExp regExp = RegExp('');

  @override
  final List<LicenseType> upgradableTo = [LicenseType(), TTT()];
}
