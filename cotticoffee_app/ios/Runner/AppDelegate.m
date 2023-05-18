#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
//引入神策分析 SDK
#import <SensorsAnalyticsSDK/SensorsAnalyticsSDK.h>
#import "FlutterOpenHandlePlugin.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GeneratedPluginRegistrant registerWithRegistry:self];
    [FlutterOpenHandlePlugin registerWithRegistrar:[self registrarForPlugin:@"OpenHandlePlugin"]];
    
//    NSString * saURL = [NSString stringWithFormat:@"https://%@",SASERVERURL];
//    NSLog(@"saURL%@",saURL);
//
//
//
//    // Override point for customization after application launch.
//    // 初始化配置
//    SAConfigOptions *options = [[SAConfigOptions alloc] initWithServerURL:saURL launchOptions:launchOptions];
//    options.enableJavaScriptBridge = YES;
//
//    // 开启全埋点，可根据需求进行组合
//    options.autoTrackEventType = SensorsAnalyticsEventTypeAppStart |
//    SensorsAnalyticsEventTypeAppEnd|SensorsAnalyticsEventTypeAppClick;
    
//#ifdef DEBUG
//    // SDK 开启 Log
//    options.enableLog = NO;
//#endif
//    options.enableAutoAddChannelCallbackEvent = YES;
//    
//    // 初始化 SDK
//    [SensorsAnalyticsSDK startWithConfigOptions:options];
    
    // 处理本次 DeepLink 跳转
    /// @param params 创建渠道链接时填写的参数
    /// @param success 请求渠道信息是否成功
    /// @param appAwakePassedTime 本次请求时长
    [[SensorsAnalyticsSDK sharedInstance] setDeeplinkCallback:^(NSString * _Nullable params, BOOL success, NSInteger appAwakePassedTime) {
        [self goToUrlPage:params];
        
    }];
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}
- (void)scene:(UIScene *)scene continueUserActivity:(NSUserActivity *)userActivity {
    // 业务相关逻辑处理
    if (userActivity.webpageURL != nil && userActivity.webpageURL.absoluteString.length>0 ) {
        if([userActivity.webpageURL.absoluteString containsString:@"access.abite.com"]){
            [[SensorsAnalyticsSDK sharedInstance] handleSchemeUrl:userActivity.webpageURL];
        }
    }
    [self goToUrlPage:userActivity.webpageURL.absoluteString];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler {
    // 业务相关逻辑处理
    if ([[SensorsAnalyticsSDK sharedInstance] handleSchemeUrl:userActivity.webpageURL]) {
        return YES;
    }
    [self goToUrlPage:userActivity.webpageURL.absoluteString];
    return [super application:application continueUserActivity:userActivity restorationHandler:restorationHandler];
}

- (BOOL)application:(UIApplication*)application openURL:(NSURL*)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation {
    // 业务相关逻辑处理
    if ([[SensorsAnalyticsSDK sharedInstance] handleSchemeUrl:url]) {
        return YES;
    }
    return [super application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

-(void)goToUrlPage:(NSString *)goToUrl {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       // 需要延迟执行的代码
        if(goToUrl != nil && goToUrl.length >0){
            if([FlutterOpenHandlePlugin sharedInstance].eventSink != nil){
                [FlutterOpenHandlePlugin sharedInstance].eventSink(goToUrl);
            }
        }
    });
}

@end
