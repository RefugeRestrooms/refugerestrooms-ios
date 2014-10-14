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
#import "Restroom.h"

// first restroom has all possible data; second has bare minimum
static NSString *restroomJSON = @"[{"
    @"\"id\": 4327,"
    @"\"name\": \"Target\","
    @"\"street\": \"7900 Old Wake Forest Rd\","
    @"\"city\": \"Raleigh\","
    @"\"state\": \"NC\","
    @"\"accessible\": false,"
    @"\"unisex\": true,"
    @"\"directions\": \"There are single-stall bathrooms by the pharmacy, next to the deodorant aisle.\","
    @"\"comment\": \"This is the Target by Triangle Town Center.\","
    @"\"latitude\": 35.867321,"
    @"\"longitude\": -78.567711,"
    @"\"created_at\": \"2014-02-02T20:55:31.555Z\","
    @"\"updated_at\": \"2014-02-02T20:55:31.555Z\","
    @"\"downvote\": 0,"
    @"\"upvote\": 1,"
    @"\"country\": \"US\","
    @"\"pg_search_rank\": 0.66872"
    @"},"
    @"{"
    @"\"id\": 6304,"
    @"\"name\": \"Ali Baba's Kabob Shop\","
    @"\"street\": \"163 Main St\","
    @"\"city\": \"Burlington\","
    @"\"state\": \"VT\","
    @"\"accessible\": true,"
    @"\"unisex\": false,"
    @"\"directions\": \"\","
    @"\"comment\": \"\","
    @"\"latitude\": null,"
    @"\"longitude\": null,"
    @"\"created_at\": \"2014-09-22T18:40:15.660Z\","
    @"\"updated_at\": \"2014-09-22T18:40:15.660Z\","
    @"\"downvote\": 0,"
    @"\"upvote\": 0,"
    @"\"country\": \"United States\""
    @"}]";

@interface RestroomBuilderTests : XCTestCase
{
//    RestroomBuilder *restroomBuilder;
    NSArray *restroomArray;
    Restroom *restroom;
    Restroom *restroomMinimalData; // a restroom with only required data
    RestroomBuilder *restroomBuilder;
}
@end

@implementation RestroomBuilderTests

- (void)setUp
{
    [super setUp];
    
    restroomBuilder = [[RestroomBuilder alloc] init];
    restroomArray = [restroomBuilder restroomsFromJSON:restroomJSON error:NULL];
    restroom = [restroomArray objectAtIndex:0];
    restroomMinimalData = [restroomArray objectAtIndex:1];
}

- (void)tearDown
{
//    restroomBuilder = nil;
    restroomArray = nil;
    restroom = nil;
    restroomMinimalData = nil;
    restroomBuilder = nil;
    
    [super tearDown];
}

//- (void)testThatARestroomBuilderCanBeCreated
//{
//    XCTAssertNotNil(restroomBuilder, @"Should be able to create a RestroomBuilder instance.");
//}

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
    NSString *jsonString = @"{ \"notalldata\": "" }";
    XCTAssertNil([restroomBuilder restroomsFromJSON:jsonString error:NULL], @"JSON is missing required data.");
}

- (void) testRealJSONWithoutQuestionsReturnsMissingDataError
{
    NSString *jsonString = @"{ \"notalldata\": "" }";
    NSError *error = nil;
    [restroomBuilder restroomsFromJSON:jsonString error:&error];
    XCTAssertEqual([error code], RestroomBuilderMissingDataError, @"Missing JSON data should return RestroomBuilderMissingDataError.");
}

- (void)testJSONWithTwoRestroomsReturnsTwoRestroomObjects
{
    NSError *error = nil;
    NSArray *restrooms = [restroomBuilder restroomsFromJSON:restroomJSON error:&error];
    
    XCTAssertEqual([restrooms count], (NSUInteger)2, @"The RestroomBuilder should have created two restroom objects.");
}

- (void)testRestroomCreatedFromJSonHasPropertiesPresentedInJSON
{
    XCTAssertEqualObjects(restroom.name, @"Target", @"The restroom object's name should match the data we sent.");
    
    XCTAssertEqualObjects(restroom.street, @"7900 Old Wake Forest Rd", @"The restroom object's street should match the data we sent.");
    
    XCTAssertEqualObjects(restroom.city, @"Raleigh", @"The restroom object's city should match the data we sent.");
    
    XCTAssertEqualObjects(restroom.state, @"NC", @"The restroom object's state should match the data we sent.");
    
    XCTAssertEqualObjects(restroom.country, @"US", @"The restroom object's country should match the data we sent.");
    
    XCTAssertFalse(restroom.isAccessible, @"The restroom object's accessibility flag should match the data we sent.");
    
    XCTAssertTrue(restroom.isUnisex, @"The restroom object's unisex flag should match the data we sent.");
    
    XCTAssertEqual(restroom.numDownvotes, 0, @"The restroom object's number of downvotes should match the data we sent.");
    
    XCTAssertEqual(restroom.numUpvotes, 1, @"The restroom object's number of upvotes should match the data we sent.");
    
    XCTAssertEqualObjects(restroom.dateCreated, @"2014-02-02T20:55:31.555Z", @"The restroom object's creation date should match the data we sent.");
    
    XCTAssertEqual(restroom.databaseID, 4327, @"The restroom object's databaseID should match the data we sent.");
}

- (void)testOptionalDataSetIfAvailable
{
    XCTAssertEqualObjects(restroom.directions, @"There are single-stall bathrooms by the pharmacy, next to the deodorant aisle.", @"Restroom should have directions set if avaiable in JSON.");
    
    XCTAssertEqualObjects(restroom.comment, @"This is the Target by Triangle Town Center.", @"Restroom should have comment set if avaiable in JSON.");
    
    XCTAssertEqual(restroom.latitude, 35.867321, @"Restroom should have latitude set if avaiable in JSON.");
    
    XCTAssertEqual(restroom.longitude, -78.567711, @"Restroom should have longitude set if avaiable in JSON.");
    
    XCTAssertEqual(restroom.searchRank, 0.66872, @"Restroom should have search rank set if avaiable in JSON.");
}

#warning unimplemented test
- (void)testDirectionsSetToEmptyStringIfUnavailable
{
    
}

#warning unimplemented test
- (void)testCommentsSetToEmptyStringIfUnavailable
{
    
}

//- (void)testOptionalDataNotSetIfUnvailable
//{
//    XCTAssertEqualObjects(restroomMinimalData.directions, @"", @"Restroom should not have directions set if avaiable in JSON.");
//    
//    XCTAssertEqualObjects(restroomMinimalData.comment, @"", @"Restroom should not have comment set if avaiable in JSON.");
//    
//    XCTAssertEqual(restroomMinimalData.latitude, 0, @"Restroom should not have latitude set if avaiable in JSON.");
//    
//    XCTAssertEqual(restroomMinimalData.longitude, 0, @"Restroom should not have longitude set if avaiable in JSON.");
//    
//    XCTAssertEqual(restroomMinimalData.searchRank, 0, @"Restroom should not have search rank set if avaiable in JSON.");
//}

// TODO make dateCreated an NSDate object from string passed by API

@end
