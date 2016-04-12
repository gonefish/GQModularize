//
//  GQModuleObject.m
//  Pods
//
//  Created by 钱国强 on 16/3/28.
//
//

#import "GQModuleResponse.h"
#import "GQModule.h"

@interface GQModuleResponse ()

@property (nonatomic, strong) id originalObject;

@property (nonatomic, strong) GQModule *responseModule;

@end


@implementation GQModuleResponse

- (instancetype)initWithObject:(id)aObject module:(GQModule *)aModule
{
    self = [self init];
    
    if (self) {
        _originalObject = aObject;
        _responseModule = aModule;
    }
    
    return self;
}

- (id)convertObjectToProtocol:(Protocol *)aProtocol
{
    if ([self.originalObject conformsToProtocol:aProtocol]) {
       return self.originalObject;
    } else {
       return nil;
    }
}

- (id)convertObjectToExactClass:(Class)aClass
{
    if ([self.originalObject isMemberOfClass:aClass]) {
        return self.originalObject;
    } else {
        return nil;
    }
}

- (id)convertObjectToClass:(Class)aClass
{
    if ([self.originalObject isKindOfClass:aClass]) {
        return self.originalObject;
    } else {
        return nil;
    }
}

@end

@implementation GQModuleResponse (Foundation)

- (NSArray *)gq_array
{
    return [self convertObjectToClass:[NSArray class]];
}

- (NSDictionary *)gq_dictionary
{
    return [self convertObjectToClass:[NSDictionary class]];
}

- (NSSet *)gq_set
{
    return [self convertObjectToClass:[NSSet class]];
}

- (NSData *)gq_data
{
    return [self convertObjectToClass:[NSData class]];
}

- (NSString *)gq_string
{
   return [self convertObjectToClass:[NSString class]];
}

- (NSDate *)gq_date
{
   return [self convertObjectToClass:[NSDate class]];
}

- (NSNumber *)gq_number
{
   return [self convertObjectToClass:[NSNumber class]];
}

@end
