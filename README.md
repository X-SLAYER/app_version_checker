# App Version Checker

Check if your application is up-to-date

## A flutter plugin to check if your app is up-to-date

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

