//
//  RefugeRestroomManagerTests.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/5/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "MockRefugeRestroomManagerDelegate.h"
#import "RefugeRestroomManager.h"

@interface RefugeRestroomManagerTests : XCTestCase

@property (nonatomic, strong) RefugeRestroomManager *restroomManager;

@end

@implementation RefugeRestroomManagerTests

- (void)setUp
{
    [super setUp];
    
    self.restroomManager = [[RefugeRestroomManager alloc] init];
}

- (void)tearDown
{
    self.restroomManager = nil;
    
    [super tearDown];
}

- (void)testThatRestroomManagerExists
{
    XCTAssertNotNil(self.restroomManager, @"Should be able to create a new RestroomManager instance");
}

- (void)testNonConformingObjectCannoBeDelegate
{
    XCTAssertThrows(self.restroomManager.delegate = (id<RefugeRestroomManagerDelegate>)[NSNull null], @"NSNull should not be used as the delegate as it doesn't conform to the delegate protocol");
}

- (void)testConformingObjectCanBeDelegate
{
    MockRefugeRestroomManagerDelegate *delegate = [[MockRefugeRestroomManagerDelegate alloc] init];
    
    XCTAssertNoThrow(self.restroomManager.delegate = delegate, @"Object conforming to the delegate protocol shold be used as the delegate");
}

- (void)testManagerAcceptsNilAsADelegate
{
    XCTAssertNoThrow(self.restroomManager.delegate = nil, @"Manager should accept nil as a delegate");
}

@end
