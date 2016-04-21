//
//  GQModuleTests.m
//  GQModularize
//
//  Created by 钱国强 on 16/4/15.
//  Copyright © 2016年 Qian GuoQiang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import <GQModularize/GQModule.h>

@interface GQModuleTestsModule : GQModule @end

@implementation GQModuleTestsModule

+ (NSArray<NSString *> *)supportActionIdentifiers
{
    return @[@"testInvokeWithIdentifierOptions"];
}

- (id)performActionWithIdentifier:(NSString *)identifier options:(nullable NSDictionary *)options
{
    if ([identifier isEqualToString:GQModulePortalViewControllerIdentifier]) {
        return [UIViewController new];
    } else if ([identifier isEqualToString:@"testInvokeWithIdentifierOptions"]) {
        return @"testInvokeWithIdentifierOptions";
    } else {
        return [NSNull null];
    }
}

@end

@interface GQModuleTestsModuleB : GQModule @end

@implementation GQModuleTestsModuleB

@end

@interface GQModuleTests : XCTestCase

@end

@implementation GQModuleTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCurrentModule
{
    XCTAssertNil([GQModule currentModule]);
    
    XCTAssertEqual([GQModuleTestsModule currentModule], [GQModuleTestsModule currentModule]);
    
    XCTAssertEqual([GQModuleTestsModuleB currentModule], [GQModuleTestsModuleB currentModule]);
}


- (void)testModuleDictionary
{
    XCTAssertNotNil([[GQModuleTestsModule currentModule] moduleDictionary]);
}

- (void)testInvokeWithIdentifier
{
    id mock = OCMClassMock([GQModuleTestsModule class]);
    
    [GQModuleTestsModule invokeWithIdentifier:@"testInvokeWithIdentifier"];
    
    OCMVerify([mock invokeWithIdentifier:@"testInvokeWithIdentifier" options:nil]);
}

- (void)testInvokeWithIdentifierOptions
{
    GQModuleResponse *resp = [GQModuleTestsModule invokeWithIdentifier:@"testInvokeWithIdentifierOptions"];
    
    XCTAssertTrue([resp isKindOfClass:[GQModuleResponse class]]);
    
    XCTAssertTrue([resp gq_string]);
    
    resp = [GQModuleTestsModule invokeWithIdentifier:@"Not Found"];
    
    XCTAssertTrue([resp isKindOfClass:[GQModuleResponse class]]);
    
    XCTAssertEqual([resp originalObject], [NSNull null]);
}

- (void)testPortalViewControllerWithOptions
{
    id mock = OCMPartialMock([GQModuleTestsModule currentModule]);
    
    [mock portalViewControllerWithOptions:nil];
    
    OCMVerify([mock performActionWithIdentifier:GQModulePortalViewControllerIdentifier options:nil]);
}


@end
