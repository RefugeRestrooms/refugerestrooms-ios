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
    @"\"latitude\": 35.867321,"
    @"\"longitude\": -78.567711,"
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
}

- (void)tearDown
{
    restroomBuilder = nil;
    restroomArray = nil;
    restroom = nil;
    restroomBuilder = nil;
    
    [super tearDown];
}

- (void)testThatARestroomBuilderCanBeCreated
{
    XCTAssertNotNil(restroomBuilder, @"Should be able to create a RestroomBuilder instance.");
}

- (void)testThatErrorsWithCustomCodesCanBeCreated
{
    NSError *error1 = [NSError errorWithDomain:@"TestingErrorDomain" code:RestroomBuilderErrorCodeMissingDataError userInfo:nil];
    
    XCTAssertNotNil(error1, @"Should be able to create RestroomBuilderMissingDataError.");
    XCTAssertEqual([error1 code], RestroomBuilderErrorCodeMissingDataError, @"Error should have correct code.");
    
}

- (void)testThatNilIsNotAnAcceptableParameter
{
    XCTAssertThrows([restroomBuilder restroomsFromJSON:nil error:NULL], @"Lack of data for RestroomBuilder should have been handled elsewhere.");
}

- (void)testNilReturnedWhenStringIsNotJSON
{
    NSString *invalidJSON = @"Not JSON";
    
    NSArray *restrooms = [restroomBuilder restroomsFromJSON:invalidJSON error:NULL];
    
    XCTAssertNil(restrooms, @"Restroom JSON should be parsable.");
}

- (void)testNotJSONReturnsInvalidJSONError
{
    NSError *error = nil;
    [restroomBuilder restroomsFromJSON:@"Not JSON" error:&error];
    
    XCTAssertNotNil(error, @"Error should have been created.");
    XCTAssertEqual([error code], RestroomBuilderErrorCodeInvalidJSONError, @"Invalid JSON syntax should return RestroomBuilderInvalidJSONError.");
}

- (void)testPassingNullErrorDoesNotCauseCrash
{
    XCTAssertNoThrow([restroomBuilder restroomsFromJSON:@"Not JSON" error:NULL], @"Using NULL for error parameter in JSON parser should not cause a crash.");
}

- (void)testRealJSONWithoutRequiredDataIsError
{    
    NSString *jsonWithoutName = @"{"
    @"\"id\": 4327,"
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
    @"}";
    
    XCTAssertNil([restroomBuilder restroomsFromJSON:jsonWithoutName error:NULL], @"Restroom should not be built if JSON is missing required data.");
}

- (void)testRealJSONWithoutAllDataReturnsMissingDataError
{
    NSString *validJSON = @"{ \"notalldata\": \"\" }";
    NSError *error = nil;
    
    [restroomBuilder restroomsFromJSON:validJSON error:&error];
    
    XCTAssertEqual([error code], RestroomBuilderErrorCodeMissingDataError, @"Missing JSON data should return RestroomBuilderMissingDataError.");
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
    
    XCTAssertEqual(restroom.databaseID, 4327, @"The restroom object's databaseID should match the data we sent.");
}

- (void)testOptionalDataSetIfAvailable
{
    XCTAssertEqualObjects(restroom.directions, @"There are single-stall bathrooms by the pharmacy, next to the deodorant aisle.", @"Restroom should have directions set if avaiable in JSON.");
    
    XCTAssertEqualObjects(restroom.comment, @"This is the Target by Triangle Town Center.", @"Restroom should have comment set if avaiable in JSON.");
}

- (void)testDirectionsSetToEmptyStringIfUnavailable
{
    NSString *json = @"[{"
    @"\"id\": 4327,"
    @"\"name\": \"Target\","
    @"\"street\": \"7900 Old Wake Forest Rd\","
    @"\"city\": \"Raleigh\","
    @"\"state\": \"NC\","
    @"\"accessible\": false,"
    @"\"unisex\": true,"
    @"\"directions\": \"\","
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
    @"\"id\": 4327,"
    @"\"name\": \"Target\","
    @"\"street\": \"7900 Old Wake Forest Rd\","
    @"\"city\": \"Raleigh\","
    @"\"state\": \"NC\","
    @"\"accessible\": false,"
    @"\"unisex\": true,"
    @"\"directions\": \"\","
    @"\"comment\": \"This is the Target by Triangle Town Center.\","
    @"\"latitude\": 35.867321,"
    @"\"longitude\": -78.567711,"
    @"\"created_at\": \"2014-02-02T20:55:31.555Z\","
    @"\"updated_at\": \"2014-02-02T20:55:31.555Z\","
    @"\"downvote\": 0,"
    @"\"upvote\": 1,"
    @"\"country\": \"US\","
    @"\"pg_search_rank\": 0.66872"
    @"}]";
    
    NSError *error = nil;
    NSArray *restrooms = [restroomBuilder restroomsFromJSON:json error:&error];
    
    Restroom *noDirectionsRestroom = [restrooms objectAtIndex:0];
    
    XCTAssertEqualObjects(noDirectionsRestroom.directions, @"", @"Restroom built from JSON with no directions should have an empty string for directions.");
}

