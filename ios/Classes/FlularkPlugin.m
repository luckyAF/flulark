#import "FlularkPlugin.h"
#if __has_include(<flulark/flulark-Swift.h>)
#import <flulark/flulark-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flulark-Swift.h"
#endif

@implementation FlularkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlularkPlugin registerWithRegistrar:registrar];
}
@end
