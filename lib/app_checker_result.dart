import 'dart:math' as math;

class AppCheckerResult {
  /// return current app version
  final String currentVersion;

  /// return the new app version
  final String? newVersion;

  /// Release notes
  final String? releaseNotes;

  /// return the app url
  final String? appURL;

  /// return error message if found else it will return `null`
  final String? errorMessage;

  AppCheckerResult({
    required this.currentVersion,
    this.newVersion,
    this.releaseNotes,
    this.appURL,
    this.errorMessage,
  });

  /// return `true` if update is available
  bool get canUpdate =>
      _shouldUpdate(currentVersion, (newVersion ?? currentVersion));

  bool _shouldUpdate(String versionA, String versionB) {
    final versionNumbersA =
    versionA.split(".").map((e) => int.tryParse(e) ?? 0).toList();
    final versionNumbersB =
    versionB.split(".").map((e) => int.tryParse(e) ?? 0).toList();

    final int versionASize = versionNumbersA.length;
    final int versionBSize = versionNumbersB.length;
    int maxSize = math.max(versionASize, versionBSize);

    for (int i = 0; i < maxSize; i++) {
      if ((i < versionASize ? versionNumbersA[i] : 0) >
          (i < versionBSize ? versionNumbersB[i] : 0)) {
        return false;
      } else if ((i < versionASize ? versionNumbersA[i] : 0) <
          (i < versionBSize ? versionNumbersB[i] : 0)) {
        return true;
      }
    }
    return false;
  }

  @override
  String toString() {
    final stringBuffer = StringBuffer()
      ..write('Current Version: $currentVersion\n\n')
      ..write('New Version:\n $newVersion\n\n')
      ..write(releaseNotes == null ? '' : 'Release Notes:\n $releaseNotes\n\n')
      ..write('App URL: $appURL\n\n')
      ..write('can update:\n $canUpdate\n\n')
      ..write(errorMessage == null ? '' : 'error:\n $errorMessage');
    return stringBuffer.toString();
  }
}