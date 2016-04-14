//
//  GQModuleRequestTests.m
//  GQModularize
//
//  Created by 钱国强 on 16/4/14.
//  Copyright © 2016年 Qian GuoQiang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import <GQModularize/GQModule.h>
#import <GQModularize/GQModuleRequest.h>

@interface GQModuleRequestTests : XCTestCase

@end

@implementation GQModuleRequestTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitWithIdentfierOptionsModule{
    NSString *identifier = @"foo";
    NSDictionary *options = @{};
    GQModule *mockModule = OCMClassMock([GQModule class]);
    
    GQModuleRequest *request = [[GQModuleRequest alloc] initWithIdentifier:identifier
                                                                   options:options
                                                                    module:mockModule];
    
    XCTAssertEqual(request.identifier, identifier);
    XCTAssertEqual(request.options, options);
    XCTAssertEqual(request.requestModule, mockModule);
}


@end