- (void)testCommentsSetToEmptyStringIfUnavailable
{
    NSString *json = @"[{"
        @"\"id\": 4327,"
        @"\"name\": \"Target\","
        @"\"street\": \"7900 Old Wake Forest Rd\","
        @"\"city\": \"Raleigh\","
        @"\"state\": \"NC\","
        @"\"accessible\": false,"
        @"\"unisex\": true,"
        @"\"directions\": \"There are single-stall bathrooms by the pharmacy, next to the deodorant aisle.\","
        @"\"comment\": \"\","
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
        @"\"id\": 4327,"
        @"\"name\": \"Target\","
        @"\"street\": \"7900 Old Wake Forest Rd\","
        @"\"city\": \"Raleigh\","
        @"\"state\": \"NC\","
        @"\"accessible\": false,"
        @"\"unisex\": true,"
        @"\"directions\": \"\","
        @"\"comment\": \"This is the Target by Triangle Town Center.\","
        @"\"latitude\": 35.867321,"
        @"\"longitude\": -78.567711,"
        @"\"created_at\": \"2014-02-02T20:55:31.555Z\","
        @"\"updated_at\": \"2014-02-02T20:55:31.555Z\","
        @"\"downvote\": 0,"
        @"\"upvote\": 1,"
        @"\"country\": \"US\","
        @"\"pg_search_rank\": 0.66872"
        @"}]";
    
    NSError *error = nil;
    NSArray *restrooms = [restroomBuilder restroomsFromJSON:json error:&error];
    
    Restroom *noCommentRestroom = [restrooms objectAtIndex:0];
    
    XCTAssertEqualObjects(noCommentRestroom.comment, @"", @"Restroom built from JSON with no comment should have an empty string for comment.");
}

- (void)testRestroomNotBuiltIfLatitudeOrLongitudeUnavailable
{
    NSString *json = @"[{"
    @"\"id\": 4327,"
    @"\"name\": \"Target\","
    @"\"street\": \"7900 Old Wake Forest Rd\","
    @"\"city\": \"Raleigh\","
    @"\"state\": \"NC\","
    @"\"accessible\": false,"
    @"\"unisex\": true,"
    @"\"directions\": \"There are single-stall bathrooms by the pharmacy, next to the deodorant aisle.\","
    @"\"comment\": \"This is the Target by Triangle Town Center.\","
    @"\"latitude\": null,"
    @"\"longitude\": -78.567711,"
    @"\"created_at\": \"2014-02-02T20:55:31.555Z\","
    @"\"updated_at\": \"2014-02-02T20:55:31.555Z\","
    @"\"downvote\": 0,"
    @"\"upvote\": 1,"
    @"\"country\": \"US\","
    @"\"pg_search_rank\": 0.66872"
    @"},"
    @"{"
    @"\"id\": 4327,"
    @"\"name\": \"Target\","
    @"\"street\": \"7900 Old Wake Forest Rd\","
    @"\"city\": \"Raleigh\","
    @"\"state\": \"NC\","
    @"\"accessible\": false,"
    @"\"unisex\": true,"
    @"\"directions\": \"\","
    @"\"comment\": \"This is the Target by Triangle Town Center.\","
    @"\"latitude\": 35.867321,"
    @"\"longitude\": -78.567711,"
    @"\"created_at\": \"2014-02-02T20:55:31.555Z\","
    @"\"updated_at\": \"2014-02-02T20:55:31.555Z\","
    @"\"downvote\": 0,"
    @"\"upvote\": 1,"
    @"\"country\": \"US\","
    @"\"pg_search_rank\": 0.66872"
    @"}]";
    
    NSError *error = nil;
    NSArray *restrooms = [restroomBuilder restroomsFromJSON:json error:&error];
    
    XCTAssertThrows([restrooms objectAtIndex:0], @"Restroom should not be built if it has no latitude.");
    
    json = @"[{"
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
    @"\"longitude\": null,"
    @"\"created_at\": \"2014-02-02T20:55:31.555Z\","
    @"\"updated_at\": \"2014-02-02T20:55:31.555Z\","
    @"\"downvote\": 0,"
    @"\"upvote\": 1,"
    @"\"country\": \"US\","
    @"\"pg_search_rank\": 0.66872"
    @"},"
    @"{"
    @"\"id\": 4327,"
    @"\"name\": \"Target\","
    @"\"street\": \"7900 Old Wake Forest Rd\","
    @"\"city\": \"Raleigh\","
    @"\"state\": \"NC\","
    @"\"accessible\": false,"
    @"\"unisex\": true,"
    @"\"directions\": \"\","
    @"\"comment\": \"This is the Target by Triangle Town Center.\","
    @"\"latitude\": 35.867321,"
    @"\"longitude\": -78.567711,"
    @"\"created_at\": \"2014-02-02T20:55:31.555Z\","
    @"\"updated_at\": \"2014-02-02T20:55:31.555Z\","
    @"\"downvote\": 0,"
    @"\"upvote\": 1,"
    @"\"country\": \"US\","
    @"\"pg_search_rank\": 0.66872"
    @"}]";
    
    error = nil;
    restrooms = [restroomBuilder restroomsFromJSON:json error:&error];
    
    XCTAssertThrows([restrooms objectAtIndex:0], @"Restroom should not be built if it has no longitude.");
}

- (void)testBuildingOnlyOneRestroomIsPossible
{
    NSString *json = @"{"
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
    @"}";
    
    NSError *error = nil;
    NSArray *restrooms = [restroomBuilder restroomsFromJSON:json error:&error];
    
    Restroom *singleRestroom = [restrooms objectAtIndex:0];
    
    XCTAssertNotNil(singleRestroom, @"It should be possible to build just one Restroom.");
}

@end
