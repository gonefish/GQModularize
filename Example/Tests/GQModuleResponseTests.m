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
    XCTAssertEqual(response.module, mockModule);
}

- (void)testConvertObjectToProtocol
{
    id object = OCMProtocolMock(@protocol(NSObject));
    
    GQModule *mockModule = OCMClassMock([GQModule class]);
    
    GQModuleResponse *response = [[GQModuleResponse alloc] initWithObject:object
                                                                   module:mockModule];
    
    XCTAssertEqual([response convertObjectToProtocol:@protocol(NSObject)], object);
    
    XCTAssertNil([response convertObjectToProtocol:@protocol(NSCopying)]);
}

- (void)testConvertObjectToExactClass
{
    UIView *view = [[UIView alloc] init];
    
    GQModule *mockModule = OCMClassMock([GQModule class]);
    
    GQModuleResponse *response = [[GQModuleResponse alloc] initWithObject:view
                                                                   module:mockModule];
    
    XCTAssertEqual([response convertObjectToExactClass:[UIView class]], view);
    
    XCTAssertNil([response convertObjectToExactClass:[UIResponder class]]);
}

- (void)testConvertObjectToClass
{
    UIView *view = [[UIView alloc] init];
    
    GQModule *mockModule = OCMClassMock([GQModule class]);
    
    GQModuleResponse *response = [[GQModuleResponse alloc] initWithObject:view
                                                                   module:mockModule];
    
    XCTAssertEqual([response convertObjectToClass:[UIView class]], view);
    
    XCTAssertEqual([response convertObjectToClass:[UIResponder class]], view);
    
    XCTAssertNil([response convertObjectToClass:[UITableView class]]);
}

- (void)testgq_array
{
    NSArray *array = [NSArray new];
    
    GQModule *mockModule = OCMClassMock([GQModule class]);
    
    GQModuleResponse *response = [[GQModuleResponse alloc] initWithObject:array
                                                                   module:mockModule];
    
    XCTAssertEqual([response gq_array], array);
}

- (void)testgq_dictionary
{
    NSDictionary *dictionary = [NSDictionary dictionary];
    
    GQModule *mockModule = OCMClassMock([GQModule class]);
    
    GQModuleResponse *response = [[GQModuleResponse alloc] initWithObject:dictionary
                                                                   module:mockModule];
    
    XCTAssertEqual([response gq_dictionary], dictionary);
}

- (void)testgq_set
{
    NSSet *set = [NSSet set];
    
    GQModule *mockModule = OCMClassMock([GQModule class]);
    
    GQModuleResponse *response = [[GQModuleResponse alloc] initWithObject:set
                                                                   module:mockModule];
    
    XCTAssertEqual([response gq_set], set);
}

- (void)testgq_data
{
    NSData *data = [NSData data];
    
    GQModule *mockModule = OCMClassMock([GQModule class]);
    
    GQModuleResponse *response = [[GQModuleResponse alloc] initWithObject:data
                                                                   module:mockModule];
    
    XCTAssertEqual([response gq_data], data);
}

- (void)testgq_string
{
    NSString *string = [NSString string];
    
    GQModule *mockModule = OCMClassMock([GQModule class]);
    
    GQModuleResponse *response = [[GQModuleResponse alloc] initWithObject:string
                                                                   module:mockModule];
    
    XCTAssertEqual([response gq_string], string);
}

- (void)testgq_date
{
    NSDate *date = [NSDate date];
    
    GQModule *mockModule = OCMClassMock([GQModule class]);
    
    GQModuleResponse *response = [[GQModuleResponse alloc] initWithObject:date
                                                                   module:mockModule];
    
    XCTAssertEqual([response gq_date], date);
}

- (void)testgq_number
{
    NSNumber *number = @0;
    
    GQModule *mockModule = OCMClassMock([GQModule class]);
    
    GQModuleResponse *response = [[GQModuleResponse alloc] initWithObject:number
                                                                   module:mockModule];
    
    XCTAssertEqual([response gq_number], number);
}


@end
