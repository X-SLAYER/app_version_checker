#import "AppVersionCheckerPlugin.h"
#if __has_include(<app_version_checker/app_version_checker-Swift.h>)
#import <app_version_checker/app_version_checker-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "app_version_checker-Swift.h"
#endif

@implementation AppVersionCheckerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAppVersionCheckerPlugin registerWithRegistrar:registrar];
}
@end
