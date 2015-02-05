//
//  RefugeRestroomTests.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/4/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "RefugeRestroom.h"

@interface RefugeRestroomTests : XCTestCase

@property (nonatomic, strong) RefugeRestroom *restroom;

@end

@implementation RefugeRestroomTests

- (void)setUp
{
    [super setUp];
    
    self.restroom = [[RefugeRestroom alloc] init];
}

- (void)tearDown
{
    self.restroom = nil;
    
    [super tearDown];
}

- (void)testThatRestroomsExists
{
    XCTAssertNotNil(self.restroom, @"Should be able to create a new Restroom instance");
}

@end
