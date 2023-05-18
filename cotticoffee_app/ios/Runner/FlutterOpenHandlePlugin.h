//
//  FlutterOpenHandlePlugin.h
//  Runner
//
//  Created by 容芳志 on 1/2/22.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

@interface FlutterOpenHandlePlugin : NSObject
+ (instancetype)sharedInstance;
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar;
@property (nonatomic, strong) FlutterEventSink eventSink;
@end

