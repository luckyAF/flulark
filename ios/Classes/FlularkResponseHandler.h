
#import <Foundation/Foundation.h>

#import <Flutter/Flutter.h>


// 处理飞书的回调


@interface FlularkResponseHandler :NSObject

+ (instancetype)defaultManager;

- (void)setMethodChannel:(FlutterMethodChannel *)flutterMethodChannel;

@end