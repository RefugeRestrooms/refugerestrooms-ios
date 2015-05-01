//
//  NSString+RefugeTests.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 3/19/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "NSString+Refuge.h"

@interface NSString_RefugeTests : XCTestCase

@property (nonatomic, strong) NSString *string;

@end

@implementation NSString_RefugeTests

- (void)setUp
{
    [super setUp];
    
    self.string = @"This string\\'s not right";
}

- (void)tearDown
{
    self.string = nil;
    
    [super tearDown];
}

- (void)testStringCanBePreparedForDisplay
{
    XCTAssertEqualObjects([self.string RefugePrepareForDisplay], @"This string's not right", @"String should be properly prepared for display");
}

@end
