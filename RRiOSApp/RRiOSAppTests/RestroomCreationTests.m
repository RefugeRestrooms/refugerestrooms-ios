//
//  RestroomCreationTests.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 9/29/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "MockRestroomManagerDelegate.h"
#import "RestroomManager.h"

@interface RestroomCreationTests : XCTestCase

@end

@implementation RestroomCreationTests
{
    RestroomManager *restroomManager;
}

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    restroomManager = [[RestroomManager alloc] init];
}

- (void)tearDown
{
    restroomManager = nil;
    
    [super tearDown];
}

- (void)testThatARestroomManagerCanBeCreated
{
    XCTAssertNotNil(restroomManager, @"Should be able to create a RestroomManager instance.");
}

- (void)testNonConformingObjectCannotBeDelegate
{
    XCTAssertThrows(restroomManager.delegate = (id <RestroomManagerDelegate>)[NSNull null], @"NSNull should not be used as the delegate as it doesn't conform to the delegate protocol.");
}

- (void)testConformingObjectCanBeDelegate
{
    id <RestroomManagerDelegate> delegate = [[MockRestroomManagerDelegate alloc] init];
    
    XCTAssertNoThrow(restroomManager.delegate = delegate, @"Object conforming to the delegate protocol should be used as the delegate.");
}

- (void)testManagerAcceptsNilAsDelegate
{
    XCTAssertNoThrow(restroomManager.delegate = nil, @"It should be acceptable to use nil as an object's delegate.");
}

@end
