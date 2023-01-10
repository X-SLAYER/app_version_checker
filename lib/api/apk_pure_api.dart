import 'package:flutter_app_version_checker/api/api.dart';
import 'package:flutter_app_version_checker/app_checker_result.dart';

import 'package:http/http.dart' as http;

class ApkPureApi extends Api {

  @override
  Future<AppCheckerResult> checkVersion({
    required String currentVersion,
    required String packageName,
  }) async {
    String? errorMsg;
    String? newVersion;
    String? url;
    Uri uri = Uri.https("apkpure.com", "$packageName/$packageName");
    try {
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        errorMsg =
        "Can't find an app in the ApkPure Store with the id: $packageName";
      } else {
        newVersion = RegExp(
            r'<div class="details-sdk"><span itemprop="version">(.*?)<\/span>for Android<\/div>')
            .firstMatch(response.body)!
            .group(1)!
            .trim();
        url = uri.toString();
      }
    } catch (e) {
      errorMsg = "$e";
    }
    return AppCheckerResult(
      currentVersion,
      newVersion,
      url,
      errorMsg,
    );
  }
}