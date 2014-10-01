//
//  RestroomCommunicatorTests.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/1/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "InspectableRestroomCommunicator.h"

@interface RestroomCommunicatorTests : XCTestCase
{
    InspectableRestroomCommunicator *inspectableRestroomCommunicator;
}
@end

@implementation RestroomCommunicatorTests

- (void)setUp
{
    [super setUp];
    
    inspectableRestroomCommunicator = [[InspectableRestroomCommunicator alloc] init];
}

- (void)tearDown
{
    inspectableRestroomCommunicator = nil;
    
    [super tearDown];
}

- (void)testThatARestroomManagerCanBeCreated
{
    XCTAssertNotNil(inspectableRestroomCommunicator, @"Should be able to create a RestroomCommunicator instance.");
}

- (void)testSearchingForRestroomsWithQueryCallsRefugeAPICorrectly
{
    [inspectableRestroomCommunicator searchForRestroomsWithQuery:@"Walmart"];
    
    XCTAssertEqualObjects([[inspectableRestroomCommunicator URLToFetch] absoluteString], @"http://www.refugerestrooms.org:80/api/v1/restrooms/search.json?query=Walmart", @"Searching should call the Refuge API.");
}

- (void)testSearchingForRestroomsWithQueryContainingSpacesCallsRefugeAPICorrectly
{
    [inspectableRestroomCommunicator searchForRestroomsWithQuery:@"San Francisco"];
    
    XCTAssertEqualObjects([[inspectableRestroomCommunicator URLToFetch] absoluteString], @"http://www.refugerestrooms.org:80/api/v1/restrooms/search.json?query=San%20Francisco", @"Searching should call the Refuge API.");
}

- (void)testSearchingForRestroomsCreatesURLConnection
{
    [inspectableRestroomCommunicator searchForRestroomsWithQuery:@"San Francisco"];
    
    XCTAssertNotNil([inspectableRestroomCommunicator currentURLConnection], @"There should be a URL connection made when a search is exectued.");
    
    [inspectableRestroomCommunicator cancelAndDiscardURLConnection];
}

- (void)testStartingNewSearchThrowsOutOldConnection
{
    [inspectableRestroomCommunicator searchForRestroomsWithQuery:@"San Francisco"];
    NSURLConnection *firstConnection = [inspectableRestroomCommunicator currentURLConnection];
    
    [inspectableRestroomCommunicator searchForRestroomsWithQuery:@"Walmart"];
    
    XCTAssertFalse([[inspectableRestroomCommunicator currentURLConnection] isEqual:firstConnection], @"The communicator should replace its current URL connection to start a new one.");
    
    [inspectableRestroomCommunicator cancelAndDiscardURLConnection];
}

// TODO: add support for filtering by accessibility/unisex

@end
