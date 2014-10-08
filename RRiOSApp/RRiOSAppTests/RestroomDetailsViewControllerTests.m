//
//  RestroomDetailsViewControllerTests.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/6/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "RestroomDetailsViewController.h"

@interface RestroomDetailsViewControllerTests : XCTestCase

@end

@implementation RestroomDetailsViewControllerTests
{
    RestroomDetailsViewController *restroomDetailsViewController;
    Restroom *restroom;
}

- (void)setUp
{
    [super setUp];
    
    restroomDetailsViewController = [[RestroomDetailsViewController alloc] init];
    restroom = [[Restroom alloc] init];
    
    restroomDetailsViewController.restroom = restroom;
}

- (void)tearDown
{
    restroomDetailsViewController = nil;
    restroom = nil;

    [super tearDown];
}

- (void)testThatRestroomDetailsViewControllerCanBeCreated
{
    XCTAssertNotNil(restroomDetailsViewController, @"Should be able to create a RestroomDetailsViewController instance.");
}

@end
