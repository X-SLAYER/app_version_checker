import 'dart:io';

import 'package:flutter_app_version_checker/api/apk_pure_api.dart';
import 'package:flutter_app_version_checker/api/apple_store_api.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'api/play_store_api.dart';
import 'flutter_app_version_checker.dart';

class AppVersionChecker {
  /// The current version of the app.
  /// if [currentVersion] is null the [currentVersion] will take the Flutter package version
  final String? currentVersion;

  /// The id of the app (com.exemple.your_app).
  /// if [appId] is null the [appId] will take the Flutter package identifier
  final String? appId;

  /// Select The marketplace of your app
  /// default will be `AndroidStore.GooglePlayStore`
  final AndroidStore androidStore;

  AppVersionChecker({
    this.currentVersion,
    this.appId,
    this.androidStore = AndroidStore.googlePlayStore,
  });

  Future<AppCheckerResult> checkUpdate() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final _currentVersion = currentVersion ?? packageInfo.version;
    final _packageName = appId ?? packageInfo.packageName;
    if (Platform.isAndroid) {
      switch (androidStore) {
        case AndroidStore.apkPure:
          return await ApkPureApi().checkVersion(
              currentVersion: _currentVersion,
              packageName: _packageName,
          );
        default:
          return await PlayStoreApi().checkVersion(
              currentVersion: _currentVersion,
              packageName: _packageName,
          );
      }
    } else if (Platform.isIOS) {
      return await AppleStoreApi().checkVersion(
          currentVersion: _currentVersion,
          packageName: _packageName,
      );
    } else {
      return AppCheckerResult(
          currentVersion: _currentVersion,
          newVersion: null,
          appURL: "",
          errorMessage: 'The target platform "${Platform.operatingSystem}" is not yet supported by this package.',
      );
    }
  }
}