//
//  RefugeMapPlottingWorkflowTests.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/9/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "RefugeRestroomManager.h"
#import "MockRefugeDataPersistenceManager.h"

@interface RefugeMapPlottingWorkflowTests : XCTestCase

@property (nonatomic, strong) RefugeRestroomManager *restroomManager;
@property (nonatomic, strong) MockRefugeDataPersistenceManager *dataPersistenceManager;

@end

@implementation RefugeMapPlottingWorkflowTests

- (void)setUp
{
    [super setUp];
    
    self.restroomManager = [[RefugeRestroomManager alloc] init];
    self.dataPersistenceManager = [[MockRefugeDataPersistenceManager alloc] init];
    
    self.restroomManager.dataPersistenceManager = self.dataPersistenceManager;
}

- (void)tearDown
{
    self.restroomManager = nil;
    self.dataPersistenceManager = nil;
    
    [super tearDown];
}

- (void)testThatAskingManagerToFetchRestroomsFromLocalStoreAsksDataPersistenceManager
{
    [self.restroomManager restroomsFromLocalStore];
    
    XCTAssertTrue(self.dataPersistenceManager.wasAskedForAllRestrooms, @"Data Persistence Manager should be asked to fetch Restrooms when RestroomManager asked for Restrooms from local store");
}

@end
