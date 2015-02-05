//
//  NSDate+RefugeTests.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/4/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "NSDate+Refuge.h"

@interface NSDate_RefugeTests : XCTestCase

@end

@implementation NSDate_RefugeTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testThatDateFormatExists
{
    XCTAssertNotNil([NSDate dateFormat], @"Date format should exist");
}

- (void)testNSDateFromStringTranslatesDateCorrectly
{
    NSString *dateString = @"2014-02-02T20:55:31.555Z";
    NSDate *date = [NSDate dateFromString:dateString];
    
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
    
    NSInteger year = [dateComponents year];
    NSInteger month = [dateComponents month];
    NSInteger day = [dateComponents day];
    NSInteger hour = [dateComponents hour];
    NSInteger minute = [dateComponents minute];
    NSInteger second = [dateComponents second];
    
    
    XCTAssertEqual(year, 2014, @"Date from string should have correct date components");
    XCTAssertEqual(month, 2, @"Date from string should have correct date components");
    XCTAssertEqual(day, 2, @"Date from string should have correct date components");
    XCTAssertEqual(hour, 20, @"Date from string should have correct date components");
    XCTAssertEqual(minute, 55, @"Date from string should have correct date components");
    XCTAssertEqual(second, 31, @"Date from string should have correct date components");
}

@end
