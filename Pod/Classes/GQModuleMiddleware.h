//
//  GQModuleMiddleware.h
//  Pods
//
//  Created by 钱国强 on 16/3/31.
//
//

#import <Foundation/Foundation.h>

@class GQModuleRequest;
@class GQModuleResponse;

@protocol GQModuleMiddleware <NSObject>

@optional

- (BOOL)shouldProcessRequest:(GQModuleRequest *)request;

- (GQModuleRequest *)processRequest:(GQModuleRequest *)request;

- (GQModuleResponse *)processResponse:(GQModuleResponse *)response withRequest:(GQModuleRequest *)request;

@end
