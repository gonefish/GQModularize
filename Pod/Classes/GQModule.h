//
//  GQModule.h
//  Pods
//
//  Created by 钱国强 on 16/3/24.
//
//

#import <UIKit/UIKit.h>

#import "GQModuleResponse.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString * const GQModulePortalViewControllerIdentifier;

@interface GQModule : NSObject <UIApplicationDelegate>

@property (nonatomic, strong, readonly) NSMutableDictionary *moduleDictionary;

+ (instancetype)currentModule;

+ (NSArray *)supportActionIdentifiers;

- (id)performActionWithIdentifier:(NSString *)identifier options:(nullable NSDictionary *)options;

@end

@interface GQModule (GQModuleCenterHelper)

+ (GQModuleResponse *)invokeWithIdentifier:(NSString *)identifier;

+ (GQModuleResponse *)invokeWithIdentifier:(NSString *)identifier options:(nullable NSDictionary *)options;

@end

@interface GQModule (GQModuleAction)

- (UIViewController *)portalViewControllerWithOptions:(nullable NSDictionary *)options;

@end

NS_ASSUME_NONNULL_END
