//
//  RRObjectConfigurationTests.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/15/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "RRObjectConfiguration.h"
#import "RestroomManager.h"

@interface RRObjectConfigurationTests : XCTestCase

@end

@implementation RRObjectConfigurationTests
{
    RRObjectConfiguration *objectConfiguration;
}

- (void)setUp
{
    [super setUp];
    
    objectConfiguration = [[RRObjectConfiguration alloc] init];
}

- (void)tearDown
{
    objectConfiguration = nil;
    
    [super tearDown];
}

- (void)testConfigurationOfCreatedRestroomManager
{
    RestroomManager *restroomManager = [objectConfiguration restroomManager];
    
    XCTAssertNotNil(restroomManager, @"The RestroomManager should exist.");
    XCTAssertNotNil(restroomManager.restroomCommunicator, @"RestroomManager should have a RestroomCommunicator.");
    XCTAssertNotNil(restroomManager.restroomBuilder, @"RestroomManager should have a RestroomBuilder.");
    XCTAssertEqualObjects(restroomManager.restroomCommunicator.delegate, restroomManager, @"The RestroomManager should be the RestroomCommunicator's delegate.");
}

@end
