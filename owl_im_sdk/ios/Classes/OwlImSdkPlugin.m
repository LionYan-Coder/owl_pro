#import "OwlImSdkPlugin.h"
#if __has_include(<owl_im_sdk/owl_im_sdk-Swift.h>)
#import <owl_im_sdk/owl_im_sdk-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "owl_im_sdk-Swift.h"
#endif

@implementation OwlImSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftOwlImSdkPlugin registerWithRegistrar:registrar];
}
@end
