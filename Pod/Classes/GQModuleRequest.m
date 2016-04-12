//
//  GQModuleRequest.m
//  Pods
//
//  Created by 钱国强 on 16/3/28.
//
//

#import "GQModuleRequest.h"
#import "GQModule.h"

@interface GQModuleRequest ()

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, copy) NSDictionary *options;

@property (nonatomic, strong) GQModule *requestModule;

@end

@implementation GQModuleRequest

- (instancetype)initWithIdentifier:(NSString *)identifier options:(NSDictionary *)options module:(GQModule *)module
{
    self = [super init];
    
    if (self) {
        _identifier = identifier;
        _options = options;
        _requestModule = module;
        
    }
    
    return self;
}

@end
