//
//  RefugeRestroomManagerTests.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/5/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "RefugeRestroomManager.h"

@interface RefugeRestroomManagerTests : XCTestCase

@property (nonatomic, strong) RefugeRestroomManager *restroomManager;

@end

@implementation RefugeRestroomManagerTests

- (void)setUp
{
    [super setUp];
    
    self.restroomManager = [[RefugeRestroomManager alloc] init];
}

- (void)tearDown
{
    self.restroomManager = nil;
    
    [super tearDown];
}

- (void)testThatRestroomManagerExists
{
    XCTAssertNotNil(self.restroomManager, @"Should be able to create a new RestroomManager instance");
}

@end
