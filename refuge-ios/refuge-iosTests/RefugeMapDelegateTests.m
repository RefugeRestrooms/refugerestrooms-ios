//
//  RefugeMapDelegateTests.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/11/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "RefugeMap.h"
#import "RefugeMapPin.h"
#import "RefugeRestroom.h"
#import "MockRefugeMapDelegate.h"

@interface RefugeMapDelegateTests : XCTestCase

@property (nonatomic, strong) RefugeMap *map;
@property (nonatomic, strong) MockRefugeMapDelegate *delegate;

@end

@implementation RefugeMapDelegateTests

- (void)setUp
{
    [super setUp];
    
    self.map = [[RefugeMap alloc] init];
    self.delegate = [[MockRefugeMapDelegate alloc] init];
    
    self.map.mapDelegate = self.delegate;
}

- (void)tearDown
{
    self.map = nil;
    self.delegate = nil;
    
    [super tearDown];
}

- (void)testTouchingAnnotationNotifiesDelegate
{
    RefugeRestroom *restroom = [[RefugeRestroom alloc] init];
    RefugeMapPin *mapPin = [[RefugeMapPin alloc] initWithRestroom:restroom];
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] init];
    annotationView.annotation = mapPin;
    
    [self.map mapView:nil annotationView:annotationView calloutAccessoryControlTapped:nil];
    
    XCTAssertTrue(self.delegate.wasNotifiedOfCalloutBeingTapped, @"Delegate sholud be notified when callout is tapped.");
}

@end
