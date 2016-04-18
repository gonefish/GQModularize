//
//  GQModuleCenter.h
//  Pods
//
//  Created by 钱国强 on 16/3/24.
//
//

#import <Foundation/Foundation.h>
#import "GQModuleResponse.h"
#import "GQModuleRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface GQModuleCenter : NSObject

+ (void)registerModuleWithClassName:(NSString *)name;

+ (void)unregisterModuleWithClassName:(NSString *)name;

+ (GQModuleResponse *)invokeWithRequest:(GQModuleRequest *)request;

@end

@interface GQModuleCenter (GQModuleMiddlewareSupport)

+ (void)registerMiddlewareWithClassName:(NSString *)name;

+ (void)unregisterMiddlewareWithClassName:(NSString *)name;

@end

@interface GQModuleCenter (UIApplicationDelegateHelper)

+ (void)applicationDidBecomeActive:(UIApplication *)application;

@end

@interface GQModuleCenter (GQModuleCenterEventSupport)

+ (void)postEventName:(NSString *)eventName updateValue:(id)updateValue;

+ (id <NSObject>)addObserverForEventName:(NSString *)eventName usingBlock:(void (^)(id updateValue))block;

+ (void)removeObserver:(id)observer;

@end


NS_ASSUME_NONNULL_END
