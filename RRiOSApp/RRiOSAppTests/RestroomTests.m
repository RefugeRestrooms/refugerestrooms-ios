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
    
    restroom = [[Restroom alloc] initWithName:@"Target" street:@"7129 O'Kelly Chapel Road" city:@"Cary" state:@"North Carolina" country:@"United States" isAccessible:FALSE isUnisex:TRUE numDownvotes:0 numUpvotes:0 latitude:10.0 longitude:20.0 databaseID:30];
    
    restroom.directions = @"Labeled \"Family Restroom,\" right around the corner to the left when you walk in. ";
    restroom.comment = @"";
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

- (void)testThatIDCanBeSet
{
    int testID = 1111;
    restroom.databaseID = testID;
    
    XCTAssertEqual(testID, restroom.databaseID, @"Should be able to set ID for Restroom.");
}

- (void)testThatDirectionsCanBeSet
{
    NSString *testDirections = @"Labeled \"Family Restroom,\" right around the corner to the left when you walk in. ";
    restroom.directions = testDirections;
    
    XCTAssertEqual(testDirections, restroom.directions, @"Should be able to set directions for Restroom.");
}

- (void)testThatCommentCanBeSet
{
    NSString *testComment = @"Test Comment";
    restroom.comment = testComment;
    
    XCTAssertEqual(testComment, restroom.comment, @"Should be able to set comment for Restroom.");
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
    XCTAssertFalse(restroom.isAccessible, @"Restroom should have the accessibility flag given when initialized.");
}

- (void)testThatRestroomHasAFlagForUnisex
{
    XCTAssertTrue(restroom.isUnisex, @"Restroom should have the unisex flag given when initialized.");
}

- (void)testThatRestroomHasAValueForDownvote
{
    XCTAssertEqual(restroom.numDownvotes, 0, @"Restroom should have the number of downvotes given when initialized.");
}

- (void)testThatRestroomHasAValueForUpvote
{
    XCTAssertEqual(restroom.numUpvotes, 0, @"Restroom should have the number of upvotes given when initialized.");
}

- (void)testInitIsOverriddenWithCustomDesignatedInitializer
{
    Restroom *testRestroom = [[Restroom alloc] init];
    
    XCTAssertEqualObjects(testRestroom.name, @"Ferry Bldg", @"Restroom should have the name given by init override.");
    XCTAssertEqualObjects(testRestroom.street, @"1 Embarcadero", @"Restroom should have the street given by init override.");
    XCTAssertEqualObjects(testRestroom.city, @"San Francisco", @"Restroom should have the city given by init override.");
    XCTAssertEqualObjects(testRestroom.state, @"CA", @"Restroom should have the state given by init override.");
    XCTAssertEqualObjects(testRestroom.country, @"US", @"Restroom should have the country given by init override.");
    XCTAssertFalse(testRestroom.isAccessible, @"Restroom should have the accessibility flag given by init override.");
    XCTAssertFalse(testRestroom.isUnisex, @"Restroom should have the unisex flag given by init override.");
    XCTAssertEqual(testRestroom.numDownvotes, 0, @"Restroom should have the number of downvotes given by init override.");
    XCTAssertEqual(testRestroom.numUpvotes, 0, @"Restroom should have the number of upvotes given by init override.");
}

@end
