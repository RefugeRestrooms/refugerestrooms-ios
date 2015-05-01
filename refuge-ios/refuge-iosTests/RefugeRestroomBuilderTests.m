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
    
    self.restroomsFromBuilder = [self.restroomBuilder buildRestroomsFromJSON:self.restroomJSON error:NULL];
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
    XCTAssertEqualObjects(self.restroom.identifier, @"4327", @"Restroom created with Restroombuilder should have correct properties");
    XCTAssertEqualObjects(self.restroom.name, @"Target", @"Restroom created with Restroombuilder should have correct properties");
    XCTAssertEqualObjects(self.restroom.street, @"7900 Old Wake Forest Rd", @"Restroom created with Restroombuilder should have correct properties");
    XCTAssertEqualObjects(self.restroom.city, @"Raleigh", @"Restroom created with Restroombuilder should have correct properties");
    XCTAssertEqualObjects(self.restroom.state, @"NC", @"Restroom created with Restroombuilder should have correct properties");
    XCTAssertEqualObjects(self.restroom.country, @"US", @"Restroom created with Restroombuilder should have correct properties");
    XCTAssertEqual(self.restroom.isAccessible, [NSNumber numberWithBool:NO], @"Restroom created with Restroombuilder should have correct properties");
    XCTAssertEqual(self.restroom.isUnisex, [NSNumber numberWithBool:YES], @"Restroom created with Restroombuilder should have correct properties");
    XCTAssertEqualObjects(self.restroom.numUpvotes, [NSNumber numberWithInt:1], @"Restroom created with Restroombuilder should have correct properties");
    XCTAssertEqualObjects(self.restroom.numDownvotes, [NSNumber numberWithInt:0], @"Restroom created with Restroombuilder should have correct properties");
    XCTAssertEqualObjects(self.restroom.directions, @"There are single-stall bathrooms by the pharmacy, next to the deodorant aisle.", @"Restroom created with Restroombuilder should have correct properties");
    XCTAssertEqualObjects(self.restroom.comment, @"This is the Target by Triangle Town Center.", @"Restroom created with Restroombuilder should have correct properties");
    XCTAssertEqualObjects(self.restroom.latitude, [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithDouble:35.867321] decimalValue]], @"Restroom created with Restroombuilder should have correct properties");
    XCTAssertEqualObjects(self.restroom.longitude, [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithDouble:-78.567711] decimalValue]], @"Restroom created with Restroombuilder should have correct properties");
    XCTAssertEqualObjects(self.restroom.createdDate, [NSDate RefugeDateFromString:@"2014-02-02T20:55:31.555Z"], @"Restroom created with Restroombuilder should have correct properties");
}

- (void)testThatNilIsNotAnAcceptableJSONParameter
{
    XCTAssertThrows([self.restroomBuilder buildRestroomsFromJSON:nil error:NULL], @"RestroomBuilder should not accept nil for JSON parameter");
}

- (void)testInvalidJSONReturnsNilWithError
{
    NSString *invalidJSON = @"Not JSON";
    NSError *error;
    NSArray *restrooms = [self.restroomBuilder buildRestroomsFromJSON:invalidJSON error:&error];
    
    XCTAssertNil(restrooms, @"Nil should be returned when invalid JSON is passed in to RestroomBuilder");
    XCTAssertEqual([error code], RefugeRestroomBuilderDeserializationErrorCode, @"Error should be set when invalid JSON is passed to RestroomBuilder");
}

- (void)testRealJSONWithoutRestroomPropertiesReturnsNilWithError
{
    NSArray *invalidJSON = @[ @"{ \"key\": \"value\" }" ];
    NSError *error;
    NSArray *restrooms = [self.restroomBuilder buildRestroomsFromJSON:invalidJSON error:&error];
    
    XCTAssertNil(restrooms, @"JSON should not be parsed without Restroom properties");
    XCTAssertEqual([error code], RefugeRestroomBuilderDeserializationErrorCode, @"Error should be set for JSON without Restroom properties");
}

- (void)testThatJSONWithMissingValuesReturnsNilWithError
{
    NSString *jsonWithMissingProperties = @"{"
    @"\"author\": \"\","
    @"\"categories\": \"\","
    @"\"lastCheckedOut\": \"\","
    @"\"lastCheckedOutBy\": \"\","
    @"\"publisher\": \"\","
    @"\"title\": \"\","
    @"\"url\": \"\""
    @"}";
    
    NSArray *jsonObjects = @[ jsonWithMissingProperties ];
    
    NSError *error;
    NSArray *restrooms = [self.restroomBuilder buildRestroomsFromJSON:jsonObjects error:&error];
    
    XCTAssertNil(restrooms, @"JSON should not be parsed if it is missing values");
    XCTAssertEqual([error code], RefugeRestroomBuilderDeserializationErrorCode, @"Error should be set for JSON with missing values");
}

- (void)testThatJSONPassedToBuilderAsNonDictionaryOrArrayReturnsNilWithError
{
    NSString *invalidJSON = @"{"
    @"\"author\": \"Jason Morris\","
    @"\"categories\": \"android, ui, testing\","
    @"\"lastCheckedOut\": \"2014-04-08 19:16:11\","
    @"\"lastCheckedOutBy\": \"Harlan\","
    @"\"publisher\": \"Packt Publishing\","
    @"\"title\": \"Android User Interface Development: Beginner's Guide\","
    @"\"url\": \"/books/1\""
    @"}";
    
    NSError *error;
    NSArray *restrooms = [self.restroomBuilder buildRestroomsFromJSON:invalidJSON error:&error];
    
    XCTAssertNil(restrooms, @"JSON should not be parsed if it is not an array or dictionary");
    XCTAssertEqual([error code], RefugeRestroomBuilderDeserializationErrorCode, @"Error should be set for invalid JSON");
    
}

- (void)testNoErrorReturnedWhenJSONHasZeroRestrooms
{
    id emptyJSON = [NSArray array];
    
    NSError *error;
    NSArray *restrooms = [self.restroomBuilder buildRestroomsFromJSON:emptyJSON error:&error];
    
    XCTAssertEqualObjects(restrooms, [NSArray array], @"JSON with 0 Restrooms should not create Restroom array");
    XCTAssertNil(error, @"JSON with 0 Restrooms should not produce an error");
}

- (void)testThatOneRestroomIsCreatedFromOneDictionary
{
    XCTAssertEqual([self.restroomsFromBuilder count], (NSUInteger)1, @"JSON with one Restroom should create one Restroom object");
}

@end
