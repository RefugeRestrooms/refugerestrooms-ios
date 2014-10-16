//
//  RRMapViewControllerTests.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/14/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import <objc/runtime.h>

#import "RRMapViewController.h"
#import "Restroom.h"

@interface RRMapViewControllerTests : XCTestCase

@end

@implementation RRMapViewControllerTests
{
    RRMapViewController *mapViewController;
}

- (void)setUp
{
    [super setUp];
    
    mapViewController = [[RRMapViewController alloc ] init];
}

- (void)tearDown
{
    mapViewController = nil;
    
    [super tearDown];
}

- (void)testMapViewControllerHasMapViewProperty
{
    objc_property_t mapViewProperty = class_getProperty([mapViewController class], "mapView");
    
    XCTAssertTrue(mapViewProperty != NULL, @"Map view controller should have a map view.");
}

#warning unimplemented test
- (void)testAnnotationsSavedToCoreDataUponApplicationLaunch
{
    
}

#warning unimplemented test
- (void)testExistingAnnotationsNotRecreated
{
    
}

- (void)testMapViewControllerConformsToRestroomManagerDelegateProtocol
{
    XCTAssertTrue([mapViewController conformsToProtocol:@protocol(RestroomManagerDelegate)], @"Map view controller needs to be a RestroomManager delegate.");
}

- (void)testThatDownloadedRestroomsAreAddedToRestroomList
{
    Restroom *testRestroom = [[Restroom alloc] init];
    
    [self didReceiveRestrooms:[NSArray arrayWithObject:testRestroom]];
    
    XCTAssertEqualObject([mapViewController.restroomsList lastObject], testRestroom, @"Map view controller should receive new Restroom received.");
}

@end
