# App Version Checker

this package is used to check if your app has a new version on playstore or apple app store.
or you can even check what is the latest version of another app on playstore or apple app store.

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

#### Or
If your app is not published in the US App Store, you can provide a list of countries where it's available:
```dart
  final _checker = AppVersionChecker(
      appStoreCountryCodes: ["DE", "US", "IT"]);
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
