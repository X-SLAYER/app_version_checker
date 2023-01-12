# App Version Checker

This package is used to check if your app has a new version on Google Play Store or Apple App Store.
Or you can even check what is the latest version of another app on Play Store or Apple App Store.

### Installing

Add App Version Checker to your pubspec:

```yaml
dependencies:
  flutter_app_version_checker: any # or the latest version on Pub
```

### Usage

```dart
  final _checker = AppVersionChecker();

  @override
  void initState() {
    super.initState();
    checkVersion();
  }

  void checkVersion() async {
    _checker.checkUpdate().then((value) {
      print(value.canUpdate); //return true if update is available
      print(value.currentVersion); //return current app version
      print(value.newVersion); //return the new app version
      print(value.releaseNotes); //return the release notes (if given)
      print(value.appURL); //return the app url
      print(value.errorMessage); //return error message if found else it will return null
    });
  }
```
#### Or

```dart
  final _checker = AppVersionChecker(
      appId: "specify the app id (optional)",
      currentVersion: "specify the current version (optional)");
  ...
```

#### Use on ApkPure Store

```dart
   final _checker = AppVersionChecker(
    appId: "com.vanced.android.youtube",
    androidStore: AndroidStore.apkPure,
  );
  ...
```

