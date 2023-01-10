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
    String? newVersion;
    String? url;
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
        newVersion = RegExp(r',\[\[\["([0-9,\.]*)"]],')
            .firstMatch(response.body)!
            .group(1);
        url = uri.toString();
      }
    } catch (e) {
      errorMsg = "$e";
    }
    return AppCheckerResult(
      currentVersion: currentVersion,
      newVersion: newVersion,
      appURL: url,
      errorMessage: errorMsg,
    );
  }

}