//
//  RefugeMapKitAnnotationTests.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/9/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import <CoreLocation/CoreLocation.h>
#import "RefugeMapPin.h"
#import "RefugeRestroom.h"

@interface RefugeMapKitAnnotationTests : XCTestCase

@property (nonatomic, strong) RefugeRestroom *restroom;
@property (nonatomic, strong) RefugeMapPin *mapPin;

@end

@implementation RefugeMapKitAnnotationTests

- (void)setUp
{
    [super setUp];
    
    self.restroom = [[RefugeRestroom alloc] init];
    self.restroom.name = @"Target";
    self.restroom.street = @"7129 O'Kelly Chapel Road";
    self.restroom.city = @"Cary";
    self.restroom.state = @"North Carolina";
    
    self.mapPin = [[RefugeMapPin alloc] initWithRestroom:self.restroom];
}

- (void)tearDown
{
    self.restroom = nil;
    self.mapPin = nil;
    
    [super tearDown];
}

- (void)testThatMapPinExists
{
    XCTAssertNotNil(self.mapPin, @"Should be able to create a new MapPin instance");
}

- (void)testThatMapPinCannotBeCreatedFromInit
{
    RefugeMapPin *invalidMapPin;
    
    XCTAssertThrows(invalidMapPin = [[RefugeMapPin alloc] init], @"Should not be able to use init to create a MapPin");
}

- (void)testThatMapPinRestroomIsRestroomEnteredViaInitializer
{
    XCTAssertEqualObjects(self.mapPin.restroom, self.restroom, @"MapPin's Restroom should be Restroom entered via initializer.");
}

- (void)testThatMapPinHasPropertiesProperlyAssignedGivenRestroom
{
    XCTAssertEqualObjects(self.mapPin.title, self.restroom.name, @"MapPin's title should be Restroom's name");
    
    NSString *address = [NSString stringWithFormat:@"%@, %@, %@", self.restroom.street, self.restroom.city, self.restroom.state];
    XCTAssertEqualObjects(self.mapPin.subtitle, address, @"MapPin's subtitle should be Restroom's address");
    
    XCTAssertEqual(self.mapPin.coordinate.latitude, [self.restroom.latitude doubleValue], @"MapPin's coordianate should have Restroom's latitude");
    XCTAssertEqual(self.mapPin.coordinate.longitude, [self.restroom.longitude doubleValue], @"MapPin's coordianate should have Restroom's longitude");
}

@end
