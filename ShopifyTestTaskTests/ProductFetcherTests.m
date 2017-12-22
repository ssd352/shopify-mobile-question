//
//  ConnectorTests.m
//  Shopify Test TaskTests
//
//  Created by SS D on 2017-12-17.
//  Copyright © 2017 SS D. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ProductsConnector.h"

@interface ProductFetcherTests : XCTestCase

@end

@implementation ProductFetcherTests

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
    ProductsConnector * pf = [[ProductsConnector alloc]init];
    NSLog(@"Sending Request");
    [pf requestProductsWithFilter:nil andError:nil];
    for (Product * p in pf.products) {
        NSLog(@"title is %@ and description is %@", p.title, p.productDescription);
    }
    NSLog(@"%@", pf.products);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
