//
//  GQModuleResponseTests.m
//  GQModularize
//
//  Created by 钱国强 on 16/4/14.
//  Copyright © 2016年 Qian GuoQiang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import <GQModularize/GQModule.h>
#import <GQModularize/GQModuleResponse.h>

@interface GQModuleResponseTests : XCTestCase

@end

@implementation GQModuleResponseTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitWithObjectModule {
    NSObject *object = [[NSObject alloc] init];
    GQModule *mockModule = OCMClassMock([GQModule class]);
    
    GQModuleResponse *response = [[GQModuleResponse alloc] initWithObject:object
                                                                   module:mockModule];
    
    XCTAssertEqual(response.originalObject, object);
    XCTAssertEqual(response.responseModule, mockModule);
}

- (void)testConvertObjectToProtocol
{
    GQModule *mockModule = OCMClassMock([GQModule class]);
    
}

- (void)testConvertObjectToExactClass
{
    UIView *view = [[UIView alloc] init];
    GQModule *mockModule = OCMClassMock([GQModule class]);
    
    GQModuleResponse *response = [[GQModuleResponse alloc] initWithObject:view
                                                                   module:mockModule];
    
    XCTAssertNotNil([response convertObjectToExactClass:[UIView class]]);
    
    XCTAssertNil([response convertObjectToExactClass:[UIResponder class]]);
}

- (void)testConvertObjectToClass
{
    UIView *view = [[UIView alloc] init];
    GQModule *mockModule = OCMClassMock([GQModule class]);
    
    GQModuleResponse *response = [[GQModuleResponse alloc] initWithObject:view
                                                                   module:mockModule];
    
    XCTAssertNotNil([response convertObjectToClass:[UIView class]]);
    
    XCTAssertNotNil([response convertObjectToClass:[UIResponder class]]);
}


@end
