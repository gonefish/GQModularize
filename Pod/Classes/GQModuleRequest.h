//
//  GQModuleRequest.h
//  Pods
//
//  Created by 钱国强 on 16/3/28.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GQModule;

@interface GQModuleRequest : NSObject

@property (nonatomic, copy, readonly) NSString *identifier;

@property (nonatomic, copy, readonly, nullable) NSDictionary *options;

@property (nonatomic, strong, readonly) __kindof GQModule *requestModule;

- (instancetype)initWithIdentifier:(NSString *)identifier options:(nullable NSDictionary *)options module:(GQModule *)module;

@end

NS_ASSUME_NONNULL_END