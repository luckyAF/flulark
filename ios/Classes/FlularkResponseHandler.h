
#import <Foundation/Foundation.h>

#import <Flutter/Flutter.h>



// 处理飞书的回调


@protocol LarkSSODelegate <NSObject>

@optional
- (void)lkSSODidReceiveWithResponse:(LKSSOResponse *)response;
@end


@interface FlularkResponseHandler : NSObject <LarkSSODelegate>

+ (instancetype)defaultManager;

- (void)setMethodChannel:(FlutterMethodChannel *)flutterMethodChannel;

@end