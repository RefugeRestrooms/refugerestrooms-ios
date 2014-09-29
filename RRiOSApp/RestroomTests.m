//
//  RestroomTests.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 9/29/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "Restroom.h"

@interface RestroomTests : XCTestCase
{
    Restroom *restroom;
}
@end

@implementation RestroomTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    restroom = [[Restroom alloc] initWithName:@"Target" andStreet:@"7129 O'Kelly Chapel Road" andCity:@"Cary" andState:@"North Carolina" andCountry:@"United States" andIsAccessible:FALSE andIsUnisex:TRUE andDirections:@"Labeled \"Family Restroom,\" right around the corner to the left when you walk in. " andComments:@"" andNumDownvotes:0 andNumUpvotes:0 andDateCreated:[NSDate distantPast] andDateUpdated:[NSDate distantPast] andDatabaseID:@"6303"];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    restroom = nil;
}

# pragma mark - Test Initialization of Restroom objects

- (void)testThatARestroomCanBeCreated
{
    XCTAssertNotNil(restroom, @"Should be able to create a Restroom instance.");
}

- (void)testThatLatitudeCanBeSet
{
    double testLatitude = 35.8448936;
    restroom.latitude = testLatitude;
    
    XCTAssertEqual(testLatitude, restroom.latitude, @"Should be able to set latitude for Restroom.");
}

- (void)testThatLongitudeCanBeSet
{
    double testLongitude = -78.8860234;
    restroom.longitude = testLongitude;
    
    XCTAssertEqual(testLongitude, restroom.longitude, @"Should be able to set longitude for Restroom.");
}

- (void)testThatSearchRankCanBeSet
{
    double testSearchRank = 0.0607927;
    restroom.searchRank = testSearchRank;
    
    XCTAssertEqual(testSearchRank, restroom.searchRank, @"Should be able to se search rank for Restroom.");
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
    XCTAssertEqual(restroom.isAccessible, (BOOL)FALSE, @"Restroom should have the accessibility flag given when initialized.");
}

- (void)testThatRestroomHasAFlagForUnisex
{
    XCTAssertEqual(restroom.isUnisex, (BOOL)TRUE, @"Restroom should have the unisex flag given when initialized.");
}

- (void)testThatRestroomHasDirections
{
    XCTAssertEqualObjects(restroom.directions, @"Labeled \"Family Restroom,\" right around the corner to the left when you walk in. ", @"Restroom should have the directions given when initialized.");
}

- (void)testThatRestroomHasComments
{
    XCTAssertEqualObjects(restroom.comment, @"", @"Restroom should have the comments given when initialized.");
}

- (void)testThatRestroomHasAValueForDownvote
{
    XCTAssertEqual(restroom.numDownvotes, 0, @"Restroom should have the number of downvotes given when initialized.");
}

- (void)testThatRestroomHasAValueForUpvote
{
    XCTAssertEqual(restroom.numUpvotes, 0, @"Restroom should have the number of upvotes given when initialized.");
}

- (void)testThatRestroomHasADateForCreatedAt
{
    XCTAssertTrue([restroom.dateCreated isKindOfClass:[NSDate class]], @"Restroom should have the date created given when initialized.");
}

- (void)testThatRestroomHasADateForUpdatedAt
{
    XCTAssertTrue([restroom.dateUpdated isKindOfClass:[NSDate class]], @"Restroom should have the date last update given when initialized.");
}

- (void)testThatRestroomHasAnID
{
    XCTAssertEqualObjects(restroom.databaseID, @"6303", @"Restroom should have the database ID given when initialized.");
}


@end
