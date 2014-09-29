//
//  RestroomManagerTests.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 9/29/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "RestroomManager.h"

@interface RestroomManagerTests : XCTestCase

@end

@implementation RestroomManagerTests
{
    RestroomManager *restroomManager;
}

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    restroomManager = [[RestroomManager alloc] init];
}

- (void)tearDown
{
    restroomManager = nil;
    
    [super tearDown];
}

- (void)testThatARestroomManagerCanBeCreated
{
    XCTAssertNotNil(restroomManager, @"Should be able to create a RestroomManager instance.");
}


@end
