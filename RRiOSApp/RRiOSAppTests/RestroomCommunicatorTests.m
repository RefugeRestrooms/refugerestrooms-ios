//
//  RestroomCommunicatorTests.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/1/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "RestroomCommunicator.h"

@interface RestroomCommunicatorTests : XCTestCase
{
    RestroomCommunicator *restroomCommunicator;
}
@end

@implementation RestroomCommunicatorTests

- (void)setUp
{
    [super setUp];
    
    restroomCommunicator = [[RestroomCommunicator alloc] init];
}

- (void)tearDown
{
    restroomCommunicator = nil;
    
    [super tearDown];
}

- (void)testThatARestroomManagerCanBeCreated
{
    XCTAssertNotNil(restroomCommunicator, @"Should be able to create a RestroomCommunicator instance.");
}

@end
