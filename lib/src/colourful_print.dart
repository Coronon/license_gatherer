/// Print in blue colour
///
/// Used for normal info prints
void printInfo(Object? obj) {
  print('\x1B[34m' + obj.toString() + '\x1B[0m');
}

/// Print in yellow colour
///
/// Used for warnings that do not block
/// the program from continuing
void printWarning(Object? obj) {
  print('\x1B[33m' + obj.toString() + '\x1B[0m');
}

/// Print in red colour
///
/// Used for errors and exceptions
/// that cause the program to malfunction
void printError(Object? obj) {
  print('\x1B[31m' + obj.toString() + '\x1B[0m');
}
