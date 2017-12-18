//
//  ProductTests.m
//  Shopify Test TaskTests
//
//  Created by SS D on 2017-12-17.
//  Copyright © 2017 SS D. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Product.h"

@interface ProductTests : XCTestCase

@end

@implementation ProductTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSString * title = @"Banana";
    NSString * desc = @"This is a banana";
    Product * product = [[Product alloc]initWithTitle:title andDescription:desc];
    XCTAssertTrue(product.title == title);
    XCTAssertTrue(product.productDescription == desc);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
