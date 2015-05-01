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

@property (nonatomic, strong) NSString *dateString;
@property (nonatomic, strong) NSDate *dateFromString;

@end

@implementation NSDate_RefugeTests

- (void)setUp
{
    [super setUp];
    
    self.dateString = @"2014-02-02T20:55:31.555Z";
    self.dateFromString = [NSDate RefugeDateFromString:self.dateString];
}

- (void)tearDown
{
    self.dateString = nil;
    self.dateFromString = nil;
    
    [super tearDown];
}

- (void)testThatDateFormatExists
{
    XCTAssertNotNil([NSDate RefugeDateFormat], @"Date format should exist");
}

- (void)testNSDateFromStringTranslatesDateCorrectly
{
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitNanosecond fromDate:self.dateFromString];
    
    NSInteger year = [dateComponents year];
    NSInteger month = [dateComponents month];
    NSInteger day = [dateComponents day];
    NSInteger hour = [dateComponents hour];
    NSInteger minute = [dateComponents minute];
    NSInteger second = [dateComponents second];
    NSInteger nanosecond = [dateComponents nanosecond];
    
    
    XCTAssertEqual(year, 2014, @"Date from string should have correct date components");
    XCTAssertEqual(month, 2, @"Date from string should have correct date components");
    XCTAssertEqual(day, 2, @"Date from string should have correct date components");
    XCTAssertEqual(hour, 20, @"Date from string should have correct date components");
    XCTAssertEqual(minute, 55, @"Date from string should have correct date components");
    XCTAssertEqual(second, 31, @"Date from string should have correct date components");
    XCTAssertEqual(nanosecond, 555000066, @"Date from string should have correct date components");
}

- (void)testNSDateStringFromDateTranslatesCorrectly
{
    XCTAssertEqualObjects([NSDate RefugeStringFromDate:self.dateFromString], self.dateString, @"String from date should be correct");
}

@end
