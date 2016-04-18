//
//  GQModuleCenterTests.m
//  GQModularize
//
//  Created by 钱国强 on 16/4/14.
//  Copyright © 2016年 Qian GuoQiang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import <GQModularize/GQModule.h>
#import <GQModularize/GQModuleCenter.h>
#import <GQModularize/GQModuleMiddleware.h>

#import "GQModuleCenter+Private.h"

@interface GQModuleCenterTestsModule : GQModule

@end

@implementation GQModuleCenterTestsModule

+ (NSArray<NSString *> *)supportActionIdentifiers;
{
    return @[@"app://foo", @"app://foo", @"app://bar"];
}

@end

@interface GQModuleCenterTestsMiddleware : NSObject <GQModuleMiddleware>

@end

@implementation GQModuleCenterTestsMiddleware

@end


@interface GQModuleCenterTests : XCTestCase

@end

@implementation GQModuleCenterTests

- (void)setUp {
    [super setUp];
    [[GQModuleCenter sharedInstance].moduleClassNames removeAllObjects];
    [[GQModuleCenter sharedInstance].moduleActionIdentifierMap removeAllObjects];
    [[GQModuleCenter sharedInstance].middlewares removeAllObjects];
    [[GQModuleCenter sharedInstance].middlewareMap removeAllObjects];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testRegisterModuleWithClassName
{
    [GQModuleCenter registerModuleWithClassName:@"GQModuleCenterTestsModule"];
    
    XCTAssertEqual([[[GQModuleCenter sharedInstance] moduleClassNames] count], 1);
    
    NSDictionary *map = @{@"app://foo" : @"GQModuleCenterTestsModule",
                          @"app://bar" : @"GQModuleCenterTestsModule"};
    
    XCTAssertEqualObjects([[GQModuleCenter sharedInstance] moduleActionIdentifierMap], map);
    
    [GQModuleCenter registerModuleWithClassName:@"GQModuleCenterTestsModule"];
    
    XCTAssertEqual([[[GQModuleCenter sharedInstance] moduleClassNames] count], 1);
    
    XCTAssertEqualObjects([[GQModuleCenter sharedInstance] moduleActionIdentifierMap], map);
    
    [GQModuleCenter registerModuleWithClassName:@"NSObject"];
    
    XCTAssertEqual([[[GQModuleCenter sharedInstance] moduleClassNames] count], 1);
    
    XCTAssertEqualObjects([[GQModuleCenter sharedInstance] moduleActionIdentifierMap], map);
}

- (void)testUnregisterModuleWithClassName
{
    [GQModuleCenter registerModuleWithClassName:@"GQModuleCenterTestsModule"];
    [GQModuleCenter unregisterModuleWithClassName:@"GQModuleCenterTestsModule"];
    
    XCTAssertEqual([[[GQModuleCenter sharedInstance] moduleClassNames] count], 0);
    
    XCTAssertEqualObjects([[GQModuleCenter sharedInstance] moduleActionIdentifierMap], @{});
}

- (void)testRegisterMiddlewareWithClassName
{
    [GQModuleCenter registerMiddlewareWithClassName:@"GQModuleCenterTestsMiddleware"];
    
    XCTAssertEqual([[[GQModuleCenter sharedInstance] middlewares] count], 1);
    XCTAssertEqual([[[GQModuleCenter sharedInstance] middlewareMap] count], 1);
    
    id middleware = [[GQModuleCenter sharedInstance] middlewareMap][@"GQModuleCenterTestsMiddleware"];
    
    XCTAssertTrue([middleware isMemberOfClass:[GQModuleCenterTestsMiddleware class]]);
    
    [GQModuleCenter registerMiddlewareWithClassName:@"GQModuleCenterTestsMiddleware"];
    
    XCTAssertEqual([[[GQModuleCenter sharedInstance] middlewares] count], 1);
    XCTAssertEqual([[[GQModuleCenter sharedInstance] middlewareMap] count], 1);
    
    [GQModuleCenter registerMiddlewareWithClassName:@"NSObject"];
    
    XCTAssertEqual([[[GQModuleCenter sharedInstance] middlewares] count], 1);
    XCTAssertEqual([[[GQModuleCenter sharedInstance] middlewareMap] count], 1);
}

- (void)testUnregisterMiddlewareWithClassName
{
    [GQModuleCenter registerMiddlewareWithClassName:@"GQModuleCenterTestsMiddleware"];
    [GQModuleCenter unregisterMiddlewareWithClassName:@"GQModuleCenterTestsMiddleware"];
    
    XCTAssertEqual([[[GQModuleCenter sharedInstance] middlewares] count], 0);
    XCTAssertEqual([[[GQModuleCenter sharedInstance] middlewareMap] count], 0);
}

- (void)testPostEventNameUpdateValue
{
    NSNotificationCenter *notificationCenter = [[GQModuleCenter sharedInstance] notificationCenter];
    
    id observerMock = OCMObserverMock();
    
    [notificationCenter addMockObserver:observerMock name:@"testPostEventNameUpdateValue" object:nil];
    
    [[observerMock expect] notificationWithName:@"testPostEventNameUpdateValue" object:nil userInfo:nil];
    
    [GQModuleCenter postEventName:@"testPostEventNameUpdateValue" updateValue:nil];
    
    [observerMock verify];
}

- (void)testPostEventNameUpdateValue2
{
    NSNotificationCenter *notificationCenter = [[GQModuleCenter sharedInstance] notificationCenter];
    
    id observerMock = OCMObserverMock();
    
    [notificationCenter addMockObserver:observerMock name:@"testPostEventNameUpdateValue2" object:nil];
    
    [[observerMock expect] notificationWithName:@"testPostEventNameUpdateValue2" object:nil userInfo:@{@"GQModuleCenterEventUpdateValueKey" : @"Testing"}];
    
    [GQModuleCenter postEventName:@"testPostEventNameUpdateValue2" updateValue:@"Testing"];
    
    [observerMock verify];
}

- (void)testAddObserverForEventNameUsingBlock
{
    __block NSString *val = nil;
    
    id observer = [GQModuleCenter addObserverForEventName:@"testAddObserverForEventNameUsingBlock"
                                               usingBlock:^(id _Nonnull updateValue) {
                                                   val = updateValue;
                                               }];
    
    [GQModuleCenter postEventName:@"testAddObserverForEventNameUsingBlock"
                      updateValue:@"Testing"];
    
    XCTAssertEqual(val, @"Testing");
    
    [GQModuleCenter removeObserver:observer];
}

- (void)testRemoveObserver
{
    id notificationCenterMock = OCMClassMock([NSNotificationCenter class]);
    
    [[GQModuleCenter sharedInstance] setNotificationCenter:notificationCenterMock];
    
    NSObject *observer = [[NSObject alloc] init];
    
    [GQModuleCenter removeObserver:observer];
    
    OCMVerify([notificationCenterMock removeObserver:observer]);
}

@end
