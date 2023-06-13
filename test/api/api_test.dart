import 'dart:io';

import 'package:flutter_app_version_checker/api/apk_pure_api.dart';
import 'package:flutter_app_version_checker/api/play_store_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  setUp(() {
    //
  });

  tearDown(() {
    //
  });

  final playStoreHtmlEhwplus = File('test_resources/playstore/ehwplus.html');

  final apkPureeHtmlEhwplus = File('test_resources/apkpure/ehwplus.html');

  group('PlayStore', () {
    test('Extracting version', () async {
      final appCheckerResult = PlayStoreApi().extractDataFromHtml(
          html: await playStoreHtmlEhwplus.readAsString(),
          currentVersion: '1.6.114',
          uri: Uri.parse('https://play.google.com/store/apps/details?id=com.ehwplus&hl=de'),
      );
      expect(appCheckerResult.newVersion, '1.6.119');
    });

    test('Extracting release notes', () async {
      final appCheckerResult = PlayStoreApi().extractDataFromHtml(
        html: await playStoreHtmlEhwplus.readAsString(),
        currentVersion: '1.6.114',
        uri: Uri.parse('https://play.google.com/store/apps/details?id=com.ehwplus&hl=de'),
      );
      expect(appCheckerResult.releaseNotes?.isNotEmpty, true);
    });
  });

  group('ApkPure', () {
    test('Extracting version', () async {
      final appCheckerResult = ApkPureApi().extractDataFromHtml(
        html: await apkPureeHtmlEhwplus.readAsString(),
        currentVersion: '1.6.114',
        uri: Uri.parse('https://apkpure.com/de/ehw-consumption-readings/com.ehwplus'),
      );
      expect(appCheckerResult.newVersion, '1.6.119');
    });

    test('Extracting release notes', () async {
      final appCheckerResult = ApkPureApi().extractDataFromHtml(
        html: await apkPureeHtmlEhwplus.readAsString(),
        currentVersion: '1.6.114',
        uri: Uri.parse('https://apkpure.com/de/ehw-consumption-readings/com.ehwplus'),
      );
      expect(appCheckerResult.releaseNotes?.isNotEmpty, true);
    });
  });

}
