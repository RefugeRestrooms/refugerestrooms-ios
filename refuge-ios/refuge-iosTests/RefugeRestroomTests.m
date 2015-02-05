//
//  RefugeRestroomTests.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/4/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "RefugeRestroom.h"

@interface RefugeRestroomTests : XCTestCase

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) RefugeRestroom *restroom;

@end

@implementation RefugeRestroomTests

- (void)setUp
{
    [super setUp];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:sss'Z'";
    
    self.restroom = [[RefugeRestroom alloc] init];
    self.restroom.identifier = [NSNumber numberWithInt:100];
    self.restroom.name = @"Target";
    self.restroom.street = @"7129 O'Kelly Chapel Road";
    self.restroom.city = @"Cary";
    self.restroom.state = @"North Carolina";
    self.restroom.country = @"United States";
    self.restroom.isAccessible = NO;
    self.restroom.isUnisex = YES;
    self.restroom.numDownvotes = 0;
    self.restroom.numUpvotes = 1;
    self.restroom.directions = @"Labeled \"Family Restroom,\" right around the corner to the left when you walk in.";
    self.restroom.comment = @"No comment";
    self.restroom.createdDate = [self.dateFormatter dateFromString:@"2014-02-02T20:55:31.555Z"];
}

- (void)tearDown
{
    self.dateFormatter = nil;
    self.restroom = nil;
    
    [super tearDown];
}

- (void)testThatRestroomsExists
{
    XCTAssertNotNil(self.restroom, @"Should be able to create a new Restroom instance");
}

- (void)testThatRestroomPropertiesAreNotInvalid
{
    XCTAssertNotNil(self.restroom.identifier, @"Restroom id should not be nil");
    XCTAssertNotNil(self.restroom.name, @"Restroom id should not be nil");
    XCTAssertNotNil(self.restroom.street, @"Restroom id should not be nil");
    XCTAssertNotNil(self.restroom.city, @"Restroom id should not be nil");
    XCTAssertNotNil(self.restroom.state, @"Restroom id should not be nil");
    XCTAssertNotNil(self.restroom.country, @"Restroom id should not be nil");
    XCTAssertNotNil(self.restroom.directions, @"Restroom id should not be nil");
    XCTAssertNotNil(self.restroom.comment, @"Restroom id should not be nil");
    XCTAssertNotNil(self.restroom.createdDate, @"Restroom id should not be nil");
}

- (void)testThatRestroomPropertiesAreSetCorrectly
{
    XCTAssertEqual(self.restroom.identifier,[NSNumber numberWithInt:100], @"Restroom properties should be set correctly");
    XCTAssertEqualObjects(self.restroom.name, @"Target", @"Restroom properties should be set correctly");
    XCTAssertEqualObjects(self.restroom.street, @"7129 O'Kelly Chapel Road", @"Restroom properties should be set correctly");
    XCTAssertEqualObjects(self.restroom.city, @"Cary", @"Restroom properties should be set correctly");
    XCTAssertEqualObjects(self.restroom.state, @"North Carolina", @"Restroom properties should be set correctly");
    XCTAssertEqualObjects(self.restroom.country, @"United States", @"Restroom properties should be set correctly");
    XCTAssertFalse(self.restroom.isAccessible, @"Restroom properties should be set correctly");
    XCTAssertTrue(self.restroom.isUnisex, @"Restroom properties should be set correctly");
    XCTAssertEqual(self.restroom.numDownvotes, 0, @"Restroom properties should be set correctly");
    XCTAssertEqual(self.restroom.numUpvotes, 1, @"Restroom properties should be set correctly");
    XCTAssertEqualObjects(self.restroom.directions, @"Labeled \"Family Restroom,\" right around the corner to the left when you walk in.", @"Restroom properties should be set correctly");
    XCTAssertEqualObjects(self.restroom.comment, @"No comment", @"Restroom properties should be set correctly");
    XCTAssertEqualObjects(self.restroom.createdDate, [self.dateFormatter dateFromString:@"2014-02-02T20:55:31.555Z"], @"Restroom properties should be set correctly");
}

@end
