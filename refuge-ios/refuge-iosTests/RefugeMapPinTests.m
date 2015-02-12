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
@property (nonatomic, strong) RefugeMapPin *annotation;

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
    
    self.annotation = [[RefugeMapPin alloc] initWithRestroom:self.restroom];
}

- (void)tearDown
{
    self.restroom = nil;
    self.annotation = nil;
    
    [super tearDown];
}

- (void)testThatMapPinExists
{
    XCTAssertNotNil(self.annotation, @"Should be able to create a new MapPin instance");
}

- (void)testThatMapPinCannotBeCreatedFromInit
{
    RefugeMapPin *invalidAnnotation;
    
    XCTAssertThrows(invalidAnnotation = [[RefugeMapPin alloc] init], @"Should not be able to use init to create a MapPin");
}

- (void)testThatMapPinPropertyIsRestroomEnteredViaInitializer
{
    XCTAssertEqualObjects(self.annotation.restroom, self.restroom, @"MapPin's Restroom should be Restroom entered via initializer.");
}

- (void)testThatMapPinHasPropertiesProperlyAssignedGivenRestroom
{
    XCTAssertEqualObjects(self.annotation.title, self.restroom.name, @"MapPin's title should be Restroom's name");
    
    NSString *address = [NSString stringWithFormat:@"%@, %@, %@", self.restroom.street, self.restroom.city, self.restroom.state];
    XCTAssertEqualObjects(self.annotation.subtitle, address, @"MapPin's subtitle should be Restroom's address");
    
    XCTAssertEqual(self.annotation.coordinate.latitude, [self.restroom.latitude doubleValue], @"MapPin's coordianate should have Restroom's latitude");
    XCTAssertEqual(self.annotation.coordinate.longitude, [self.restroom.longitude doubleValue], @"MapPin's coordianate should have Restroom's longitude");
}

@end
