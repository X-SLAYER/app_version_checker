import 'package:flutter/foundation.dart';
import 'package:flutter_app_version_checker/api/api.dart';
import 'package:flutter_app_version_checker/app_checker_result.dart';

import 'package:http/http.dart' as http;

class ApkPureApi extends Api {

  @override
  Future<AppCheckerResult> checkVersion({
    required String currentVersion,
    required String packageName,
    String? countryCode,
  }) async {
    String? errorMsg;
    String? url;
    Uri uri = Uri.parse('https://apkpure.com/${countryCode != null ? '$countryCode/' : ''}$packageName/$packageName');//("apkpure.com", "$countryCode/$packageName/$packageName");
    try {
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        errorMsg =
        "Can't find an app in the ApkPure Store with the id: $packageName";
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
      appURL: url,
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

    final newVersion = RegExp(
        r'<div class="details-sdk"><span itemprop="version">(.*?)<\/span>for Android<\/div>')
        .firstMatch(html)!
        .group(1)!
        .trim();

    String? releaseNotes;
    try {
      releaseNotes = RegExp(
          r'<div class="describe-whatnew" id="whatsnew">\s*<h3>(.*?)<\/h3>\s*<div>(.*?)<\/div>\s*<div>(.*?)<\/div>')
          .firstMatch(html)!
          .group(3)!
          .trim()
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