//
//  GQModuleObject.h
//  Pods
//
//  Created by 钱国强 on 16/3/28.
//
//

#import <UIKit/UIKit.h>

@class GQModule;

@interface GQModuleResponse : NSObject

@property (nonatomic, strong, readonly, nullable) id originalObject;

@property (nonatomic, strong, readonly, nullable) __kindof GQModule *module;

- (nonnull instancetype)initWithObject:(nullable id)aObject module:(nonnull GQModule *)aModule;

- (nullable id)convertObjectToProtocol:(nonnull Protocol *)aProtocol;

- (nullable id)convertObjectToExactClass:(nonnull Class)aClass;

- (nullable id)convertObjectToClass:(nonnull Class)aClass;

@end

@interface GQModuleResponse (Foundation)

- (nullable NSArray *)gq_array;
- (nullable NSDictionary *)gq_dictionary;
- (nullable NSSet *)gq_set;
- (nullable NSData *)gq_data;
- (nullable NSString *)gq_string;
- (nullable NSDate *)gq_date;
- (nullable NSNumber *)gq_number;


@end
