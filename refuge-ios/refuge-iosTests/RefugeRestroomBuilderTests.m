//
//  RefugeRestroomBuilderTests.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/4/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "RefugeRestroomBuilder.h"

@interface RefugeRestroomBuilderTests : XCTestCase

@property (nonatomic, strong) RefugeRestroomBuilder *restroomBuilder;

@end

@implementation RefugeRestroomBuilderTests

- (void)setUp
{
    [super setUp];
    
    self.restroomBuilder = [[RefugeRestroomBuilder alloc] init];
}

- (void)tearDown
{
    self.restroomBuilder = nil;
    
    [super tearDown];
}

- (void)testThatRestroomBuilderExists
{
    XCTAssertNotNil(self.restroomBuilder, @"Should be able to create a new Restroom Builder instance");
}

@end
