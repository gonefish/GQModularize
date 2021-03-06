//
//  GQModuleCenter.m
//  Pods
//
//  Created by 钱国强 on 16/3/24.
//
//

#import "GQModuleCenter.h"
#import <pthread.h>

#import "GQModule.h"
#import "GQModuleMiddleware.h"

static pthread_mutex_t _pthreadLock = PTHREAD_MUTEX_INITIALIZER;

NSString * const GQModuleCenterEventUpdateValueKey = @"GQModuleCenterEventUpdateValueKey";

@interface GQModuleCenter ()

@property (nonatomic, strong) NSMutableArray<NSString *> *moduleClassNames;

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *moduleActionIdentifierMap;

@property (nonatomic, strong) NSMutableArray<id <GQModuleMiddleware>> *middlewares;

@property (nonatomic, strong) NSMutableDictionary *middlewareMap;

@property (nonatomic, strong) NSNotificationCenter *notificationCenter;


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
        
        _notificationCenter = [[NSNotificationCenter alloc] init];
    }
    
    return self;
}

+ (void)registerModuleWithClassName:(NSString *)name
{
    Class cls = NSClassFromString(name);
    
    // 不是GQModule的子类
    if (![cls isSubclassOfClass:[GQModule class]]) {
        return;
    }
    
    GQModuleCenter *sharedInstance = [self sharedInstance];
    
    pthread_mutex_lock(&_pthreadLock);
    
    if ([sharedInstance.moduleClassNames containsObject:name] == NO) {
        [sharedInstance.moduleClassNames addObject:name];
        
        for (NSString *identifier in [cls supportActionIdentifiers]) {
            sharedInstance.moduleActionIdentifierMap[identifier] = name;
        }
    }
    
    pthread_mutex_unlock(&_pthreadLock);
}

+ (void)unregisterModuleWithClassName:(NSString *)name
{
    GQModuleCenter *sharedInstance = [self sharedInstance];
    
    NSMutableArray *removeKeys = [NSMutableArray array];
    
    pthread_mutex_lock(&_pthreadLock);
    
    [sharedInstance.moduleClassNames removeObject:name];
    
    for (NSString *key in sharedInstance.moduleActionIdentifierMap) {
        
        if ([sharedInstance.moduleActionIdentifierMap[key] isEqualToString:name]) {
            [removeKeys addObject:key];
        }
    }
    
    [sharedInstance.moduleActionIdentifierMap removeObjectsForKeys:removeKeys];
    
    pthread_mutex_unlock(&_pthreadLock);
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
    
    pthread_mutex_lock(&_pthreadLock);
    
    id middleware = [sharedInstance.middlewareMap objectForKey:name];
    
    if (middleware == nil) {
        middleware = [[cls alloc] init];
        
        [sharedInstance.middlewares addObject:middleware];
        
        [sharedInstance.middlewareMap setObject:middleware forKey:name];
    }
    
    pthread_mutex_unlock(&_pthreadLock);
}

+ (void)unregisterMiddlewareWithClassName:(NSString *)name
{
    GQModuleCenter *sharedInstance = [self sharedInstance];
    
    pthread_mutex_lock(&_pthreadLock);
    
    id middleware = [sharedInstance.middlewareMap objectForKey:name];
    
    if (middleware) {
        [sharedInstance.middlewares removeObject:middleware];
        
        [sharedInstance.middlewareMap removeObjectForKey:name];
    }
    
    pthread_mutex_unlock(&_pthreadLock);
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

@implementation GQModuleCenter (GQModuleCenterEventObserverSupport)

+ (void)postEventName:(NSString *)eventName updateValue:(id)updateValue
{
    NSNotificationCenter *notificationCenter = [[self sharedInstance] notificationCenter];
    
    [notificationCenter postNotificationName:eventName
                                      object:nil
                                    userInfo:updateValue ? @{GQModuleCenterEventUpdateValueKey : updateValue} : nil];
}

+ (id)addObserverForEventName:(NSString *)eventName usingBlock:(void (^)(id updateValue))block
{
    NSNotificationCenter *notificationCenter = [[self sharedInstance] notificationCenter];
    
    return [notificationCenter addObserverForName:eventName
                                           object:nil
                                            queue:nil
                                       usingBlock:^(NSNotification * _Nonnull note) {
                                           
                                           id updateValue = note.userInfo[GQModuleCenterEventUpdateValueKey];
                                           
                                           if (block) {
                                               block(updateValue);
                                           }
                                       }];
}

+ (void)removeObserver:(id)observer
{
    if (observer == nil) {
        return;
    }
    
    NSNotificationCenter *notificationCenter = [[self sharedInstance] notificationCenter];
    
    [notificationCenter removeObserver:observer];
}

@end