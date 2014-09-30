//
//  RestroomBuilderTests.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 9/29/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "RestroomBuilder.h"

@interface RestroomBuilderTests : XCTestCase
{
    RestroomBuilder *restroomBuilder;
}
@end

@implementation RestroomBuilderTests

- (void)setUp
{
    [super setUp];
    
    restroomBuilder = [[RestroomBuilder alloc] init];
}

- (void)tearDown
{
    restroomBuilder = nil;
    
    [super tearDown];
}

- (void)testThatARestroomBuilderCanBeCreated
{
    XCTAssertNotNil(restroomBuilder, @"Should be able to create a RestroomBuilder instance.");
}

- (void)testThatNilIsNotAnAcceptableParameter
{
    XCTAssertThrows([restroomBuilder restroomsFromJSON:nil error:NULL], @"Lack of data for RestroomBuilder should have been handled elsewhere.");
}

- (void)testNilReturnedWhenStringIsNotJSON
{
    XCTAssertNil([restroomBuilder restroomsFromJSON:@"Not JSOM" error:NULL], @"Restroom JSON should be parsable.");
}

- (void)testErrorSetWhenStringIsNotJSON
{
    NSError *error = nil;
    [restroomBuilder restroomsFromJSON:@"Not JSON" error:&error];
    
    XCTAssertNotNil(error, @"Error should best set when Restroom data is not JSON.");
}

- (void)testPassingNullErrorDoesNotCauseCrash
{
    XCTAssertNoThrow([restroomBuilder restroomsFromJSON:@"Not JSON" error:NULL], @"Using NULL for error parameter in JSON parser should not cause a crash.");
}

@end
