import 'package:flutter/cupertino.dart';
import 'package:flutter_app_version_checker/api/api.dart';
import 'package:flutter_app_version_checker/app_checker_result.dart';

import 'package:http/http.dart' as http;

class PlayStoreApi extends Api {

  @override
  Future<AppCheckerResult> checkVersion({
    required String currentVersion,
    required String packageName,
    String? countryCode,
  }) async {
    String? errorMsg;
    final uri = Uri.https(
        "play.google.com", "/store/apps/details", {
          "id": packageName,
      if (countryCode != null) "hl": countryCode
    });
    try {
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        errorMsg =
        "Can't find an app in the Google Play Store with the id: $packageName";
      } else {
        return extractDataFromHtml(
          html: response.body,
          currentVersion: currentVersion,
          uri: uri,
        );
      }
    } catch (e) {
      errorMsg = "$e";
    }
    return AppCheckerResult(
      currentVersion: currentVersion,
      appURL: uri.toString(),
      errorMessage: errorMsg,
    );
  }

  @visibleForTesting
  AppCheckerResult extractDataFromHtml({
    required String html,
    required String currentVersion,
    required Uri uri,
  }) {
    String? errorMsg;

    final newVersion = RegExp(r',\[\[\["([0-9,\.]*)"]],')
        .firstMatch(html)!
        .group(1);

    String? releaseNotes;
    try {
      releaseNotes = RegExp(r'<div itemprop="description">(.*?)<\/div>')
          .firstMatch(html)!
          .group(1)!
          .trim()
          .replaceAll('&quot;', '"')
          .replaceAll('<br>', '\n');
    } catch (e) {
      errorMsg = "$e";
    }

    return AppCheckerResult(
      currentVersion: currentVersion,
      newVersion: newVersion,
      releaseNotes: releaseNotes,
      appURL: uri.toString(),
      errorMessage: errorMsg,
    );
  }

}