//
//  RRiOSAppTests.m
//  RRiOSAppTests
//
//  Created by Harlan Kellaway on 9/26/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "Restroom.h"

@interface RRiOSAppTests : XCTestCase
{
    Restroom *restroom;
}
@end

@implementation RRiOSAppTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    restroom = [[Restroom alloc] initWithName:@"Target" andStreet:@"7129 O'Kelly Chapel Road" andCity:@"Cary" andState:@"North Carolina" andCountry:@"United States" andFlagForAccessibility:@"false" andFlagForUnisex:@"true" andDirections:@"Labeled \"Family Restroom,\" right around the corner to the left when you walk in. " andComments:@"" andLatitude:@"35.8448936" andLongitude:@"-78.8860234" andNumDownvotes:@"0" andNumUpvotes:@"0" andDateCreated:@"2014-09-21T01:36:51.593Z" andDateUpdated:@"2014-09-21T01:36:51.593Z" andDatabaseID:@"6303"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    restroom = nil;
}

# pragma mark - Test Initialization of Restroom objects

- (void)testThatRestroomExists
{
    XCTAssertNotNil(restroom, @"Should be able to create a Restroom instance.");
}

- (void)testThatRestroomHasAName
{
    XCTAssertEqualObjects(restroom.name, @"Target", @"Restroom should have the name given when initialized.");
}

- (void)testThatRestroomHasAStreet
{
    XCTAssertEqualObjects(restroom.street, @"7129 O'Kelly Chapel Road", @"Restroom should have the street given when initialized.");
}

- (void)testThatRestroomHasACity
{
    XCTAssertEqualObjects(restroom.city, @"Cary", @"Restroom should have the city given when initialized.");
}

- (void)testThatRestroomHasAState
{
    XCTAssertEqualObjects(restroom.state, @"North Carolina", @"Restroom should have the state given when initialized.");
}

- (void)testThatRestroomHasACountry
{
    XCTAssertEqualObjects(restroom.country, @"United States", @"Restroom should have the country given when initialized.");
}

- (void)testThatRestroomHasAFlagForAccessibility
{
    XCTAssertEqualObjects(restroom.isAccessible, @"false", @"Restroom should have the accessibility flag given when initialized.");
}

- (void)testThatRestroomHasAFlagForUnisex
{
    XCTAssertEqualObjects(restroom.isUnisex, @"true", @"Restroom should have the unisex flag given when initialized.");
}

- (void)testThatRestroomHasDirections
{
    XCTAssertEqualObjects(restroom.directions, @"Labeled \"Family Restroom,\" right around the corner to the left when you walk in. ", @"Restroom should have the directions given when initialized.");
}

- (void)testThatRestroomHasComments
{
    XCTAssertEqualObjects(restroom.comment, @"", @"Restroom should have the comments given when initialized.");
}

- (void)testThatRestroomHasALatitude
{
    XCTAssertEqualObjects(restroom.latitude, @"35.8448936", @"Restroom should have the latitude given when initialized.");
}

- (void)testThatRestroomHasALongitude
{
    XCTAssertEqualObjects(restroom.longitude, @"-78.8860234", @"Restroom should have the longitude given when initialized.");
}

- (void)testThatRestroomHasAValueForDownvote
{
    XCTAssertEqualObjects(restroom.numDownvotes, @"0", @"Restroom should have the number of downvotes given when initialized.");
}

- (void)testThatRestroomHasAValueForUpvote
{
    XCTAssertEqualObjects(restroom.numUpvotes, @"0", @"Restroom should have the number of upvotes given when initialized.");
}

- (void)testThatRestroomHasADateForCreatedAt
{
    XCTAssertEqualObjects(restroom.dateCreated, @"2014-09-21T01:36:51.593Z", @"Restroom should have the date created given when initialized.");
}

- (void)testThatRestroomHasADateForUpdatedAt
{
    XCTAssertEqualObjects(restroom.dateUpdated, @"2014-09-21T01:36:51.593Z", @"Restroom should have the date last update given when initialized.");
}

- (void)testThatRestroomHasAnID
{
    XCTAssertEqualObjects(restroom.databaseID, @"6303", @"Restroom should have the database ID given when initialized.");
}

@end
