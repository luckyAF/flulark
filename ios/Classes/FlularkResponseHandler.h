
#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import <LarkSSO/LarkSSO-Swift.h>



@interface FlularkResponseHandler :NSObject<LarkSSODelegate>

+ (instancetype)defaultManager;

- (void)setMethodChannel:(FlutterMethodChannel *)flutterMethodChannel;

@end