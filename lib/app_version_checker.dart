import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

class AppVersionChecker {
  /// The current version of the app.
  /// if [currentVersion] is null the [currentVersion] will take the Flutter package version
  final String? currentVersion;

  /// The id of the app (com.exemple.your_app).
  /// if [appId] is null the [appId] will take the Flutter package identifier
  final String? appId;

  AppVersionChecker._({this.currentVersion, this.appId});

  void check() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final _currentVersion = currentVersion ?? packageInfo.version;
    final _packageName = appId ?? packageInfo.packageName;
    if (Platform.isAndroid) {
      _checkPlayStore(_currentVersion, _packageName);
    } else if (Platform.isIOS) {
      _checkAppleStore(_currentVersion, _packageName);
    } else {
      log('The target platform "${Platform.operatingSystem}" is not yet supported by this package.');
    }
  }

  Future<AppCheckerResult> _checkPlayStore(
      String currentVersion, String packageName) async {
    String? errorMsg;
    String? newVersion;
    String? url;
    final uri = Uri.https(
        "play.google.com", "/store/apps/details", {"id": packageName});
    try {
      final response = await http.get(uri);
      if (response.statusCode >= 200 && response.statusCode <= 300) {
        errorMsg =
            "Can't find an app in the Play Store with the id: $packageName";
      } else {
        final jsonObj = jsonDecode(response.body);
        final List results = jsonObj['results'];
        if (results.isEmpty) {
          errorMsg =
              "Can't find an app in the Play Store with the id: $packageName";
        } else {
          newVersion = jsonObj['results'][0]['version'];
          url = jsonObj['results'][0]['trackViewUrl'];
        }
      }
    } catch (e) {
      log("$e");
      errorMsg = "$e";
    }
    return AppCheckerResult(
      currentVersion,
      newVersion,
      url ?? "",
      errorMsg,
    );
  }

  Future<AppCheckerResult> _checkAppleStore(
      String currentVersion, String packageName) async {
    String? errorMsg;
    String? newVersion;
    var uri =
        Uri.https("itunes.apple.com", "/lookup", {"bundleId": packageName});
    try {
      final response = await http.get(uri);
      if (response.statusCode >= 200 && response.statusCode <= 300) {
        errorMsg =
            "Can't find an app in the Apple Store with the id: $packageName";
      } else {
        newVersion = RegExp(
                r'Current Version<\/div><span class="htlgb"><div class="IQ1z0d"><span class="htlgb">(.*?)<\/span>')
            .firstMatch(response.body)!
            .group(1);
      }
    } catch (e) {
      log("$e");
      errorMsg = "$e";
    }
    return AppCheckerResult(
      currentVersion,
      newVersion,
      uri.toString(),
      errorMsg,
    );
  }
}

class AppCheckerResult {
  final String currentVersion;
  final String? newVersion;
  final String appURL;
  final String? errorMessage;

  AppCheckerResult(
    this.currentVersion,
    this.newVersion,
    this.appURL,
    this.errorMessage,
  );

  bool get canUpdate => currentVersion != (newVersion ?? currentVersion);

  @override
  String toString() {
    return "Current Version: $currentVersion\nNew Version: $newVersion\nApp URL: $appURL\ncan update: $canUpdate\nerror: $errorMessage";
  }
}
