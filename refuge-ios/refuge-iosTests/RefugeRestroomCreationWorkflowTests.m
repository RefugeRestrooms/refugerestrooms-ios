//
//  RefugeRestroomCreationWorkflowTests.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/5/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "MockRefugeRestroomBuilder.h"
#import "MockRefugeRestroomCommunicator.h"
#import "MockRefugeRestroomManagerDelegate.h"
#import "RefugeRestroom.h"
#import "RefugeRestroomManager.h"

@interface RefugeRestroomCreationWorkflowTests : XCTestCase

@end

@implementation RefugeRestroomCreationWorkflowTests
{
    RefugeRestroomManager *restroomManager;
    MockRefugeRestroomManagerDelegate *delegate;
    MockRefugeRestroomBuilder *restroomBuilder;
    NSError *underlyingError;
    NSArray *jsonObjects;
    NSArray *restrooms;
}

- (void)setUp
{
    [super setUp];
    
    restroomManager = [[RefugeRestroomManager alloc] init];
    delegate = [[MockRefugeRestroomManagerDelegate alloc] init];
    restroomBuilder = [[MockRefugeRestroomBuilder alloc] init];
    underlyingError = [NSError errorWithDomain:@"Test Domain" code:0 userInfo:nil];
    jsonObjects = [NSArray array];
    
    RefugeRestroom *restroom = [[RefugeRestroom alloc] init];
    restrooms = [NSArray arrayWithObject:restroom];
    
    restroomManager.delegate = delegate;
    restroomManager.restroomBuilder = restroomBuilder;
}

- (void)tearDown
{
    restroomManager = nil;
    delegate = nil;
    restroomBuilder = nil;
    underlyingError = nil;
    jsonObjects = nil;
    restrooms = nil;
    
    [super tearDown];
}

@end