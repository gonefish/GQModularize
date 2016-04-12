//
//  GQModule.m
//  Pods
//
//  Created by 钱国强 on 16/3/24.
//
//

#import "GQModule.h"
#import "GQModuleCenter.h"

NSString * const GQModulePortalViewControllerIdentifier = @"GQModulePortalViewControllerIdentifier";


static NSMutableDictionary *_sharedModules = nil;

@interface GQModule ()

@property (nonatomic, strong) NSMutableDictionary *moduleDictionary;

@end

@implementation GQModule

+ (instancetype)currentModule
{
    NSString *className = NSStringFromClass(self);
    
    return [_sharedModules objectForKey:className];
}

+ (void)initialize
{
    if ([self class] != [GQModule class]) {
        if (!_sharedModules) {
            _sharedModules = [[NSMutableDictionary alloc] init];
        }
        
        NSString *className = NSStringFromClass(self);
        
        if (![_sharedModules objectForKey:className]) {
            [_sharedModules setObject:[[self alloc] init]
                               forKey:className];
        }
    }
}

+ (NSArray *)supportActionIdentifiers
{
    return @[];
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _moduleDictionary = [NSMutableDictionary dictionary];
    }
    
    return self;
}


- (id)performActionWithIdentifier:(NSString *)identifier options:(NSDictionary *)options
{
    return nil;
}

@end

@implementation GQModule (GQModuleCenterHelper)


+ (GQModuleResponse *)invokeWithIdentifier:(NSString *)identifier
{
    return [self invokeWithIdentifier:identifier options:nil];
}

+ (GQModuleResponse *)invokeWithIdentifier:(NSString *)identifier options:(NSDictionary *)options
{
    GQModuleResponse *response = nil;
    
    GQModule *currentModule = [self currentModule];
    
    if ([[self supportActionIdentifiers] containsObject:identifier]) {
        // 内部处理
        
        id rel = [currentModule performActionWithIdentifier:identifier
                                                    options:options];
        
        if (rel) {
            response = [[GQModuleResponse alloc] initWithObject:rel module:currentModule];
        }
    } else {
        // 外部处理
        
        GQModuleRequest *request = [[GQModuleRequest alloc] initWithIdentifier:identifier
                                                                       options:options
                                                                        module:currentModule];
        
        response = [GQModuleCenter invokeWithRequest:request];
    }
    
    return response;
}

@end

@implementation GQModule (GQModuleAction)

- (UIViewController *)portalViewControllerWithOptions:(NSDictionary *)options
{
    UIViewController *vc = [self performActionWithIdentifier:GQModulePortalViewControllerIdentifier
                                                     options:options];
    
    NSAssert([vc isKindOfClass:[UIViewController class]], @"Must return UIViewController");
    
    return vc;
}

@end
