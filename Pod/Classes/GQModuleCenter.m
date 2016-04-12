//
//  GQModuleCenter.m
//  Pods
//
//  Created by 钱国强 on 16/3/24.
//
//

#import "GQModuleCenter.h"
#import "GQModule.h"
#import "GQModuleMiddleware.h"


@interface GQModuleCenter ()

@property (nonatomic, strong) NSMutableArray<NSString *> *moduleClassNames;

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *moduleActionIdentifierMap;

@property (nonatomic, strong) NSMutableArray<id <GQModuleMiddleware>> *middlewares;

@property (nonatomic, strong) NSMutableDictionary *middlewareMap;

@end

@implementation GQModuleCenter

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static GQModuleCenter *_sharedInstance = nil;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _middlewares = [NSMutableArray array];
        _middlewareMap = [NSMutableDictionary dictionary];
        _moduleClassNames = [NSMutableArray array];
        _moduleActionIdentifierMap = [NSMutableDictionary dictionary];
    }
    
    return self;
}

+ (void)registerModuleWithClassName:(NSString *)name
{
    GQModuleCenter *sharedInstance = [self sharedInstance];
    
    Class cls = NSClassFromString(name);
    
    // 不是GQModule的子类
    if (![cls isSubclassOfClass:[GQModule class]]) {
        return;
    }
    
    if ([sharedInstance.moduleClassNames containsObject:name] == NO) {
        [sharedInstance.moduleClassNames addObject:name];
        
        for (NSString *identifier in [cls supportActionIdentifiers]) {
            sharedInstance.moduleActionIdentifierMap[identifier] = name;
        }
    }
}

+ (void)unregisterModuleWithClassName:(NSString *)name
{
    GQModuleCenter *sharedInstance = [self sharedInstance];
    
    NSMutableArray *removeKeys = [NSMutableArray array];
    
    [sharedInstance.moduleClassNames removeObject:name];
    
    for (NSString *key in sharedInstance.moduleActionIdentifierMap) {
        
        if ([sharedInstance.moduleActionIdentifierMap[key] isEqualToString:name]) {
            [removeKeys addObject:key];
        }
    }
    
    [sharedInstance.moduleActionIdentifierMap removeObjectsForKeys:removeKeys];
}

+ (GQModuleResponse *)invokeWithRequest:(GQModuleRequest *)request
{
    GQModuleCenter *sharedInstance = [self sharedInstance];
    
    // 中间件
    __block GQModuleRequest *processedRequest = request;
    
    [sharedInstance.middlewares enumerateObjectsUsingBlock:^(id<GQModuleMiddleware>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj respondsToSelector:@selector(shouldProcessRequest:)]
            && [obj respondsToSelector:@selector(processRequest:)]) {
            if ([obj shouldProcessRequest:request]) {
                processedRequest = [obj processRequest:request];
                
                *stop = YES;
            }
        }
    }];
    
    NSString *identifier = processedRequest.identifier;
    NSDictionary *options = processedRequest.options;
    
    NSString *clsName = [sharedInstance.moduleActionIdentifierMap objectForKey:identifier];
    
    __block GQModuleResponse *response = nil;
    
    if (clsName) {
        GQModule *invokeModule = [NSClassFromString(clsName) currentModule];
        
        id rel = [invokeModule performActionWithIdentifier:identifier
                                      options:options];
        
        if (rel) {
            response = [[GQModuleResponse alloc] initWithObject:rel module:invokeModule];
        }
    }
    
    // 中间件
    [sharedInstance.middlewares enumerateObjectsWithOptions:NSEnumerationReverse
                                                 usingBlock:^(id<GQModuleMiddleware>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj respondsToSelector:@selector(processResponse:withRequest:)]) {
            response = [obj processResponse:response
                                withRequest:processedRequest];
        }
        
    }];
    
    // Alway return a GQModuleResponse instance
    if (response == nil) {
        response = [[GQModuleResponse alloc] init];
    }
    
    return response;
}

@end

@implementation GQModuleCenter (GQModuleMiddlewareSupport)

+ (void)registerMiddlewareWithClassName:(NSString *)name
{
    Class cls = NSClassFromString(name);
    
    if (![cls conformsToProtocol:@protocol(GQModuleMiddleware)]) {
        return;
    }
    
    GQModuleCenter *sharedInstance = [self sharedInstance];
    
    id middleware = [sharedInstance.middlewareMap objectForKey:name];
    
    if (middleware == nil) {
        middleware = [[cls alloc] init];
        
        [sharedInstance.middlewares addObject:middleware];
        
        [sharedInstance.middlewareMap setObject:middleware forKey:name];
    }
}

+ (void)unregisterMiddlewareWithClassName:(NSString *)name
{
    GQModuleCenter *sharedInstance = [self sharedInstance];
    
    id middleware = [sharedInstance.middlewareMap objectForKey:name];
    
    if (middleware) {
        [sharedInstance.middlewares removeObject:middleware];
        
        [sharedInstance.middlewareMap removeObjectForKey:name];
    }
}


@end

@implementation GQModuleCenter (UIApplicationDelegateHelper)

+ (void)applicationDidBecomeActive:(UIApplication *)application
{
    for (NSString *className in [[self sharedInstance] moduleClassNames]) {
        Class cls = NSClassFromString(className);
        
        if (cls && [cls isSubclassOfClass:[GQModule class]]) {
            
            if ([[cls currentModule] respondsToSelector:@selector(applicationDidBecomeActive:)]) {
                [[cls currentModule] applicationDidBecomeActive:application];
            }
        }
    }
    
}

@end