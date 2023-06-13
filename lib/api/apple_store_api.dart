import 'dart:convert';

import 'package:flutter_app_version_checker/api/api.dart';
import 'package:flutter_app_version_checker/app_checker_result.dart';

import 'package:http/http.dart' as http;

class AppleStoreApi extends Api {

  @override
  Future<AppCheckerResult> checkVersion({
    required String currentVersion,
    required String packageName,
    String? countryCode,
  }) async {
    String? errorMsg;
    String? newVersion;
    String? url;
    String? releaseNotes;
    var uri =
    Uri.https("itunes.apple.com", "/lookup", {
      "bundleId": packageName,
      if (countryCode != null)
        "country": countryCode,
    });
    try {
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        errorMsg =
        "Can't find an app in the Apple Store with the id: $packageName";
      } else {
        final jsonObj = jsonDecode(response.body);
        final List results = jsonObj['results'];
        if (results.isEmpty) {
          errorMsg =
          "Can't find an app in the Apple Store with the id: $packageName";
        } else {
          newVersion = jsonObj['results'][0]['version'];
          url = jsonObj['results'][0]['trackViewUrl'];
          releaseNotes = jsonObj['results'][0]['releaseNotes'];
        }
      }
    } catch (e) {
      errorMsg = "$e";
    }
    return AppCheckerResult(
      currentVersion: currentVersion,
      newVersion: newVersion,
      releaseNotes: releaseNotes,
      appURL: url,
      errorMessage: errorMsg,
    );
  }
}