//
//  RefugeRestroomBuilderTests.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/4/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "NSDate+Refuge.h"
#import "RefugeRestroom.h"
#import "RefugeRestroomBuilder.h"

@interface RefugeRestroomBuilderTests : XCTestCase

@property (nonatomic, strong) RefugeRestroomBuilder *restroomBuilder;
@property (nonatomic, strong) NSDictionary *restroomJSON;
@property (nonatomic, strong) NSArray *restroomsFromBuilder;
@property (nonatomic, strong) RefugeRestroom *restroom;

@end

@implementation RefugeRestroomBuilderTests

- (void)setUp
{
    [super setUp];
    
    self.restroomBuilder = [[RefugeRestroomBuilder alloc] init];
    
    self.restroomJSON = @{
                          @"id" : @4327,
                          @"name" : @"Target",
                          @"street" : @"7900 Old Wake Forest Rd",
                          @"city" : @"Raleigh",
                          @"state" : @"NC",
                          @"accessible" : @NO,
                          @"unisex" : @YES,
                          @"directions" : @"There are single-stall bathrooms by the pharmacy, next to the deodorant aisle.",
                          @"comment" : @"This is the Target by Triangle Town Center.",
                          @"latitude" : @35.867321,
                          @"longitude" : @-78.567711,
                          @"created_at" : @"2014-02-02T20:55:31.555Z",
                          @"updated_at" : @"2014-02-02T20:55:31.555Z",
                          @"downvote" : @0,
                          @"upvote" : @1,
                          @"country" : @"US",
                          @"pg_search_rank" : @0.66872
                        };
    
    self.restroomsFromBuilder= [self.restroomBuilder buildRestroomsFromJSON:self.restroomJSON error:NULL];
    self.restroom = [self.restroomsFromBuilder objectAtIndex:0];
}

- (void)tearDown
{
    self.restroomBuilder = nil;
    self.restroomJSON = nil;
    self.restroomsFromBuilder = nil;
    self.restroom = nil;
    
    [super tearDown];
}

- (void)testThatRestroomBuilderExists
{
    XCTAssertNotNil(self.restroomBuilder, @"Should be able to create a new Restroom Builder instance");
}

- (void)testRestroomCreatedFromJSONHasPropertiesPresentedInJSON
{
    XCTAssertNotNil(self.restroom, @"Restroom created with RestroomBuilder should not be nil");
    XCTAssertEqualObjects(self.restroom.identifier,[NSNumber numberWithInt:4327], @"Restroom created with Restroombuilder should have correct properties");
    XCTAssertEqualObjects(self.restroom.name, @"Target", @"Restroom created with Restroombuilder should have correct properties");
    XCTAssertEqualObjects(self.restroom.street, @"7900 Old Wake Forest Rd", @"Restroom created with Restroombuilder should have correct properties");
    XCTAssertEqualObjects(self.restroom.city, @"Raleigh", @"Restroom created with Restroombuilder should have correct properties");
    XCTAssertEqualObjects(self.restroom.state, @"NC", @"Restroom created with Restroombuilder should have correct properties");
    XCTAssertEqualObjects(self.restroom.country, @"US", @"Restroom created with Restroombuilder should have correct properties");
    XCTAssertFalse(self.restroom.isAccessible, @"Restroom created with Restroombuilder should have correct properties");
    XCTAssertTrue(self.restroom.isUnisex, @"Restroom created with Restroombuilder should have correct properties");
    XCTAssertEqual(self.restroom.numDownvotes, 0, @"Restroom created with Restroombuilder should have correct properties");
    XCTAssertEqual(self.restroom.numUpvotes, 1, @"Restroom created with Restroombuilder should have correct properties");
    XCTAssertEqualObjects(self.restroom.directions, @"There are single-stall bathrooms by the pharmacy, next to the deodorant aisle.", @"Restroom created with Restroombuilder should have correct properties");
    XCTAssertEqualObjects(self.restroom.comment, @"This is the Target by Triangle Town Center.", @"Restroom created with Restroombuilder should have correct properties");
    XCTAssertEqualObjects(self.restroom.createdDate, [NSDate dateFromString:@"2014-02-02T20:55:31.555Z"], @"Restroom created with Restroombuilder should have correct properties");
}

@end
