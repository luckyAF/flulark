#import "FlularkPlugin.h"
#import "FlularkStringUtil.h"
#import "FlularkResponseHandler.h"

@import LarkSSO;

@interface FlularkPlugin()
@property (strong,nonatomic)NSString *extMsg;
@end



@implementation FlularkPlugin;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {

FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"com.luckyaf/flulark"
            binaryMessenger:[registrar messenger]];
  FlularkPlugin* instance = [[FluauthPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
          [[FlularkResponseHandler defaultManager] setMethodChannel:channel];
          [registrar addApplicationDelegate:instance];

}


- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {

    if ([@"flu_lark_register" isEqualToString:call.method]) {
        [self registerApp:call result:result];
    } else if ([@"flu_lark_login" isEqualToString:call.method]) {
        [self handleAuth:call result:result];
    } else if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
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

    if ([FlularkStringUtil isBlank:scheme]) {
        result([FlutterError errorWithCode:@"invalid app scheme" message:@"are you sure your app scheme is correct ? " details:scheme]);
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
    request.useChallengeCode = YES; // 挑战码模式
    [LarkSSO sendWithRequest:request viewController:vc delegate:[FlularkResponseHandler defaultManager]];     
     result(@YES);       
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    // 处理回调
    return [LarkSSO handleURL:url];
}


@end

