#import "FlularkPlugin.h"
#if __has_include(<flulark/flulark-Swift.h>)
#import <flulark/flulark-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flulark-Swift.h"
#endif
#import "FlularkStringUtil.h"

@import LarkSSO;

@interface FlularkPlugin()

bool useChallengeCode = YES;
/// channel
FlutterMethodChannel *channel = nil;

@implementation FlularkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  #if TARGET_OS_IPHONE
        if (channel == nil) {
#endif
        channel = [FlutterMethodChannel
                methodChannelWithName:@"com.luckyaf/flulark"
                      binaryMessenger:[registrar messenger]];
        FluwxPlugin *instance = [[FluwxPlugin alloc] initWithRegistrar:registrar methodChannel:channel];
        [registrar addMethodCallDelegate:instance channel:channel];
        [[FlularkResponseHandler defaultManager] setMethodChannel:channel];
        
        [registrar addApplicationDelegate:instance];
#if TARGET_OS_IPHONE
        }
}


- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    _isRunning = YES;
    
    if ([@"flu_lark_register" isEqualToString:call.method]) {
        [self registerApp:call result:result];
    } else if ([@"startLog" isEqualToString:call.method]) {
         [self handleAuth:call result:result];

    } 
}


// 注册APP
- (void)registerApp:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSNumber* doOnIOS =call.arguments[@"iOS"];

    if (![doOnIOS boolValue]) {
        result(@NO);
        return;
    }
    NSString *appId = call.arguments[@"flu_lark_app_id"];
    if ([FlularkStringUtil isBlank:appId]) {
        result([FlutterError errorWithCode:@"invalid app id" message:@"are you sure your app id is correct ? " details:appId]);
        return;
    }
    NSString *scheme = call.arguments[@"flu_lark_app_scheme"];

    if ([FluwxStringUtil isBlank:scheme]) {
        result([FlutterError errorWithCode:@"invalid app scheme" message:@"are you sure your app scheme is correct ? " details:universalLink]);
        return;
    }

    // 必须 SDK 初始化
    [LarkSSO registerWithApps:@[
        [[LKSSOApp alloc] initWithServer:LKSSOServerFeishu appId:appId scheme:scheme]
    ]];

    // 可选 设置语言 默认使用当前系统语言
    [LarkSSO setupLang:@"zh"];

    result(@YES);
}

/// 准备登陆
- (void)handleAuth:(FlutterMethodCall *)call result:(FlutterResult)result {
  UIViewController *vc = UIApplication.sharedApplication.keyWindow.rootViewController;
     LKSSORequest *request = LKSSORequest.feishu;
    request.scope = @[@"contact:user.id:readonly"];
    request.useChallengeCode = useChallengeCode; // 挑战码模式
    [LarkSSO sendWithRequest:request viewController:vc delegate:[FlularkResponseHandler defaultManager]];     
     result(@YES);       
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    // 处理回调
    return [LarkSSO handleURL:url];
}


@end

