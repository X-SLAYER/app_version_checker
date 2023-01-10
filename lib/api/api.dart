import 'package:flutter_app_version_checker/app_checker_result.dart';

abstract class Api {

  Future<AppCheckerResult> checkVersion({
    required String currentVersion,
    required String packageName,
    String? countryCode,
  });

}