//
//  RefugeMapTests.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/11/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "MockRefugeMapDelegate.h"
#import "RefugeMap.h"
#import "RefugeMapPin.h"
#import "RefugeRestroom.h"

@interface RefugeMapTests : XCTestCase

@property (nonatomic, strong) RefugeMap *map;
@property (nonatomic, strong) MockRefugeMapDelegate *mapDelegate;
@property (nonatomic, strong) RefugeRestroom *restroom;
@property (nonatomic, strong) RefugeMapPin *mapPin;

@end

@implementation RefugeMapTests

- (void)setUp
{
    [super setUp];
    
    self.map = [[RefugeMap alloc] init];
    self.mapDelegate = [[MockRefugeMapDelegate alloc] init];
    self.restroom = [[RefugeRestroom alloc] init];
    self.mapPin = [[RefugeMapPin alloc] initWithRestroom:self.restroom];
    
    self.map.mapDelegate = self.mapDelegate;
}

- (void)tearDown
{
    self.map = nil;
    self.mapDelegate = nil;
    self.restroom = nil;
    self.mapPin = nil;
    
    [super tearDown];
}

//- (void)testThatMapExists
//{
//    XCTAssertNotNil(self.map, @"Should be able to create a new Map instance");
//}
//
//- (void)testAddAnnotationDoesNotCauseError
//{
//    XCTAssertNoThrow([self.map addAnnotation:self.mapPin], @"Should be able to call addAnnotation method on Map");
//}
//
//- (void)testAddAnnotationsDoesNotCauseError
//{
//    XCTAssertNoThrow([self.map addAnnotations:[NSArray arrayWithObject:self.mapPin]], @"Should be able to call addAnnotations method on Map");
//}
//
//
//- (void)testNonConformingObjectCannoBeDelegate
//{
//    XCTAssertThrows(self.map.mapDelegate = (id<RefugeMapDelegate>)[NSNull null], @"NSNull should not be used as the delegate as it doesn't conform to the delegate protocol");
//}
//
//- (void)testConformingObjectCanBeDelegate
//{
//    MockRefugeMapDelegate *testDelegate = [[MockRefugeMapDelegate alloc] init];
//    
//    XCTAssertNoThrow(self.map.mapDelegate = testDelegate, @"Object conforming to the delegate protocol shold be used as the delegate");
//}
//- (void)testTouchingAnnotationNotifiesDelegate
//{
//    MKAnnotationView *annotationView = [[MKAnnotationView alloc] init];
//    annotationView.annotation = self.mapPin;
//    
//    [self.map mapView:nil annotationView:annotationView calloutAccessoryControlTapped:nil];
//    
//    XCTAssertTrue(self.mapDelegate.wasNotifiedOfCalloutBeingTapped, @"Delegate sholud be notified when callout is tapped.");
//}

@end
