
#import <Flutter/Flutter.h>
#import "FlularkResponseHandler.h"

@import LarkSSO;



@implementation FlularkResponseHandler


#pragma mark - LifeCycle

+ (instancetype)defaultManager {
    static dispatch_once_t onceToken;
    static FlularkResponseHandler *instance;
    dispatch_once(&onceToken, ^{
        instance = [[FlularkResponseHandler alloc] init];
    });
    return instance;
}

FlutterMethodChannel *fluwxMethodChannel = nil;

- (void)setMethodChannel:(FlutterMethodChannel *)flutterMethodChannel {
    fluwxMethodChannel = flutterMethodChannel;
}


bool useChallengeCode = YES;


#pragma mark - LarkSSODelegate

- (void)lkSSODidReceiveWithResponse:(LKSSOResponse *)response {
    if (useChallengeCode) {
        [response safeHandleResultWithCodeVerifierWithSuccess:^(NSString * _Nonnull code, NSString * _Nonnull codeVerifer) {
    
            NSLog(@"code: %@ codeVerifier: %@", code, codeVerifer);
            
        } failure:^(LKSSOError * _Nonnull error) {
            NSLog(@"error: %@", error);
        }];
    } else {
        [response safeHandleResultWithSuccess:^(NSString * _Nonnull result) {
            NSLog(@"LarkSSO result: %@", result);
        } failure:^(LKSSOError * _Nonnull error) {
            NSLog(@"LarkSSO error: %@", error);
        }];
    }
}





@end