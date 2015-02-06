//
//  RefugeRestroomCommunicatorTests.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/5/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "MockRefugeRestroomCommunicatorDelegate.h"
#import "RefugeHTTpSessionManager.h"
#import "RefugeRestroomCommunicator.h"
#import "RefugeRestroomCommunicatorDelegate.h"

@interface RefugeRestroomCommunicatorTests : XCTestCase

@property (nonatomic, strong) RefugeRestroomCommunicator *restroomCommunicator;

@end

@implementation RefugeRestroomCommunicatorTests

- (void)setUp
{
    [super setUp];
    
    self.restroomCommunicator = [[RefugeRestroomCommunicator alloc] init];
}

- (void)tearDown
{
    self.restroomCommunicator = nil;
    
    [super tearDown];
}

- (void)testThatRestroomCommunicatorExists
{
    XCTAssertNotNil(self.restroomCommunicator, @"Should be able to create a new Restroom Communicator instance");
}

- (void)testNonConformingObjectCannoBeDelegate
{
    XCTAssertThrows(self.restroomCommunicator.delegate = (id<RefugeRestroomCommunicatorDelegate>)[NSNull null], @"NSNull should not be used as the delegate as it doesn't conform to the delegate protocol");
}

- (void)testConformingObjectCanBeDelegate
{
    MockRefugeRestroomCommunicatorDelegate *delegate = [[MockRefugeRestroomCommunicatorDelegate alloc] init];
    
    XCTAssertNoThrow(self.restroomCommunicator.delegate = delegate, @"Object conforming to the delegate protocol shold be used as the delegate");
}

- (void)testCommunicatorAcceptsNilAsADelegate
{
    XCTAssertNoThrow(self.restroomCommunicator.delegate = nil, @"Communicator should accept nil as a delegate");
}

- (void)testHttpSessionManagerHasResponseSerializerSetInInit
{
    XCTAssertNotNil(self.restroomCommunicator.httpSessionManager.responseSerializer, @"HttpSessionManager should have responseSerializer set in init");
}

- (void)testHttpSessionManagerHasRequestSerializerSetInInit
{
    XCTAssertNotNil(self.restroomCommunicator.httpSessionManager.requestSerializer, @"HttpSessionManager should have requestSerializer set in init");
}

@end
