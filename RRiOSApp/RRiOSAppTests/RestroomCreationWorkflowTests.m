//
//  RestroomCreationTests.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 9/29/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "MockRestroomManagerDelegate.h"
#import "MockRestroomCommunicator.h"
#import "MockRestroomBuilder.h"

#import "RestroomManager.h"
#import "Restroom.h"

@interface RestroomCreationWorkflowTests : XCTestCase

@end

@implementation RestroomCreationWorkflowTests
{
    RestroomManager *restroomManager;
    MockRestroomManagerDelegate *delegate;
    NSError *underlyingError;
    MockRestroomBuilder *mockRestroomBuilder;
    NSString *restroomJSON;
    
    NSArray *restroomArray;
}

- (void)setUp
{
    [super setUp];
    
    Restroom *restroom = [[Restroom alloc] init];
    restroomArray = [NSArray arrayWithObject:restroom];
    
    restroomManager = [[RestroomManager alloc] init];
    
    delegate = [[MockRestroomManagerDelegate alloc] init];
    restroomManager.delegate = delegate;
    
    underlyingError = [NSError errorWithDomain:@"Test domain" code:0 userInfo:nil];
    
    mockRestroomBuilder = [[MockRestroomBuilder alloc] init];
    mockRestroomBuilder.arrayToReturn = nil;
    mockRestroomBuilder.errorToSet = underlyingError;
    
    restroomManager.restroomBuilder = mockRestroomBuilder;
    
    restroomJSON = @"[{"
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
        @"}]";
}

- (void)tearDown
{
    restroomManager = nil;
    delegate = nil;
    underlyingError = nil;
//    restroomManager.restroomBuilder = nil;
    mockRestroomBuilder = nil;
    restroomArray = nil;
    restroomJSON = nil;
    
    [super tearDown];
}

- (void)testThatARestroomManagerCanBeCreated
{
    XCTAssertNotNil(restroomManager, @"Should be able to create a RestroomManager instance.");
}

- (void)testNonConformingObjectCannotBeDelegate
{
    XCTAssertThrows(restroomManager.delegate = (id <RestroomManagerDelegate>)[NSNull null], @"NSNull should not be used as the delegate as it doesn't conform to the delegate protocol.");
}

- (void)testConformingObjectCanBeDelegate
{
    id <RestroomManagerDelegate> testDelegate = [[MockRestroomManagerDelegate alloc] init];
    
    XCTAssertNoThrow(restroomManager.delegate = testDelegate, @"Object conforming to the delegate protocol should be used as the delegate.");
}

- (void)testManagerAcceptsNilAsDelegate
{
    XCTAssertNoThrow(restroomManager.delegate = nil, @"It should be acceptable to use nil as an object's delegate.");
}

- (void)testSearchingForRestroomMeansReqestingData
{
    MockRestroomCommunicator *communicator = [[MockRestroomCommunicator alloc] init];
    
    NSString *query = @"Target";
    
    restroomManager.restroomCommunicator = communicator;
    [restroomManager fetchRestroomsForQuery:query];
    
    XCTAssertTrue([communicator wasAskedToFetchRestrooms], @"The communicator should need to fetch data.");
}

// don't report underlying error to delegate for user to see
- (void)testErrorReturnedToDelegateIsNotSameErrorNotifiedByCommunicator
{
    [restroomManager searchingForRestroomsFailedWithError:underlyingError];
    
    XCTAssertFalse(underlyingError == [delegate fetchError], @"Error should be at the correct level of abstraction.");
}

// we still want to document error for admins
- (void)testErrorReturnedToDelegateDocumentsUnderlyingError
{
    [restroomManager searchingForRestroomsFailedWithError: underlyingError];
    
    XCTAssertEqualObjects([[[delegate fetchError] userInfo] objectForKey: NSUnderlyingErrorKey], underlyingError, @"The underlying should be available to client code.");
}

- (void)testRestroomJSONIsPassedToRestroomBuilder
{
    [restroomManager receivedRestroomsJSONString:restroomJSON];
    
    XCTAssertEqualObjects(mockRestroomBuilder.JSON, restroomJSON, @"Downloaded JSON should be sent to RestroomBuilder.");
}

#warning unimplemented method
- (void)testLessThanTwoRestroomsPassedASJSONDoesntCauseError
{
    
}

- (void)testDelegateNotifiedOfErrorWhenRestroomBuilderFails
{
    XCTAssertNotNil(@"The delegate should have found out about the error created when RestroomBuilder fails.");
}

- (void)testDelegateIsNotToldAboutErrorWhenRestroomsReceived
{
    mockRestroomBuilder.arrayToReturn = restroomArray;
    [restroomManager receivedRestroomsJSONString:restroomJSON];
    
    XCTAssertNil([delegate fetchError], @"No error should be received on restroom JSON being received successfully.");
}

- (void)testDelegateReceivesTheRestroomsDiscoveredByManager
{
    mockRestroomBuilder.arrayToReturn = restroomArray;
    [restroomManager receivedRestroomsJSONString:@"Fake JSON"];
    
    XCTAssertEqualObjects([delegate receivedRestrooms], restroomArray, @"The manager should have sent its restroom to the delegate.");
}

- (void)testEmptyArrayIsPassedToDelegateWhenNoRestroomsReceived
{
    mockRestroomBuilder.arrayToReturn = [NSArray array];
    [restroomManager receivedRestroomsJSONString:@"Fake JSON"];
    
    XCTAssertEqualObjects([delegate receivedRestrooms], [NSArray array], @"Returning an empty array of Restrooms should not be an error.");
}

@end
