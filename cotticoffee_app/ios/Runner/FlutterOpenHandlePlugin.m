//
//  FlutterOpenHandlePlugin.m
//  Runner
//
//  Created by 容芳志 on 1/2/22.
//

#import "FlutterOpenHandlePlugin.h"


@interface FlutterOpenHandlePlugin() <FlutterStreamHandler>
 

 
@end
 
@implementation FlutterOpenHandlePlugin
 
+ (instancetype)sharedInstance {
    static FlutterOpenHandlePlugin *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
 
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterOpenHandlePlugin *instance = [FlutterOpenHandlePlugin sharedInstance];    
    FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:@"flutter_openurl_plugin_event" binaryMessenger:[registrar messenger]];
    [eventChannel setStreamHandler:instance];
}
 
#pragma mark - FlutterStreamHandler
 
- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(FlutterEventSink)eventSink {
    self.eventSink = eventSink;
    return nil;
}
 
- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    self.eventSink = nil;
    return nil;
}
 
 
@end
 
