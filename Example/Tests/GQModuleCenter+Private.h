//
//  GQModuleCenter+Private.h
//  GQModularize
//
//  Created by 钱国强 on 16/4/15.
//  Copyright © 2016年 Qian GuoQiang. All rights reserved.
//

#import <GQModularize/GQModuleCenter.h>
#import <GQModularize/GQModuleMiddleware.h>

@interface GQModuleCenter ()

@property (nonatomic, strong) NSMutableArray<NSString *> *moduleClassNames;

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *moduleActionIdentifierMap;

@property (nonatomic, strong) NSMutableArray<id <GQModuleMiddleware>> *middlewares;

@property (nonatomic, strong) NSMutableDictionary *middlewareMap;

@property (nonatomic, strong) NSNotificationCenter *notificationCenter;

+ (instancetype)sharedInstance;

@end
