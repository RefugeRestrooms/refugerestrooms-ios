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
    XCTAssertNil([restroomBuilder restroomsFromJSON:@"Not JSON" error:NULL], @"Restroom JSON should be parsable.");
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

- (void)testRealJSONWithoutRequiredDataIsError
{    
    NSString *jsonString = @"{ \"name\": "" }";
    XCTAssertNil([restroomBuilder restroomsFromJSON:jsonString error:NULL], @"JSON does not include a name.");
    
    jsonString = @"{ \"street\": "" }";
    XCTAssertNil([restroomBuilder restroomsFromJSON:jsonString error:NULL], @"JSON does not include a street.");
    
    jsonString = @"{ \"city\": "" }";
    XCTAssertNil([restroomBuilder restroomsFromJSON:jsonString error:NULL], @"JSON does not include a city.");
    
    jsonString = @"{ \"state\": "" }";
    XCTAssertNil([restroomBuilder restroomsFromJSON:jsonString error:NULL], @"JSON does not include a state.");
    
    jsonString = @"{ \"country\": "" }";
    XCTAssertNil([restroomBuilder restroomsFromJSON:jsonString error:NULL], @"JSON does not include a country.");
    
    jsonString = @"{ \"accessible\": null }";
    XCTAssertNil([restroomBuilder restroomsFromJSON:jsonString error:NULL], @"JSON does not include a flag for accessbility.");
    
    jsonString = @"{ \"unisex\": null }";
    XCTAssertNil([restroomBuilder restroomsFromJSON:jsonString error:NULL], @"JSON does not include a flag for unisex.");
    
    jsonString = @"{ \"downvote\": null }";
    XCTAssertNil([restroomBuilder restroomsFromJSON:jsonString error:NULL], @"JSON does not include a name.");
    
    jsonString = @"{ \"upvote\": null }";
    XCTAssertNil([restroomBuilder restroomsFromJSON:jsonString error:NULL], @"JSON does not include a name.");
    
    jsonString = @"{ \"created_at\": "" }";
    XCTAssertNil([restroomBuilder restroomsFromJSON:jsonString error:NULL], @"JSON does not include a name.");
    
    jsonString = @"{ \"id\": null }";
    XCTAssertNil([restroomBuilder restroomsFromJSON:jsonString error:NULL], @"JSON does not include a database ID.");
}

- (void) testRealJSONWithoutQuestionsReturnsMissingDataError
{
    NSString *jsonString = @"{ \"name\": "" }";
    NSError *error = nil;
    [restroomBuilder restroomsFromJSON:jsonString error:&error];
    XCTAssertEqual([error code], RestroomBuilderMissingDataError, @"Missing JSON data should return RestroomBuilderMissingDataError.");
    
    jsonString = @"{ \"street\": "" }";
    error = nil;
    [restroomBuilder restroomsFromJSON:jsonString error:&error];
    XCTAssertEqual([error code], RestroomBuilderMissingDataError, @"Missing JSON data should return RestroomBuilderMissingDataError.");
    
    jsonString = @"{ \"city\": "" }";
    error = nil;
    [restroomBuilder restroomsFromJSON:jsonString error:&error];
    XCTAssertEqual([error code], RestroomBuilderMissingDataError, @"Missing JSON data should return RestroomBuilderMissingDataError.");
    
    jsonString = @"{ \"state\": "" }";
    error = nil;
    [restroomBuilder restroomsFromJSON:jsonString error:&error];
    XCTAssertEqual([error code], RestroomBuilderMissingDataError, @"Missing JSON data should return RestroomBuilderMissingDataError.");
    
    jsonString = @"{ \"country\": "" }";
    error = nil;
    [restroomBuilder restroomsFromJSON:jsonString error:&error];
    XCTAssertEqual([error code], RestroomBuilderMissingDataError, @"Missing JSON data should return RestroomBuilderMissingDataError.");
    
    jsonString = @"{ \"accessible\": "" }";
    error = nil;
    [restroomBuilder restroomsFromJSON:jsonString error:&error];
    XCTAssertEqual([error code], RestroomBuilderMissingDataError, @"Missing JSON data should return RestroomBuilderMissingDataError.");
    
    jsonString = @"{ \"unisex\": "" }";
    error = nil;
    [restroomBuilder restroomsFromJSON:jsonString error:&error];
    XCTAssertEqual([error code], RestroomBuilderMissingDataError, @"Missing JSON data should return RestroomBuilderMissingDataError.");
    
    jsonString = @"{ \"downvote\": "" }";
    error = nil;
    [restroomBuilder restroomsFromJSON:jsonString error:&error];
    XCTAssertEqual([error code], RestroomBuilderMissingDataError, @"Missing JSON data should return RestroomBuilderMissingDataError.");
    
    jsonString = @"{ \"upvote\": "" }";
    error = nil;
    [restroomBuilder restroomsFromJSON:jsonString error:&error];
    XCTAssertEqual([error code], RestroomBuilderMissingDataError, @"Missing JSON data should return RestroomBuilderMissingDataError.");
    
    jsonString = @"{ \"created_at\": "" }";
    error = nil;
    [restroomBuilder restroomsFromJSON:jsonString error:&error];
    XCTAssertEqual([error code], RestroomBuilderMissingDataError, @"Missing JSON data should return RestroomBuilderMissingDataError.");
    
    jsonString = @"{ \"id\": "" }";
    error = nil;
    [restroomBuilder restroomsFromJSON:jsonString error:&error];
    XCTAssertEqual([error code], RestroomBuilderMissingDataError, @"Missing JSON data should return RestroomBuilderMissingDataError.");
}

// TODO create tests for latitude, longitude, directions, comment, and search_rank being updated if JSON values exist

@end
